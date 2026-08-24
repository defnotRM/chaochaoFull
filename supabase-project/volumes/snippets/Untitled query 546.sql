DO $$
BEGIN
  INSERT INTO RentalOrder (user_id, item_id, start_date, end_date, rental_fee, deposit, status)
  VALUES ('a4444444-4444-4444-4444-444444444444', 'b3333333-3333-3333-3333-333333333333',
          '2026-08-07', '2026-08-09', 900, 3000, 'requested');
  INSERT INTO test_results VALUES (1, 'กันจองสินค้าซ้อนวัน (EXCLUDE)', 'FAIL', 'insert ผ่านทั้งที่ควร error');
EXCEPTION WHEN exclusion_violation THEN
  INSERT INTO test_results VALUES (1, 'กันจองสินค้าซ้อนวัน (EXCLUDE)', 'PASS', NULL);
END $$;