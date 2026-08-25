import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const dynamic = "force-dynamic";

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = searchParams.get("q")?.trim() || "";
    const roleFilter = searchParams.get("role")?.trim() || "all";

    const admin = createAdminClient();

    // 0. Auto-sync any auth users missing from useraccount
    try {
      const { data: authUsers } = await admin.auth.admin.listUsers({
        page: 1,
        perPage: 1000,
      });

      if (authUsers?.users && authUsers.users.length > 0) {
        for (const au of authUsers.users) {
          try {
            const uName =
              au.user_metadata?.username ||
              au.email?.split("@")[0] ||
              "ผู้ใช้งาน";
            const uEmail = au.email || `${uName}@chaochao.local`;
            const uNatId = au.user_metadata?.national_id || null;

            const { data: existing } = await admin
              .from("useraccount")
              .select("user_id")
              .eq("user_id", au.id)
              .maybeSingle();

            if (!existing) {
              await admin.from("useraccount").upsert(
                {
                  user_id: au.id,
                  username: uName,
                  email: uEmail,
                  national_id: uNatId,
                  status: "Active",
                },
                { onConflict: "user_id" }
              );
            }

            const uRole =
              au.user_metadata?.signup_role ||
              au.user_metadata?.role ||
              "renter";
            const rolesToAssign =
              uRole === "both" ? ["renter", "lender"] : [uRole];
            const { data: roleRows } = await admin
              .from("role")
              .select("role_id, role_type")
              .in("role_type", rolesToAssign);

            if (roleRows && roleRows.length > 0) {
              for (const r of roleRows) {
                await admin.from("user_role_assignment").upsert(
                  { user_id: au.id, role_id: r.role_id },
                  { onConflict: "user_id,role_id" }
                );
              }
            }
          } catch (innerErr) {
            console.error("User sync individual error:", au.id, innerErr);
          }
        }
      }
    } catch (listErr) {
      console.error("Auto-sync listUsers error:", listErr);
    }

    // 1. Fetch active users (include all non-suspended users)
    let query = admin
      .from("useraccount")
      .select("user_id, username, bio, avatar_url, banner_url, status, updated_at, created_at")
      .neq("status", "Suspended")
      .neq("status", "Banned")
      .order("created_at", { ascending: false });

    if (q) {
      query = query.or(`username.ilike.%${q}%,bio.ilike.%${q}%`);
    }

    const { data: users, error: usersError } = await query;

    if (usersError) {
      console.error("Error fetching users:", usersError);
      return NextResponse.json(
        { message: "เกิดข้อผิดพลาดในการโหลดข้อมูลผู้ใช้งาน" },
        { status: 500 }
      );
    }

    if (!users || users.length === 0) {
      return NextResponse.json({ users: [] });
    }

    const userIds = users.map((u) => u.user_id);

    // 2. Fetch roles for these users
    const { data: roleAssignments } = await admin
      .from("user_role_assignment")
      .select("user_id, role ( role_type )")
      .in("user_id", userIds);

    const rolesMap = new Map<string, string[]>();
    (roleAssignments || []).forEach((ra: any) => {
      const current = rolesMap.get(ra.user_id) || [];
      if (ra.role?.role_type) current.push(ra.role.role_type);
      rolesMap.set(ra.user_id, current);
    });

    // 3. Count active rental items for each user
    const { data: itemCounts } = await admin
      .from("item")
      .select("user_id")
      .in("user_id", userIds)
      .eq("status", "available");

    const itemCountMap = new Map<string, number>();
    (itemCounts || []).forEach((it) => {
      itemCountMap.set(it.user_id, (itemCountMap.get(it.user_id) || 0) + 1);
    });

    // 4. Format & Filter by role
    let formattedUsers = users.map((u) => {
      const roles = rolesMap.get(u.user_id) || [];
      const isLender = roles.includes("lender");
      const isRenter = roles.includes("renter");
      const isAdmin = roles.includes("admin");

      const primaryRole = isAdmin
        ? "admin"
        : isLender && isRenter
        ? "both"
        : isLender
        ? "lender"
        : "renter";

      const roleLabel = isAdmin
        ? "ผู้ดูแลระบบ"
        : isLender && isRenter
        ? "ผู้ให้เช่า / ผู้เช่า"
        : isLender
        ? "ผู้ให้เช่า"
        : "ผู้เช่า";

      const v = u.updated_at
        ? new Date(u.updated_at).getTime()
        : Date.now();

      return {
        id: u.user_id,
        username: u.username,
        bio: u.bio || "",
        avatarUrl: u.avatar_url ? `/api/avatar?id=${u.user_id}&v=${v}` : null,
        bannerUrl: u.banner_url ? `/api/banner?id=${u.user_id}&v=${v}` : null,
        role: roleLabel,
        primaryRole,
        itemCount: itemCountMap.get(u.user_id) || 0,
        createdAt: u.created_at,
      };
    });

    if (roleFilter === "lender") {
      formattedUsers = formattedUsers.filter(
        (u) => u.primaryRole === "lender" || u.primaryRole === "both"
      );
    } else if (roleFilter === "renter") {
      formattedUsers = formattedUsers.filter(
        (u) => u.primaryRole === "renter" || u.primaryRole === "both"
      );
    }

    return NextResponse.json(
      { users: formattedUsers },
      {
        headers: {
          "Cache-Control": "no-cache, no-store, must-revalidate",
          Pragma: "no-cache",
        },
      }
    );
  } catch (error) {
    console.error("Users GET error:", error);
    return NextResponse.json(
      { message: "เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์" },
      { status: 500 }
    );
  }
}
