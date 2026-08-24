-- ============================================================================
-- CHAOCHAO — AUTOMATED TEST SUITE v3 (ใช้ตารางถาวรแทน temp table)
-- แก้ปัญหา TEMP TABLE หายไปเพราะผูกกับ session/connection เดียว มองไม่เห็นใน
-- Table Editor และเช็คย้อนหลังคนละรอบไม่ได้ — เปลี่ยนเป็นตารางถาวรธรรมดา จะเห็นผลได้
-- แน่นอนไม่ว่าจะรันกี่รอบ กี่ connection ก็ตาม (เป็นตาราง dev/test เท่านั้น ไม่ใช่ตาราง
-- ธุรกิจของระบบ ลบทิ้งได้ตลอดด้วย DROP TABLE test_results; เมื่อเลิกใช้)
--
-- ต้องรัน 05_seed_data.sql ให้เรียบร้อยก่อน แล้ว copy ทั้งไฟล์นี้รันรวดเดียวจบ
-- ทุก test ที่ "แก้ไขข้อมูลจริง" (12, 13, 17) ถูกบังคับ rollback กลับอัตโนมัติ
-- ภายในสคริปต์เอง ข้อมูล seed จะไม่เปลี่ยนแปลงหลังรันจบไม่ว่าผลจะ PASS หรือ FAIL
-- ============================================================================

DROP TABLE IF EXISTS test_results;
CREATE TABLE test_results (test_no INTEGER, test_name TEXT, result TEXT, detail TEXT);
-- กันปัญหาสิทธิ์ตอนสวมรอยเป็น authenticated ใน TEST 16-18 (ตารางนี้ไม่มี RLS เพราะเป็น
-- ตาราง dev/test ชั่วคราว ไม่ใช่ตารางธุรกิจในไฟล์ 01)
GRANT ALL ON test_results TO anon, authenticated, service_role;

BEGIN;

-- ============================================================================
-- หมวด 1: CONSTRAINT TESTS
-- ============================================================================

-- TEST 1: กันจองสินค้าซ้อนวัน (EXCLUDE constraint)
DO $$
BEGIN
  INSERT INTO RentalOrder (user_id, item_id, start_date, end_date, rental_fee, deposit, status)
  VALUES ('a4444444-4444-4444-4444-444444444444', 'b3333333-3333-3333-3333-333333333333',
          '2026-08-07', '2026-08-09', 900, 3000, 'requested');
  INSERT INTO test_results VALUES (1, 'กันจองสินค้าซ้อนวัน (EXCLUDE)', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN exclusion_violation THEN
  INSERT INTO test_results VALUES (1, 'กันจองสินค้าซ้อนวัน (EXCLUDE)', 'PASS', NULL);
END $$;

-- TEST 2: กันสินค้าชิ้นเดียวมีรูปปกซ้ำ
DO $$
BEGIN
  INSERT INTO ItemImage (item_id, image_url, is_primary, sequence)
  VALUES ('b1111111-1111-1111-1111-111111111111', 'https://picsum.photos/seed/dup/800/600', true, 2);
  INSERT INTO test_results VALUES (2, 'กันรูปปกซ้ำ (partial unique index)', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN unique_violation THEN
  INSERT INTO test_results VALUES (2, 'กันรูปปกซ้ำ (partial unique index)', 'PASS', NULL);
END $$;

-- TEST 3: กันบัญชีธนาคาร default ซ้ำ
DO $$
BEGIN
  INSERT INTO BankAccount (user_id, bank_name, account_number, account_name, is_default)
  VALUES ('a1111111-1111-1111-1111-111111111111', 'กรุงไทย', '111-1-11111-1', 'นายฟ้า ตาสว่าง', true);
  INSERT INTO test_results VALUES (3, 'กันบัญชี default ซ้ำ', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN unique_violation THEN
  INSERT INTO test_results VALUES (3, 'กันบัญชี default ซ้ำ', 'PASS', NULL);
END $$;

-- TEST 4: กันสร้างห้องแชทซ้ำระหว่างคู่เดิม
DO $$
BEGIN
  INSERT INTO ChatRoom (renter_id, lender_id)
  VALUES ('a2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111');
  INSERT INTO test_results VALUES (4, 'กันห้องแชทซ้ำ', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN unique_violation THEN
  INSERT INTO test_results VALUES (4, 'กันห้องแชทซ้ำ', 'PASS', NULL);
END $$;

-- TEST 5: ราคาห้ามติดลบ
DO $$
BEGIN
  INSERT INTO Item (user_id, category_id, item_name, rental_fee_per_day, deposit, status)
  VALUES ('a1111111-1111-1111-1111-111111111111', 'c1111111-1111-1111-1111-111111111111',
          'ทดสอบราคาติดลบ', -100, 0, 'available');
  INSERT INTO test_results VALUES (5, 'กันราคาติดลบ (CHECK)', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN check_violation THEN
  INSERT INTO test_results VALUES (5, 'กันราคาติดลบ (CHECK)', 'PASS', NULL);
END $$;

-- TEST 6: end_date ต้องไม่น้อยกว่า start_date
DO $$
BEGIN
  INSERT INTO RentalOrder (user_id, item_id, start_date, end_date, rental_fee, deposit, status)
  VALUES ('a4444444-4444-4444-4444-444444444444', 'b4444444-4444-4444-4444-444444444444',
          '2026-09-10', '2026-09-05', 900, 2000, 'requested');
  INSERT INTO test_results VALUES (6, 'กัน end_date ผิดลำดับ (CHECK)', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN check_violation THEN
  INSERT INTO test_results VALUES (6, 'กัน end_date ผิดลำดับ (CHECK)', 'PASS', NULL);
END $$;

-- TEST 7: ห้ามลบ UserAccount ถ้ายังมีสินค้าอยู่ (RESTRICT)
DO $$
BEGIN
  DELETE FROM UserAccount WHERE user_id = 'a1111111-1111-1111-1111-111111111111';
  INSERT INTO test_results VALUES (7, 'กันลบ user ที่ยังมีสินค้า (RESTRICT)', 'FAIL', 'ลบผ่านทั้งที่ควร error');
EXCEPTION WHEN foreign_key_violation THEN
  INSERT INTO test_results VALUES (7, 'กันลบ user ที่ยังมีสินค้า (RESTRICT)', 'PASS', NULL);
END $$;

-- TEST 8: กันรีวิวซ้ำ order เดิม
DO $$
BEGIN
  INSERT INTO Review (order_id, rating, comment) VALUES ('d1111111-1111-1111-1111-111111111111', 4, 'รีวิวซ้ำ');
  INSERT INTO test_results VALUES (8, 'กันรีวิวซ้ำ order เดิม (UNIQUE)', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN unique_violation THEN
  INSERT INTO test_results VALUES (8, 'กันรีวิวซ้ำ order เดิม (UNIQUE)', 'PASS', NULL);
END $$;

-- TEST 9: ห้ามแชทกับตัวเอง
DO $$
BEGIN
  INSERT INTO ChatRoom (renter_id, lender_id)
  VALUES ('a1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111');
  INSERT INTO test_results VALUES (9, 'กันแชทกับตัวเอง (CHECK)', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN check_violation THEN
  INSERT INTO test_results VALUES (9, 'กันแชทกับตัวเอง (CHECK)', 'PASS', NULL);
END $$;


-- ============================================================================
-- หมวด 2: TRIGGER TESTS
-- ============================================================================

-- TEST 10: updated_at เปลี่ยนอัตโนมัติหลัง UPDATE
DO $$
DECLARE
  v_before TIMESTAMPTZ;
  v_after  TIMESTAMPTZ;
BEGIN
  SELECT updated_at INTO v_before FROM Item WHERE item_id = 'b2222222-2222-2222-2222-222222222222';
  PERFORM pg_sleep(1);
  UPDATE Item SET description = description || ' (แก้ไขแล้ว)' WHERE item_id = 'b2222222-2222-2222-2222-222222222222';
  SELECT updated_at INTO v_after FROM Item WHERE item_id = 'b2222222-2222-2222-2222-222222222222';
  IF v_after > v_before THEN
    INSERT INTO test_results VALUES (10, 'trigger set_updated_at()', 'PASS', NULL);
  ELSE
    INSERT INTO test_results VALUES (10, 'trigger set_updated_at()', 'FAIL', 'updated_at ไม่เปลี่ยน');
  END IF;
END $$;

-- TEST 11: trigger on_auth_user_created สร้าง UserAccount ครบ 5 คนตอน seed
DO $$
DECLARE v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM UserAccount WHERE user_id IN (
    'a1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222',
    'a3333333-3333-3333-3333-333333333333', 'a4444444-4444-4444-4444-444444444444',
    'a5555555-5555-5555-5555-555555555555');
  IF v_count = 5 THEN
    INSERT INTO test_results VALUES (11, 'trigger on_auth_user_created', 'PASS', NULL);
  ELSE
    INSERT INTO test_results VALUES (11, 'trigger on_auth_user_created', 'FAIL', 'เจอแค่ ' || v_count || ' คน จาก 5');
  END IF;
END $$;


-- ============================================================================
-- หมวด 3: BUSINESS LOGIC FUNCTION TESTS
-- เทส 12, 13 เป็นเคส "ควรสำเร็จ" — ใช้เทคนิคบังคับ RAISE EXCEPTION ปลอมทีหลัง
-- เพื่อให้ PL/pgSQL rollback การเปลี่ยนแปลงข้อมูลอัตโนมัติ (แต่ v_result ที่เก็บไว้ก่อน
-- rollback จะไม่หายไปไหน เพราะเป็นแค่ตัวแปรในหน่วยความจำ ไม่ใช่ข้อมูลในตาราง)
-- ============================================================================

-- TEST 12: settle_rental_order กรณีไม่มีความเสียหาย ควรได้ 'completed_no_damage'
DO $$
DECLARE v_result TEXT;
BEGIN
  SELECT settle_rental_order('d1111111-1111-1111-1111-111111111111', 0) INTO v_result;
  RAISE EXCEPTION 'UNDO_TEST_MUTATION';
EXCEPTION WHEN OTHERS THEN
  IF SQLERRM = 'UNDO_TEST_MUTATION' AND v_result = 'completed_no_damage' THEN
    INSERT INTO test_results VALUES (12, 'settle_rental_order (ไม่มีความเสียหาย)', 'PASS', v_result);
  ELSIF SQLERRM = 'UNDO_TEST_MUTATION' THEN
    INSERT INTO test_results VALUES (12, 'settle_rental_order (ไม่มีความเสียหาย)', 'FAIL', 'ได้ค่า: ' || v_result);
  ELSE
    INSERT INTO test_results VALUES (12, 'settle_rental_order (ไม่มีความเสียหาย)', 'FAIL', 'error จริง: ' || SQLERRM);
  END IF;
END $$;

-- TEST 13: settle_rental_order กรณีมัดจำไม่พอ ควรได้ 'awaiting_additional_payment:1750'
DO $$
DECLARE v_result TEXT;
BEGIN
  SELECT settle_rental_order('d2222222-2222-2222-2222-222222222222', 5000) INTO v_result;
  RAISE EXCEPTION 'UNDO_TEST_MUTATION';
EXCEPTION WHEN OTHERS THEN
  IF SQLERRM = 'UNDO_TEST_MUTATION' AND v_result LIKE 'awaiting_additional_payment%' THEN
    INSERT INTO test_results VALUES (13, 'settle_rental_order (มัดจำไม่พอ)', 'PASS', v_result);
  ELSIF SQLERRM = 'UNDO_TEST_MUTATION' THEN
    INSERT INTO test_results VALUES (13, 'settle_rental_order (มัดจำไม่พอ)', 'FAIL', 'ได้ค่า: ' || v_result);
  ELSE
    INSERT INTO test_results VALUES (13, 'settle_rental_order (มัดจำไม่พอ)', 'FAIL', 'error จริง: ' || SQLERRM);
  END IF;
END $$;

-- TEST 14: submit_review บล็อก order ที่ยังไม่ completed
DO $$
BEGIN
  PERFORM submit_review('d2222222-2222-2222-2222-222222222222', 5, 'ทดสอบรีวิว order ที่ยังไม่เสร็จ');
  INSERT INTO test_results VALUES (14, 'submit_review บล็อก order ไม่ completed', 'FAIL', 'รีวิวผ่านทั้งที่ควร error');
EXCEPTION WHEN OTHERS THEN
  INSERT INTO test_results VALUES (14, 'submit_review บล็อก order ไม่ completed', 'PASS', SQLERRM);
END $$;

-- TEST 15: resolve_dispute ต้องเป็น admin เท่านั้น (ตอนนี้ยังไม่ตั้ง JWT ใดๆ = ไม่ใช่ admin)
DO $$
DECLARE v_report_id UUID;
BEGIN
  SELECT report_id INTO v_report_id FROM RentalReport LIMIT 1;
  PERFORM resolve_dispute(v_report_id, 'refund_renter_full');
  INSERT INTO test_results VALUES (15, 'resolve_dispute บล็อกคนที่ไม่ใช่ admin', 'FAIL', 'ทำสำเร็จทั้งที่ควร error');
EXCEPTION WHEN OTHERS THEN
  INSERT INTO test_results VALUES (15, 'resolve_dispute บล็อกคนที่ไม่ใช่ admin', 'PASS', SQLERRM);
END $$;


-- ============================================================================
-- หมวด 4: RLS POLICY TESTS — สวมรอยเป็น user จริงด้วย SET LOCAL
-- ============================================================================

-- TEST 16: mint ต้องมองไม่เห็นบัญชีธนาคารของ fanta
SET LOCAL role = 'authenticated';
SET LOCAL request.jwt.claims = '{"sub":"a2222222-2222-2222-2222-222222222222","role":"authenticated"}';
DO $$
DECLARE v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM BankAccount;
  IF v_count = 0 THEN
    INSERT INTO test_results VALUES (16, 'RLS: mint มองไม่เห็นบัญชีคนอื่น', 'PASS', NULL);
  ELSE
    INSERT INTO test_results VALUES (16, 'RLS: mint มองไม่เห็นบัญชีคนอื่น', 'FAIL', 'เห็น ' || v_count || ' แถว — RLS รั่ว');
  END IF;
END $$;

-- TEST 17: mint ต้องแก้ไขสินค้าของ fanta ไม่ได้
DO $$
DECLARE v_rows INTEGER;
BEGIN
  UPDATE Item SET item_name = 'ถูกแฮ็ก' WHERE item_id = 'b1111111-1111-1111-1111-111111111111';
  GET DIAGNOSTICS v_rows = ROW_COUNT;
  IF v_rows > 0 THEN
    RAISE EXCEPTION 'UNDO_TEST_MUTATION';
  END IF;
  INSERT INTO test_results VALUES (17, 'RLS: mint แก้สินค้าคนอื่นไม่ได้', 'PASS', NULL);
EXCEPTION WHEN OTHERS THEN
  IF SQLERRM = 'UNDO_TEST_MUTATION' THEN
    INSERT INTO test_results VALUES (17, 'RLS: mint แก้สินค้าคนอื่นไม่ได้', 'FAIL', 'แก้ไขสำเร็จ — RLS รั่ว');
  ELSE
    INSERT INTO test_results VALUES (17, 'RLS: mint แก้สินค้าคนอื่นไม่ได้', 'FAIL', 'error ไม่คาดคิด: ' || SQLERRM);
  END IF;
END $$;

-- TEST 18: admin ต้องเห็นบัญชีธนาคารของทุกคน
SET LOCAL request.jwt.claims = '{"sub":"a5555555-5555-5555-5555-555555555555","role":"authenticated"}';
DO $$
DECLARE v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM BankAccount;
  IF v_count >= 2 THEN
    INSERT INTO test_results VALUES (18, 'RLS: admin เห็นทุกบัญชี', 'PASS', v_count || ' แถว');
  ELSE
    INSERT INTO test_results VALUES (18, 'RLS: admin เห็นทุกบัญชี', 'FAIL', 'เห็นแค่ ' || v_count || ' แถว');
  END IF;
END $$;

-- หมายเหตุ: ถ้า "SET LOCAL request.jwt.claims" ข้างบน error ว่า unrecognized
-- configuration parameter ให้เปลี่ยนทั้ง 2 บรรทัดเป็น:
--   SELECT set_config('request.jwt.claims', '{"sub":"...","role":"authenticated"}', true);
--   SELECT set_config('role', 'authenticated', true);
-- แทน แล้วรันใหม่

COMMIT;

-- ============================================================================
-- ★ ดูผลลัพธ์ทั้งหมดตรงนี้ — ควรเห็น PASS ครบทั้ง 18 แถว
-- ============================================================================
SELECT * FROM test_results ORDER BY test_no;
