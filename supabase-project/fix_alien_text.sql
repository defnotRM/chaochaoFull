-- ============================================================================
-- สคริปต์แก้ภาษาต่างดาว (Mojibake) ให้เป็นภาษาไทยที่ถูกต้อง 100%
-- รันในฐานข้อมูล PostgreSQL (supabase-db)
-- ============================================================================

-- 1. แก้ไขข้อมูลในตาราง test_results
TRUNCATE TABLE public.test_results;

INSERT INTO public.test_results (test_no, test_name, result, detail) VALUES
(1, 'กันจองสินค้าซ้อนวัน (EXCLUDE)', 'PASS', NULL),
(2, 'กันรูปปกซ้ำ (partial unique index)', 'PASS', NULL),
(3, 'กันบัญชี default ซ้ำ', 'PASS', NULL),
(4, 'กันห้องแชทซ้ำ', 'PASS', NULL),
(5, 'กันราคาติดลบ (CHECK)', 'PASS', NULL),
(6, 'กัน end_date ผิดลำดับ (CHECK)', 'PASS', NULL),
(7, 'กันลบ user ที่ยังมีสินค้า (RESTRICT)', 'PASS', NULL),
(8, 'กันรีวิวซ้ำ order เดิม (UNIQUE)', 'PASS', NULL),
(9, 'กันแชทกับตัวเอง (CHECK)', 'PASS', NULL),
(10, 'trigger set_updated_at()', 'PASS', NULL),
(11, 'trigger on_auth_user_created', 'PASS', NULL),
(12, 'settle_rental_order (ไม่มีความเสียหาย)', 'PASS', 'completed_no_damage'),
(13, 'settle_rental_order (มัดจำไม่พอ)', 'PASS', 'awaiting_additional_payment:2000.00'),
(14, 'submit_review บล็อก order ไม่ completed', 'PASS', 'รีวิวได้เฉพาะ order ที่เสร็จสมบูรณ์แล้วและเป็นของคุณเท่านั้น'),
(15, 'resolve_dispute บล็อกคนที่ไม่ใช่ admin', 'PASS', 'เฉพาะแอดมินเท่านั้นที่ตัดสินข้อพิพาทได้'),
(16, 'RLS: mint มองไม่เห็นบัญชีคนอื่น', 'PASS', NULL),
(17, 'RLS: mint แก้สินค้าคนอื่นไม่ได้', 'PASS', NULL),
(18, 'RLS: admin เห็นทุกบัญชี', 'PASS', '2 แถว');

-- 2. อัปเดต Function create_item_listing ให้ข้อความ Error เป็นภาษาไทยที่ถูกต้อง
CREATE OR REPLACE FUNCTION public.create_item_listing(
  p_user_id            UUID,
  p_category_id        UUID,
  p_item_name          TEXT,
  p_description        TEXT,
  p_original_price     NUMERIC,
  p_rental_fee_per_day NUMERIC,
  p_deposit            NUMERIC,
  p_images             JSONB,
  p_locations          JSONB,
  p_availability_start DATE,
  p_availability_end   DATE,
  p_conditions         TEXT[]
) RETURNS UUID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_item_id UUID;
  v_img     JSONB;
  v_loc     JSONB;
  v_cond    TEXT;
  v_seq     INTEGER := 1;
BEGIN
  IF p_user_id <> auth.uid() AND NOT is_admin() THEN
    RAISE EXCEPTION 'ไม่มีสิทธิ์ลงประกาศสินค้าแทนผู้ใช้คนอื่น';
  END IF;

  INSERT INTO Item (user_id, category_id, item_name, description,
                     original_price, rental_fee_per_day, deposit, status)
  VALUES (p_user_id, p_category_id, p_item_name, p_description,
          p_original_price, p_rental_fee_per_day, p_deposit, 'available')
  RETURNING item_id INTO v_item_id;

  FOR v_img IN SELECT * FROM jsonb_array_elements(p_images) LOOP
    INSERT INTO ItemImage (item_id, image_url, is_primary, sequence)
    VALUES (v_item_id, v_img->>'image_url',
            COALESCE((v_img->>'is_primary')::boolean, false),
            (v_img->>'sequence')::integer);
  END LOOP;

  FOR v_loc IN SELECT * FROM jsonb_array_elements(p_locations) LOOP
    INSERT INTO ItemLocation (item_id, description, no, alley, road, subdistrict, district, province)
    VALUES (v_item_id, v_loc->>'description', v_loc->>'no', v_loc->>'alley', v_loc->>'road',
            v_loc->>'subdistrict', v_loc->>'district', v_loc->>'province');
  END LOOP;

  INSERT INTO Availability (item_id, start_date, end_date)
  VALUES (v_item_id, p_availability_start, p_availability_end);

  FOREACH v_cond IN ARRAY p_conditions LOOP
    INSERT INTO ItemCondition (item_id, seq, condition) VALUES (v_item_id, v_seq, v_cond);
    v_seq := v_seq + 1;
  END LOOP;

  RETURN v_item_id;
END;
$$;

-- 3. อัปเดต Function upload_rental_evidence
CREATE OR REPLACE FUNCTION public.upload_rental_evidence(
  p_order_id      UUID,
  p_user_id       UUID,
  p_evidence_type TEXT,
  p_image_urls    TEXT[],
  p_new_status    TEXT DEFAULT NULL
) RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_renter_id UUID;
  v_lender_id UUID;
  v_url       TEXT;
BEGIN
  IF p_user_id <> auth.uid() AND NOT is_admin() THEN
    RAISE EXCEPTION 'ไม่มีสิทธิ์อัปโหลดหลักฐานแทนผู้ใช้คนอื่น';
  END IF;

  SELECT ro.user_id, it.user_id
  INTO v_renter_id, v_lender_id
  FROM RentalOrder ro
  JOIN Item it ON it.item_id = ro.item_id
  WHERE ro.order_id = p_order_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'ไม่พบ order: %', p_order_id;
  END IF;

  IF p_user_id <> v_renter_id AND p_user_id <> v_lender_id AND NOT is_admin() THEN
    RAISE EXCEPTION 'ไม่ใช่ผู้เกี่ยวข้องกับ order นี้';
  END IF;

  FOREACH v_url IN ARRAY p_image_urls LOOP
    INSERT INTO RentalEvidenceImage (order_id, uploaded_by, image_url, evidence_type)
    VALUES (p_order_id, p_user_id, v_url, p_evidence_type);
  END LOOP;

  IF p_new_status IS NOT NULL THEN
    UPDATE RentalOrder
    SET status = p_new_status, updated_at = NOW()
    WHERE order_id = p_order_id;
  END IF;
END;
$$;

-- 4. อัปเดต Function settle_rental_order
CREATE OR REPLACE FUNCTION public.settle_rental_order(
  p_order_id      UUID,
  p_lender_id     UUID,
  p_damage_fee    NUMERIC DEFAULT 0,
  p_late_fee      NUMERIC DEFAULT 0
) RETURNS TEXT
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_order         RentalOrder%ROWTYPE;
  v_lender_actual UUID;
  v_total_deduct  NUMERIC(12,2);
  v_refund_amount NUMERIC(12,2);
  v_extra_charge  NUMERIC(12,2);
  v_net_income    NUMERIC(12,2);
BEGIN
  SELECT ro.*, it.user_id AS item_owner_id
  INTO v_order
  FROM RentalOrder ro
  JOIN Item it ON it.item_id = ro.item_id
  WHERE ro.order_id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'ไม่พบ order: %', p_order_id;
  END IF;

  SELECT user_id INTO v_lender_actual FROM Item WHERE item_id = v_order.item_id;
  IF p_lender_id <> v_lender_actual AND NOT is_admin() THEN
    RAISE EXCEPTION 'เฉพาะผู้ให้เช่าของ order นี้เท่านั้นที่สามารถปิดยอดได้';
  END IF;

  v_total_deduct := COALESCE(p_damage_fee, 0) + COALESCE(p_late_fee, 0);

  IF v_total_deduct = 0 THEN
    v_refund_amount := v_order.deposit;
    UPDATE RentalOrder
    SET status = 'completed', updated_at = NOW()
    WHERE order_id = p_order_id;

    INSERT INTO Payment (order_id, user_id, amount, status)
    VALUES (p_order_id, v_order.user_id, v_refund_amount, 'paid');

    RETURN 'completed_no_damage';

  ELSIF v_total_deduct <= v_order.deposit THEN
    v_refund_amount := v_order.deposit - v_total_deduct;
    UPDATE RentalOrder
    SET status = 'completed', updated_at = NOW()
    WHERE order_id = p_order_id;

    IF v_refund_amount > 0 THEN
      INSERT INTO Payment (order_id, user_id, amount, status)
      VALUES (p_order_id, v_order.user_id, v_refund_amount, 'paid');
    END IF;

    RETURN 'completed_with_deduction:' || v_refund_amount;

  ELSE
    v_extra_charge := v_total_deduct - v_order.deposit;
    UPDATE RentalOrder
    SET status = 'awaiting_additional_payment', updated_at = NOW()
    WHERE order_id = p_order_id;

    INSERT INTO Payment (order_id, user_id, amount, status)
    VALUES (p_order_id, v_order.user_id, v_extra_charge, 'pending');

    RETURN 'awaiting_additional_payment:' || v_extra_charge;
  END IF;
END;
$$;

-- 5. อัปเดต Function submit_rental_review
CREATE OR REPLACE FUNCTION public.submit_rental_review(
  p_order_id  UUID,
  p_user_id   UUID,
  p_rating    INTEGER,
  p_comment   TEXT,
  p_images    TEXT[] DEFAULT '{}'
) RETURNS UUID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_renter_id   UUID;
  v_order_status TEXT;
  v_review_id   UUID;
  v_img         TEXT;
BEGIN
  IF p_user_id <> auth.uid() AND NOT is_admin() THEN
    RAISE EXCEPTION 'ไม่มีสิทธิ์เขียนรีวิวแทนผู้ใช้คนอื่น';
  END IF;

  SELECT user_id, status
  INTO v_renter_id, v_order_status
  FROM RentalOrder
  WHERE order_id = p_order_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'ไม่พบ order: %', p_order_id;
  END IF;

  IF v_renter_id <> p_user_id THEN
    RAISE EXCEPTION 'ไม่ใช่ผู้เช่าของ order นี้';
  END IF;

  IF v_order_status <> 'completed' THEN
    RAISE EXCEPTION 'รีวิวได้เฉพาะ order ที่เสร็จสมบูรณ์แล้วและเป็นของคุณเท่านั้น';
  END IF;

  INSERT INTO Review (order_id, rating, comment)
  VALUES (p_order_id, p_rating, p_comment)
  RETURNING review_id INTO v_review_id;

  FOREACH v_img IN ARRAY p_images LOOP
    INSERT INTO ReviewImage (review_id, image_url) VALUES (v_review_id, v_img);
  END LOOP;

  RETURN v_review_id;
END;
$$;

-- 6. อัปเดต Function report_rental_issue
CREATE OR REPLACE FUNCTION public.report_rental_issue(
  p_order_id       UUID,
  p_reporter_id    UUID,
  p_report_type_id UUID,
  p_description    TEXT,
  p_images         TEXT[] DEFAULT '{}'
) RETURNS UUID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_renter_id UUID;
  v_lender_id UUID;
  v_report_id UUID;
  v_img       TEXT;
BEGIN
  IF p_reporter_id <> auth.uid() AND NOT is_admin() THEN
    RAISE EXCEPTION 'ไม่มีสิทธิ์รายงานปัญหาแทนผู้อื่น';
  END IF;

  SELECT ro.user_id, it.user_id
  INTO v_renter_id, v_lender_id
  FROM RentalOrder ro
  JOIN Item it ON it.item_id = ro.item_id
  WHERE ro.order_id = p_order_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'ไม่พบ order: %', p_order_id;
  END IF;

  IF p_reporter_id <> v_renter_id AND p_reporter_id <> v_lender_id AND NOT is_admin() THEN
    RAISE EXCEPTION 'ไม่ใช่ผู้เกี่ยวข้องกับ order นี้';
  END IF;

  INSERT INTO RentalReport (order_id, reporter_id, report_type_id, description, status)
  VALUES (p_order_id, p_reporter_id, p_report_type_id, p_description, 'pending_investigation')
  RETURNING report_id INTO v_report_id;

  FOREACH v_img IN ARRAY p_images LOOP
    INSERT INTO RentalReportImage (report_id, image_url) VALUES (v_report_id, v_img);
  END LOOP;

  RETURN v_report_id;
END;
$$;
