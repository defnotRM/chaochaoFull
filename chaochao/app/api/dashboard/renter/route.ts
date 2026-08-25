import { NextRequest, NextResponse } from "next/server";
import { createClient as createServerClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const dynamic = "force-dynamic";

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
    const { data: orders, error } = await admin
      .from("rentalorder")
      .select(`
        order_id,
        user_id,
        item_id,
        start_date,
        end_date,
        rental_fee,
        deposit,
        total_paid,
        status,
        meetup_location,
        return_location,
        created_at,
        item:item_id (
          item_id,
          item_name,
          description,
          rental_fee_per_day,
          deposit,
          status,
          user_id
        )
      `)
      .eq("user_id", userId)
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error fetching renter orders:", error);
      return NextResponse.json({
        orders: [],
        metrics: { active: 0, pending: 0, completed: 0, totalSpent: 0 },
      });
    }

    const orderIds = (orders || []).map((o) => o.order_id);
    const lenderUserIds = Array.from(
      new Set((orders || []).map((o: any) => o.item?.user_id).filter(Boolean))
    );

    const [{ data: lenders }, { data: rawPayments }] = await Promise.all([
      lenderUserIds.length > 0
        ? admin.from("useraccount").select("user_id, username, avatar_url").in("user_id", lenderUserIds)
        : { data: [] },
      orderIds.length > 0
        ? admin.from("payment").select("order_id, status").in("order_id", orderIds)
        : { data: [] },
    ]);

    const lenderMap = new Map<string, any>(
      (lenders || []).map((l) => [l.user_id, l])
    );
    const pendingPaymentOrderIds = new Set(
      (rawPayments || []).filter((p) => p.status === "pending").map((p) => p.order_id)
    );

    const orderList = (orders || []).map((o: any) => {
      const lender = o.item?.user_id ? lenderMap.get(o.item.user_id) : null;
      return {
        ...o,
        item: o.item ? { ...o.item, lender } : null,
        hasPendingPayment: pendingPaymentOrderIds.has(o.order_id),
      };
    });

    // 2. คำนวณสรุปสถิติ
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
