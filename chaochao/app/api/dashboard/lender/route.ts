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
      // Default to yoklnw67 (lender) if not logged in
      userId = "b5041d3d-ba07-4230-96fa-3fbfb4411439";
    }

    // 1. ดึงรายการสินค้าทั้งหมดที่ผู้ให้เช่าคนนี้ลงประกาศไว้
    const { data: rawItems, error: itemsError } = await admin
      .from("item")
      .select("*")
      .eq("user_id", userId)
      .order("created_at", { ascending: false });

    if (itemsError) {
      console.error("Error fetching lender items:", itemsError);
    }

    const items = rawItems || [];
    const categoryIds = Array.from(new Set(items.map((i) => i.category_id).filter(Boolean)));

    const { data: rawCategories } = categoryIds.length > 0
      ? await admin.from("itemcategory").select("*").in("category_id", categoryIds)
      : { data: [] };

    const categoryMap = new Map((rawCategories || []).map((c) => [c.category_id, c]));

    const itemList = items.map((it) => ({
      ...it,
      category: categoryMap.get(it.category_id) || null,
    }));
    const itemIds = itemList.map((i) => i.item_id);

    // 2. ดึงคำขอเช่า/คำสั่งเช่าทั้งหมดที่ส่งเข้ามายังสินค้าของผู้ให้เช่าคนนี้
    let incomingOrders: any[] = [];
    if (itemIds.length > 0) {
      const { data: rawOrders, error: ordersError } = await admin
        .from("rentalorder")
        .select("*")
        .in("item_id", itemIds)
        .order("created_at", { ascending: false });

      if (ordersError) {
        console.error("Error fetching incoming orders:", ordersError);
      } else if (rawOrders && rawOrders.length > 0) {
        const renterUserIds = Array.from(new Set(rawOrders.map((o) => o.user_id).filter(Boolean)));
        const orderIds = rawOrders.map((o) => o.order_id);

        const [{ data: rawRenters }, { data: rawPhones }, { data: rawPayments }] = await Promise.all([
          admin.from("useraccount").select("user_id, username, avatar_url, firstname, lastname").in("user_id", renterUserIds),
          admin.from("userphones").select("user_id, phone").in("user_id", renterUserIds),
          admin.from("payment").select("payment_id, order_id, status").in("order_id", orderIds),
        ]);

        const renterMap = new Map((rawRenters || []).map((u) => [u.user_id, u]));
        const phoneMap = new Map((rawPhones || []).map((p) => [p.user_id, p.phone]));
        const paymentsByOrder = new Map<string, any[]>();
        (rawPayments || []).forEach((p) => {
          const list = paymentsByOrder.get(p.order_id) || [];
          list.push(p);
          paymentsByOrder.set(p.order_id, list);
        });

        const itemById = new Map(itemList.map((i) => [i.item_id, i]));

        incomingOrders = rawOrders.map((o: any) => {
          const payments = paymentsByOrder.get(o.order_id) || [];
          const hasPendingPayment = payments.some((p: any) => p.status === "pending");
          const rUser = renterMap.get(o.user_id);
          const item = itemById.get(o.item_id);

          return {
            ...o,
            item: item ? { item_name: item.item_name } : null,
            hasPendingPayment,
            payment: payments,
            renter: rUser
              ? {
                  username:
                    rUser.username ||
                    `${rUser.firstname || ""} ${rUser.lastname || ""}`.trim() ||
                    "ผู้เช่า",
                  avatarUrl: rUser.avatar_url
                    ? `/api/avatar?id=${rUser.user_id}`
                    : null,
                  phone: phoneMap.get(rUser.user_id) || null,
                }
              : null,
          };
        });
      }
    }

    // 3. คำนวณสรุปสถิติสำหรับผู้ให้เช่า
    const totalItems = itemList.length;
    const availableItems = itemList.filter((i) => i.status === "available").length;
    const rentedItems = itemList.filter((i) => i.status === "rented").length;
    const pendingRequests = incomingOrders.filter(
      (o) => o.status === "requested" || o.status === "awaiting_payment"
    ).length;

    const estimatedIncome = incomingOrders
      .filter(
        (o) =>
          o.status === "paid" ||
          o.status === "completed" ||
          o.status === "item_sent"
      )
      .reduce(
        (sum, o) =>
          sum + (Number(o.rental_fee) || Number(o.total_paid) || 0),
        0
      );

    return NextResponse.json({
      items: itemList,
      incomingOrders,
      metrics: {
        totalItems,
        availableItems,
        rentedItems,
        pendingRequests,
        estimatedIncome,
      },
    });
  } catch (err) {
    console.error("Error in /api/dashboard/lender:", err);
    return NextResponse.json(
      {
        items: [],
        incomingOrders: [],
        metrics: {
          totalItems: 0,
          availableItems: 0,
          rentedItems: 0,
          pendingRequests: 0,
          estimatedIncome: 0,
        },
      },
      { status: 500 }
    );
  }
}
