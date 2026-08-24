DO $$
BEGIN
  INSERT INTO RentalOrder (user_id, item_id, start_date, end_date, rental_fee, deposit, status)
  VALUES ('a4444444-4444-4444-4444-444444444444', 'b3333333-3333-3333-3333-333333333333',
          '2026-08-07', '2026-08-09', 900, 3000, 'requested');
  RAISE NOTICE 'TEST 1 [FAIL]: ระบบยอมให้จองสินค้าซ้อนวันกัน — EXCLUDE constraint ไม่ทำงาน';
EXCEPTION WHEN exclusion_violation THEN
  RAISE NOTICE 'TEST 1 [PASS]: กันจองซ้อนวันได้ถูกต้อง';
END $$;
