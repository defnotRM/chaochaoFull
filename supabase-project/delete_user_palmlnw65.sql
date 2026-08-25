-- ==============================================================================
-- Script to Delete User 'palmlnw65' and All Associated Records
-- ==============================================================================

DO $$
DECLARE
    target_user_ids UUID[];
    uid UUID;
BEGIN
    -- 1. Find all matching user_ids from auth.users and useraccount
    SELECT ARRAY_AGG(DISTINCT id) INTO target_user_ids
    FROM (
        SELECT id FROM auth.users 
        WHERE raw_user_meta_data->>'username' ILIKE 'palmlnw65'
           OR email ILIKE 'palmlnw65@%'
        UNION
        SELECT user_id AS id FROM public.useraccount 
        WHERE username ILIKE 'palmlnw65'
           OR email ILIKE 'palmlnw65@%'
    ) t;

    IF target_user_ids IS NULL OR array_length(target_user_ids, 1) IS NULL THEN
        RAISE NOTICE '>>> ไม่พบผู้ใช้งานที่ชื่อ palmlnw65 ในระบบ (อาจถูกลบไปแล้ว)';
        RETURN;
    END IF;

    RAISE NOTICE '>>> กำลังดำเนินการลบผู้ใช้งาน ID: %', target_user_ids;

    FOREACH uid IN ARRAY target_user_ids
    LOOP
        RAISE NOTICE '>>> กำลังลบข้อมูลทั้งหมดที่เกี่ยวข้องกับ user_id: %', uid;

        -- A. Delete Review Images
        DELETE FROM public.reviewimage 
        WHERE review_id IN (
            SELECT r.review_id FROM public.review r
            JOIN public.rentalorder ro ON r.order_id = ro.order_id
            WHERE ro.user_id = uid 
               OR ro.item_id IN (SELECT item_id FROM public.item WHERE user_id = uid)
        );

        -- B. Delete Reviews
        DELETE FROM public.review 
        WHERE order_id IN (
            SELECT order_id FROM public.rentalorder 
            WHERE user_id = uid 
               OR item_id IN (SELECT item_id FROM public.item WHERE user_id = uid)
        );

        -- C. Delete Rental Evidence Images
        DELETE FROM public.rentalevidenceimage 
        WHERE user_id = uid 
           OR order_id IN (
               SELECT order_id FROM public.rentalorder 
               WHERE user_id = uid 
                  OR item_id IN (SELECT item_id FROM public.item WHERE user_id = uid)
           );

        -- D. Delete Payments
        DELETE FROM public.payment 
        WHERE user_id = uid 
           OR order_id IN (
               SELECT order_id FROM public.rentalorder 
               WHERE user_id = uid 
                  OR item_id IN (SELECT item_id FROM public.item WHERE user_id = uid)
           );

        -- E. Delete Rental Orders (where user is renter OR owner of the item)
        DELETE FROM public.rentalorder 
        WHERE user_id = uid 
           OR item_id IN (SELECT item_id FROM public.item WHERE user_id = uid);

        -- F. Delete Item weak entities (Images, Locations, Conditions, Availability)
        DELETE FROM public.itemimage WHERE item_id IN (SELECT item_id FROM public.item WHERE user_id = uid);
        DELETE FROM public.itemlocation WHERE item_id IN (SELECT item_id FROM public.item WHERE user_id = uid);
        DELETE FROM public.itemcondition WHERE item_id IN (SELECT item_id FROM public.item WHERE user_id = uid);
        DELETE FROM public.availability WHERE item_id IN (SELECT item_id FROM public.item WHERE user_id = uid);

        -- G. Delete Items owned by this user
        DELETE FROM public.item WHERE user_id = uid;

        -- H. Delete Cart items (if table exists)
        BEGIN
            DELETE FROM public.cart WHERE user_id = uid;
        EXCEPTION WHEN undefined_table THEN
            NULL;
        END;

        -- I. Delete User Profile details
        DELETE FROM public.userphones WHERE user_id = uid;
        DELETE FROM public.bankaccount WHERE user_id = uid;
        DELETE FROM public.user_role_assignment WHERE user_id = uid;

        -- J. Delete UserAccount
        DELETE FROM public.useraccount WHERE user_id = uid;

        -- K. Delete Supabase Auth records
        DELETE FROM auth.identities WHERE user_id = uid;
        DELETE FROM auth.sessions WHERE user_id = uid;
        DELETE FROM auth.mfa_factors WHERE user_id = uid;
        DELETE FROM auth.refresh_tokens WHERE session_id IN (SELECT id FROM auth.sessions WHERE user_id = uid);
        DELETE FROM auth.users WHERE id = uid;

        RAISE NOTICE '>>> ลบข้อมูลผู้ใช้ palmlnw65 (user_id: %) และแถวที่เกี่ยวข้องในทุกตารางสำเร็จเรียบร้อยแล้ว!', uid;
    END LOOP;
END $$;
