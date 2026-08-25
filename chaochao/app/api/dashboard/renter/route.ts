import { NextRequest, NextResponse } from "next/server";
import { createClient as createServerClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const dynamic = "force-dynamic";
export const revalidate = 0;

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const requestedUserId = searchParams.get("userId");

    const supabase = await createServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    const admin = createAdminClient();

    let userId = requestedUserId || user?.id;
    if (!userId) {
      userId = "8a88d60a-e2cf-43a6-b4ea-baa9347bfee1"; // Default to romanlnw68
    }

    // 1. ดึงรายการคำสั่งเช่าของผู้เช่าคนนี้
    const { data: rawOrders, error: ordersError } = await admin
      .from("rentalorder")
      .select("*")
      .eq("user_id", userId)
      .order("created_at", { ascending: false });

    if (ordersError) {
      console.error("Error fetching renter orders:", ordersError);
      return NextResponse.json({
        orders: [],
        metrics: { active: 0, pending: 0, completed: 0, totalSpent: 0 },
      });
    }

    const orders = rawOrders || [];
    const itemIds = Array.from(new Set(orders.map((o) => o.item_id).filter(Boolean)));
    const orderIds = orders.map((o) => o.order_id);

    // 2. ดึงข้อมูลสินค้าที่เกี่ยวข้อง
    const { data: rawItems } = itemIds.length > 0
      ? await admin.from("item").select("*").in("item_id", itemIds)
      : { data: [] };

    const items = rawItems || [];
    const lenderIds = Array.from(new Set(items.map((i) => i.user_id).filter(Boolean)));

    // 3. ดึงข้อมูลผู้ให้เช่า (Lenders)
    const { data: rawLenders } = lenderIds.length > 0
      ? await admin
          .from("useraccount")
          .select("user_id, username, avatar_url, firstname, lastname")
          .in("user_id", lenderIds)
      : { data: [] };

    const lenderMap = new Map((rawLenders || []).map((l) => [l.user_id, l]));

    // 4. ดึงข้อมูลการชำระเงิน (Payments)
    const { data: rawPayments } = orderIds.length > 0
      ? await admin
          .from("payment")
          .select("payment_id, order_id, status")
          .in("order_id", orderIds)
      : { data: [] };

    const paymentsByOrder = new Map<string, any[]>();
    (rawPayments || []).forEach((p) => {
      const list = paymentsByOrder.get(p.order_id) || [];
      list.push(p);
      paymentsByOrder.set(p.order_id, list);
    });

    // 5. ประกอบข้อมูล (Enrich in JS)
    const itemMap = new Map(
      items.map((it) => [
        it.item_id,
        {
          ...it,
          lender: lenderMap.get(it.user_id) || null,
        },
      ])
    );

    const orderList = orders.map((o) => {
      const payments = paymentsByOrder.get(o.order_id) || [];
      const hasPendingPayment = payments.some((p) => p.status === "pending");

      return {
        ...o,
        item: itemMap.get(o.item_id) || null,
        payment: payments,
        hasPendingPayment,
      };
    });

    // 6. คำนวณสรุปสถิติ
    const activeStatuses = [
      "requested",
      "awaiting_payment",
      "paid",
      "item_sent",
      "awaiting_additional_payment",
    ];
    const pendingStatuses = ["requested", "awaiting_payment"];
    const completedStatuses = ["completed", "item_returned"];

    const activeCount = orderList.filter((o) =>
      activeStatuses.includes(o.status)
    ).length;
    const pendingCount = orderList.filter((o) =>
      pendingStatuses.includes(o.status)
    ).length;
    const completedCount = orderList.filter((o) =>
      completedStatuses.includes(o.status)
    ).length;
    const totalSpent = orderList
      .filter(
        (o) =>
          o.status === "paid" ||
          o.status === "completed" ||
          o.status === "item_sent"
      )
      .reduce(
        (sum, o) =>
          sum + (Number(o.total_paid) || Number(o.rental_fee) || 0),
        0
      );

    return NextResponse.json({
      orders: orderList,
      metrics: {
        active: activeCount,
        pending: pendingCount,
        completed: completedCount,
        totalSpent,
      },
    });
  } catch (err) {
    console.error("Error in /api/dashboard/renter:", err);
    return NextResponse.json(
      {
        orders: [],
        metrics: { active: 0, pending: 0, completed: 0, totalSpent: 0 },
      },
      { status: 500 }
    );
  }
}
