--
-- PostgreSQL database dump
--



-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP POLICY IF EXISTS userphones_all_own_or_admin ON public.userphones;
DROP POLICY IF EXISTS useraccount_update_own_or_admin ON public.useraccount;
DROP POLICY IF EXISTS useraccount_select_own_or_admin ON public.useraccount;
DROP POLICY IF EXISTS useraccount_insert_self ON public.useraccount;
DROP POLICY IF EXISTS roleassign_select_own_or_admin ON public.user_role_assignment;
DROP POLICY IF EXISTS roleassign_insert_self_non_admin ON public.user_role_assignment;
DROP POLICY IF EXISTS roleassign_delete_admin_only ON public.user_role_assignment;
DROP POLICY IF EXISTS role_select_all ON public.role;
DROP POLICY IF EXISTS reviewimage_write_owner ON public.reviewimage;
DROP POLICY IF EXISTS reviewimage_select_all ON public.reviewimage;
DROP POLICY IF EXISTS review_update_own_or_admin ON public.review;
DROP POLICY IF EXISTS review_select_all ON public.review;
DROP POLICY IF EXISTS review_insert_renter_after_completed ON public.review;
DROP POLICY IF EXISTS reporttype_write_admin ON public.rentalreporttype;
DROP POLICY IF EXISTS reporttype_select_all ON public.rentalreporttype;
DROP POLICY IF EXISTS reportimage_select ON public.rentalreportimage;
DROP POLICY IF EXISTS reportimage_insert_self ON public.rentalreportimage;
DROP POLICY IF EXISTS report_update_admin_only ON public.rentalreport;
DROP POLICY IF EXISTS report_select_participant_or_admin ON public.rentalreport;
DROP POLICY IF EXISTS report_insert_self ON public.rentalreport;
DROP POLICY IF EXISTS rentalorder_update_admin_only ON public.rentalorder;
DROP POLICY IF EXISTS rentalorder_select_participant_or_admin ON public.rentalorder;
DROP POLICY IF EXISTS rentalorder_insert_renter ON public.rentalorder;
DROP POLICY IF EXISTS payment_select_participant_or_admin ON public.payment;
DROP POLICY IF EXISTS message_update_mark_read ON public.message;
DROP POLICY IF EXISTS message_select_participant_or_admin ON public.message;
DROP POLICY IF EXISTS message_insert_participant ON public.message;
DROP POLICY IF EXISTS itemlocation_write_owner ON public.itemlocation;
DROP POLICY IF EXISTS itemlocation_select ON public.itemlocation;
DROP POLICY IF EXISTS itemimage_write_owner ON public.itemimage;
DROP POLICY IF EXISTS itemimage_select ON public.itemimage;
DROP POLICY IF EXISTS itemcondition_write_owner ON public.itemcondition;
DROP POLICY IF EXISTS itemcondition_select ON public.itemcondition;
DROP POLICY IF EXISTS itemcategory_write_admin ON public.itemcategory;
DROP POLICY IF EXISTS itemcategory_select_all ON public.itemcategory;
DROP POLICY IF EXISTS item_update_own_or_admin ON public.item;
DROP POLICY IF EXISTS item_select_available_or_own_or_admin ON public.item;
DROP POLICY IF EXISTS item_insert_own ON public.item;
DROP POLICY IF EXISTS item_delete_own_or_admin ON public.item;
DROP POLICY IF EXISTS evidence_select_participant_or_admin ON public.rentalevidenceimage;
DROP POLICY IF EXISTS evidence_insert_self ON public.rentalevidenceimage;
DROP POLICY IF EXISTS chatroom_select_participant_or_admin ON public.chatroom;
DROP POLICY IF EXISTS chatroom_insert_participant ON public.chatroom;
DROP POLICY IF EXISTS bankaccount_all_own_or_admin ON public.bankaccount;
DROP POLICY IF EXISTS availability_write_owner ON public.availability;
DROP POLICY IF EXISTS availability_select ON public.availability;
ALTER TABLE IF EXISTS ONLY public.userphones DROP CONSTRAINT IF EXISTS userphones_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_role_assignment DROP CONSTRAINT IF EXISTS user_role_assignment_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_role_assignment DROP CONSTRAINT IF EXISTS user_role_assignment_role_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reviewimage DROP CONSTRAINT IF EXISTS reviewimage_review_id_fkey;
ALTER TABLE IF EXISTS ONLY public.review DROP CONSTRAINT IF EXISTS review_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.rentalreportimage DROP CONSTRAINT IF EXISTS rentalreportimage_report_id_fkey;
ALTER TABLE IF EXISTS ONLY public.rentalreport DROP CONSTRAINT IF EXISTS rentalreport_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.rentalreport DROP CONSTRAINT IF EXISTS rentalreport_report_type_id_fkey;
ALTER TABLE IF EXISTS ONLY public.rentalreport DROP CONSTRAINT IF EXISTS rentalreport_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.rentalorder DROP CONSTRAINT IF EXISTS rentalorder_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.rentalorder DROP CONSTRAINT IF EXISTS rentalorder_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.rentalevidenceimage DROP CONSTRAINT IF EXISTS rentalevidenceimage_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.rentalevidenceimage DROP CONSTRAINT IF EXISTS rentalevidenceimage_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payment DROP CONSTRAINT IF EXISTS payment_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payment DROP CONSTRAINT IF EXISTS payment_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.message DROP CONSTRAINT IF EXISTS message_sender_id_fkey;
ALTER TABLE IF EXISTS ONLY public.message DROP CONSTRAINT IF EXISTS message_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.message DROP CONSTRAINT IF EXISTS message_chat_room_id_fkey;
ALTER TABLE IF EXISTS ONLY public.itemlocation DROP CONSTRAINT IF EXISTS itemlocation_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.itemimage DROP CONSTRAINT IF EXISTS itemimage_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.itemcondition DROP CONSTRAINT IF EXISTS itemcondition_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item DROP CONSTRAINT IF EXISTS item_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item DROP CONSTRAINT IF EXISTS item_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.useraccount DROP CONSTRAINT IF EXISTS fk_useraccount_authuser;
ALTER TABLE IF EXISTS ONLY public.chatroom DROP CONSTRAINT IF EXISTS chatroom_renter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chatroom DROP CONSTRAINT IF EXISTS chatroom_lender_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bankaccount DROP CONSTRAINT IF EXISTS bankaccount_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.availability DROP CONSTRAINT IF EXISTS availability_item_id_fkey;
DROP TRIGGER IF EXISTS trg_useraccount_updated_at ON public.useraccount;
DROP TRIGGER IF EXISTS trg_review_updated_at ON public.review;
DROP TRIGGER IF EXISTS trg_rentalreport_updated_at ON public.rentalreport;
DROP TRIGGER IF EXISTS trg_rentalorder_updated_at ON public.rentalorder;
DROP TRIGGER IF EXISTS trg_rentalevidenceimage_updated_at ON public.rentalevidenceimage;
DROP TRIGGER IF EXISTS trg_payment_updated_at ON public.payment;
DROP TRIGGER IF EXISTS trg_itemlocation_updated_at ON public.itemlocation;
DROP TRIGGER IF EXISTS trg_itemimage_updated_at ON public.itemimage;
DROP TRIGGER IF EXISTS trg_item_updated_at ON public.item;
DROP TRIGGER IF EXISTS trg_availability_updated_at ON public.availability;
DROP INDEX IF EXISTS public.idx_useraccount_status;
DROP INDEX IF EXISTS public.idx_review_order_id;
DROP INDEX IF EXISTS public.idx_report_user_id;
DROP INDEX IF EXISTS public.idx_report_status;
DROP INDEX IF EXISTS public.idx_report_order_id;
DROP INDEX IF EXISTS public.idx_rentalorder_user_id;
DROP INDEX IF EXISTS public.idx_rentalorder_status;
DROP INDEX IF EXISTS public.idx_rentalorder_item_id;
DROP INDEX IF EXISTS public.idx_payment_user_id;
DROP INDEX IF EXISTS public.idx_payment_status;
DROP INDEX IF EXISTS public.idx_payment_order_id;
DROP INDEX IF EXISTS public.idx_message_sender_id;
DROP INDEX IF EXISTS public.idx_message_order_id;
DROP INDEX IF EXISTS public.idx_message_chat_room_id_created_at;
DROP INDEX IF EXISTS public.idx_itemlocation_item_id;
DROP INDEX IF EXISTS public.idx_itemimage_one_primary_per_item;
DROP INDEX IF EXISTS public.idx_itemimage_item_id;
DROP INDEX IF EXISTS public.idx_itemcondition_item_id;
DROP INDEX IF EXISTS public.idx_item_user_id;
DROP INDEX IF EXISTS public.idx_item_status;
DROP INDEX IF EXISTS public.idx_item_name_trgm;
DROP INDEX IF EXISTS public.idx_item_category_id;
DROP INDEX IF EXISTS public.idx_evidence_order_id;
DROP INDEX IF EXISTS public.idx_chatroom_renter_id;
DROP INDEX IF EXISTS public.idx_chatroom_lender_id;
DROP INDEX IF EXISTS public.idx_bankaccount_one_default_per_user;
DROP INDEX IF EXISTS public.idx_availability_item_id;
DROP INDEX IF EXISTS public.idx_availability_item_daterange;
ALTER TABLE IF EXISTS ONLY public.userphones DROP CONSTRAINT IF EXISTS userphones_pkey;
ALTER TABLE IF EXISTS ONLY public.useraccount DROP CONSTRAINT IF EXISTS useraccount_pkey;
ALTER TABLE IF EXISTS ONLY public.useraccount DROP CONSTRAINT IF EXISTS useraccount_national_id_key;
ALTER TABLE IF EXISTS ONLY public.useraccount DROP CONSTRAINT IF EXISTS useraccount_email_key;
ALTER TABLE IF EXISTS ONLY public.user_role_assignment DROP CONSTRAINT IF EXISTS user_role_assignment_pkey;
ALTER TABLE IF EXISTS ONLY public.role DROP CONSTRAINT IF EXISTS role_role_type_key;
ALTER TABLE IF EXISTS ONLY public.role DROP CONSTRAINT IF EXISTS role_pkey;
ALTER TABLE IF EXISTS ONLY public.reviewimage DROP CONSTRAINT IF EXISTS reviewimage_pkey;
ALTER TABLE IF EXISTS ONLY public.review DROP CONSTRAINT IF EXISTS review_pkey;
ALTER TABLE IF EXISTS ONLY public.review DROP CONSTRAINT IF EXISTS review_order_id_key;
ALTER TABLE IF EXISTS ONLY public.rentalreporttype DROP CONSTRAINT IF EXISTS rentalreporttype_report_type_key;
ALTER TABLE IF EXISTS ONLY public.rentalreporttype DROP CONSTRAINT IF EXISTS rentalreporttype_pkey;
ALTER TABLE IF EXISTS ONLY public.rentalreportimage DROP CONSTRAINT IF EXISTS rentalreportimage_pkey;
ALTER TABLE IF EXISTS ONLY public.rentalreport DROP CONSTRAINT IF EXISTS rentalreport_pkey;
ALTER TABLE IF EXISTS ONLY public.rentalorder DROP CONSTRAINT IF EXISTS rentalorder_pkey;
ALTER TABLE IF EXISTS ONLY public.rentalevidenceimage DROP CONSTRAINT IF EXISTS rentalevidenceimage_pkey;
ALTER TABLE IF EXISTS ONLY public.payment DROP CONSTRAINT IF EXISTS payment_pkey;
ALTER TABLE IF EXISTS ONLY public.rentalorder DROP CONSTRAINT IF EXISTS no_overlapping_active_bookings;
ALTER TABLE IF EXISTS ONLY public.message DROP CONSTRAINT IF EXISTS message_pkey;
ALTER TABLE IF EXISTS ONLY public.itemlocation DROP CONSTRAINT IF EXISTS itemlocation_pkey;
ALTER TABLE IF EXISTS ONLY public.itemimage DROP CONSTRAINT IF EXISTS itemimage_pkey;
ALTER TABLE IF EXISTS ONLY public.itemcondition DROP CONSTRAINT IF EXISTS itemcondition_pkey;
ALTER TABLE IF EXISTS ONLY public.itemcategory DROP CONSTRAINT IF EXISTS itemcategory_pkey;
ALTER TABLE IF EXISTS ONLY public.itemcategory DROP CONSTRAINT IF EXISTS itemcategory_category_name_key;
ALTER TABLE IF EXISTS ONLY public.item DROP CONSTRAINT IF EXISTS item_pkey;
ALTER TABLE IF EXISTS ONLY public.chatroom DROP CONSTRAINT IF EXISTS chatroom_renter_id_lender_id_key;
ALTER TABLE IF EXISTS ONLY public.chatroom DROP CONSTRAINT IF EXISTS chatroom_pkey;
ALTER TABLE IF EXISTS ONLY public.bankaccount DROP CONSTRAINT IF EXISTS bankaccount_user_id_account_number_key;
ALTER TABLE IF EXISTS ONLY public.bankaccount DROP CONSTRAINT IF EXISTS bankaccount_pkey;
ALTER TABLE IF EXISTS ONLY public.availability DROP CONSTRAINT IF EXISTS availability_pkey;
DROP TABLE IF EXISTS public.userphones;
DROP TABLE IF EXISTS public.user_role_assignment;
DROP TABLE IF EXISTS public.test_results;
DROP TABLE IF EXISTS public.role;
DROP TABLE IF EXISTS public.reviewimage;
DROP TABLE IF EXISTS public.review;
DROP TABLE IF EXISTS public.rentalreporttype;
DROP TABLE IF EXISTS public.rentalreportimage;
DROP TABLE IF EXISTS public.rentalreport;
DROP TABLE IF EXISTS public.rentalorder;
DROP TABLE IF EXISTS public.rentalevidenceimage;
DROP VIEW IF EXISTS public.publicuserprofile;
DROP TABLE IF EXISTS public.useraccount;
DROP TABLE IF EXISTS public.payment;
DROP TABLE IF EXISTS public.message;
DROP TABLE IF EXISTS public.itemlocation;
DROP TABLE IF EXISTS public.itemimage;
DROP TABLE IF EXISTS public.itemcondition;
DROP TABLE IF EXISTS public.itemcategory;
DROP TABLE IF EXISTS public.item;
DROP TABLE IF EXISTS public.chatroom;
DROP TABLE IF EXISTS public.bankaccount;
DROP TABLE IF EXISTS public.availability;
DROP FUNCTION IF EXISTS public.upload_rental_evidence(p_order_id uuid, p_user_id uuid, p_evidence_type text, p_image_urls text[], p_new_status text);
DROP FUNCTION IF EXISTS public.submit_review(p_order_id uuid, p_rating integer, p_comment text, p_image_urls text[]);
DROP FUNCTION IF EXISTS public.submit_report(p_report_type_id uuid, p_user_id uuid, p_order_id uuid, p_report_topic text, p_description text, p_image_urls text[]);
DROP FUNCTION IF EXISTS public.settle_rental_order(p_order_id uuid, p_damage_cost numeric);
DROP FUNCTION IF EXISTS public.set_updated_at();
DROP FUNCTION IF EXISTS public.resolve_dispute(p_report_id uuid, p_outcome text);
DROP FUNCTION IF EXISTS public.owns_item(p_item_id uuid);
DROP FUNCTION IF EXISTS public.is_order_participant(p_order_id uuid);
DROP FUNCTION IF EXISTS public.is_admin();
DROP FUNCTION IF EXISTS public.handle_new_auth_user();
DROP FUNCTION IF EXISTS public.create_item_listing(p_user_id uuid, p_category_id uuid, p_item_name text, p_description text, p_original_price numeric, p_rental_fee_per_day numeric, p_deposit numeric, p_images jsonb, p_locations jsonb, p_availability_start date, p_availability_end date, p_conditions text[]);
DROP FUNCTION IF EXISTS public.confirm_additional_payment(p_payment_id uuid);
DROP TYPE IF EXISTS public.role_type_enum;
DROP SCHEMA IF EXISTS public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: role_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role_type_enum AS ENUM (
    'Admin',
    'Renter',
    'Lender'
);


ALTER TYPE public.role_type_enum OWNER TO postgres;

--
-- Name: confirm_additional_payment(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.confirm_additional_payment(p_payment_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_order_id UUID;
BEGIN
  -- à¸Ÿà¸±à¸‡à¸à¹Œà¸Šà¸±à¸™à¸™à¸µà¹‰à¸„à¸§à¸£à¸–à¸¹à¸à¹€à¸£à¸µà¸¢à¸à¸ˆà¸²à¸ Payment Gateway webhook (à¸œà¹ˆà¸²à¸™ service_role) à¸«à¸£à¸·à¸­ admin à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™
  -- à¹„à¸¡à¹ˆà¸„à¸§à¸£à¹ƒà¸«à¹‰à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸²à¹€à¸£à¸µà¸¢à¸à¹€à¸­à¸‡à¸¡à¸±à¹ˆà¸§à¹† à¹€à¸žà¸£à¸²à¸°à¹€à¸›à¹‡à¸™à¸à¸²à¸£à¸¢à¸·à¸™à¸¢à¸±à¸™à¸§à¹ˆà¸² "à¹€à¸‡à¸´à¸™à¹€à¸‚à¹‰à¸²à¸ˆà¸£à¸´à¸‡" à¸‹à¸¶à¹ˆà¸‡à¸•à¹‰à¸­à¸‡à¸¡à¸²à¸ˆà¸²à¸à¹à¸«à¸¥à¹ˆà¸‡à¸—à¸µà¹ˆà¹€à¸Šà¸·à¹ˆà¸­à¸–à¸·à¸­à¹„à¸”à¹‰
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'à¹€à¸‰à¸žà¸²à¸°à¸£à¸°à¸šà¸šà¸Šà¸³à¸£à¸°à¹€à¸‡à¸´à¸™à¸«à¸£à¸·à¸­à¹à¸­à¸”à¸¡à¸´à¸™à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™à¸—à¸µà¹ˆà¸¢à¸·à¸™à¸¢à¸±à¸™à¸à¸²à¸£à¸ˆà¹ˆà¸²à¸¢à¹€à¸žà¸´à¹ˆà¸¡à¹„à¸”à¹‰';
  END IF;

  UPDATE Payment SET status = 'paid' WHERE payment_id = p_payment_id
  RETURNING order_id INTO v_order_id;

  IF v_order_id IS NULL THEN
    RAISE EXCEPTION 'à¹„à¸¡à¹ˆà¸žà¸š payment: %', p_payment_id;
  END IF;

  UPDATE RentalOrder SET status = 'completed' WHERE order_id = v_order_id;
END;
$$;


ALTER FUNCTION public.confirm_additional_payment(p_payment_id uuid) OWNER TO postgres;

--
-- Name: create_item_listing(uuid, uuid, text, text, numeric, numeric, numeric, jsonb, jsonb, date, date, text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_item_listing(p_user_id uuid, p_category_id uuid, p_item_name text, p_description text, p_original_price numeric, p_rental_fee_per_day numeric, p_deposit numeric, p_images jsonb, p_locations jsonb, p_availability_start date, p_availability_end date, p_conditions text[]) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_item_id UUID;
  v_img     JSONB;
  v_loc     JSONB;
  v_cond    TEXT;
  v_seq     INTEGER := 1;
BEGIN
  -- à¸à¸±à¸™à¹„à¸¡à¹ˆà¹ƒà¸«à¹‰à¹ƒà¸„à¸£à¸¥à¸‡à¸›à¸£à¸°à¸à¸²à¸¨à¸ªà¸´à¸™à¸„à¹‰à¸²à¹à¸—à¸™à¸„à¸™à¸­à¸·à¹ˆà¸™ (à¸•à¹‰à¸­à¸‡à¹€à¸›à¹‡à¸™à¹€à¸ˆà¹‰à¸²à¸‚à¸­à¸‡à¸šà¸±à¸à¸Šà¸µà¸—à¸µà¹ˆà¸¥à¹‡à¸­à¸à¸­à¸´à¸™à¸­à¸¢à¸¹à¹ˆà¸ˆà¸£à¸´à¸‡à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™)
  IF p_user_id <> auth.uid() AND NOT is_admin() THEN
    RAISE EXCEPTION 'à¹„à¸¡à¹ˆà¸¡à¸µà¸ªà¸´à¸—à¸˜à¸´à¹Œà¸¥à¸‡à¸›à¸£à¸°à¸à¸²à¸¨à¸ªà¸´à¸™à¸„à¹‰à¸²à¹à¸—à¸™à¸œà¸¹à¹‰à¹ƒà¸Šà¹‰à¸„à¸™à¸­à¸·à¹ˆà¸™';
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


ALTER FUNCTION public.create_item_listing(p_user_id uuid, p_category_id uuid, p_item_name text, p_description text, p_original_price numeric, p_rental_fee_per_day numeric, p_deposit numeric, p_images jsonb, p_locations jsonb, p_availability_start date, p_availability_end date, p_conditions text[]) OWNER TO postgres;

--
-- Name: handle_new_auth_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_auth_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_role_type TEXT;
  v_role_id   UUID;
BEGIN
  INSERT INTO UserAccount (user_id, username, email, status)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)),
    NEW.email,
    'Pending_Verification'
  );

  -- ถ้าตอนสมัครส่ง role มาด้วย (ผ่าน options.data ตอนเรียก supabase.auth.signUp เช่น
  -- { data: { signup_role: 'renter' } }) ให้ assign role นั้นให้เลยในทีเดียวกัน
  -- (admin assign เองไม่ได้ผ่านทางนี้ ต้องให้ admin คนอื่นเพิ่มให้ผ่าน User_Role_Assignment เท่านั้น)
  v_role_type := NEW.raw_user_meta_data->>'signup_role';
  IF v_role_type IN ('renter', 'lender') THEN
    SELECT role_id INTO v_role_id FROM Role WHERE role_type = v_role_type;
    INSERT INTO User_Role_Assignment (user_id, role_id) VALUES (NEW.id, v_role_id);
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_auth_user() OWNER TO postgres;

--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM User_Role_Assignment ura
    JOIN Role r ON r.role_id = ura.role_id
    WHERE ura.user_id = auth.uid() AND r.role_type = 'admin'
  );
$$;


ALTER FUNCTION public.is_admin() OWNER TO postgres;

--
-- Name: is_order_participant(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_order_participant(p_order_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM RentalOrder ro
    JOIN Item i ON i.item_id = ro.item_id
    WHERE ro.order_id = p_order_id
      AND (ro.user_id = auth.uid() OR i.user_id = auth.uid())
  );
$$;


ALTER FUNCTION public.is_order_participant(p_order_id uuid) OWNER TO postgres;

--
-- Name: owns_item(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.owns_item(p_item_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (SELECT 1 FROM Item WHERE item_id = p_item_id AND user_id = auth.uid());
$$;


ALTER FUNCTION public.owns_item(p_item_id uuid) OWNER TO postgres;

--
-- Name: resolve_dispute(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.resolve_dispute(p_report_id uuid, p_outcome text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_order_id  UUID;
  v_renter_id UUID;
  v_deposit   NUMERIC;
BEGIN
  -- à¸•à¸±à¸”à¸ªà¸´à¸™à¸‚à¹‰à¸­à¸žà¸´à¸žà¸²à¸—à¹„à¸”à¹‰à¹€à¸‰à¸žà¸²à¸°à¹à¸­à¸”à¸¡à¸´à¸™à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™ (à¸•à¸£à¸‡à¸à¸±à¸š UC-08)
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'à¹€à¸‰à¸žà¸²à¸°à¹à¸­à¸”à¸¡à¸´à¸™à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™à¸—à¸µà¹ˆà¸•à¸±à¸”à¸ªà¸´à¸™à¸‚à¹‰à¸­à¸žà¸´à¸žà¸²à¸—à¹„à¸”à¹‰';
  END IF;

  SELECT r.order_id, ro.user_id, ro.deposit
  INTO v_order_id, v_renter_id, v_deposit
  FROM RentalReport r
  JOIN RentalOrder ro ON ro.order_id = r.order_id
  WHERE r.report_id = p_report_id
  FOR UPDATE;

  IF v_order_id IS NULL THEN
    RAISE EXCEPTION 'à¹„à¸¡à¹ˆà¸žà¸šà¸£à¸²à¸¢à¸‡à¸²à¸™: %', p_report_id;
  END IF;

  IF p_outcome NOT IN ('refund_renter_full', 'award_deposit_to_lender') THEN
    RAISE EXCEPTION 'à¸„à¹ˆà¸² outcome à¹„à¸¡à¹ˆà¸–à¸¹à¸à¸•à¹‰à¸­à¸‡: %', p_outcome;
  END IF;

  UPDATE RentalReport SET status = 'resolved', resolved_at = NOW() WHERE report_id = p_report_id;
  UPDATE RentalOrder SET status = 'completed', return_at = NOW() WHERE order_id = v_order_id;

  IF p_outcome = 'refund_renter_full' THEN
    INSERT INTO Payment (order_id, user_id, amount, status)
    VALUES (v_order_id, v_renter_id, v_deposit, 'refunded');
    -- TODO: à¹€à¸£à¸µà¸¢à¸ Payment Gateway à¸„à¸·à¸™à¹€à¸‡à¸´à¸™à¸—à¸±à¹‰à¸‡à¸«à¸¡à¸”à¹ƒà¸«à¹‰à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸² à¹„à¸¡à¹ˆà¸ˆà¹ˆà¸²à¸¢à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸²
  ELSE
    -- award_deposit_to_lender: à¸¡à¸±à¸”à¸ˆà¸³à¸—à¸±à¹‰à¸‡à¸«à¸¡à¸”à¸•à¸à¹€à¸›à¹‡à¸™à¸‚à¸­à¸‡à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸² à¹„à¸¡à¹ˆà¸•à¹‰à¸­à¸‡ INSERT Payment à¸„à¸·à¸™à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸²
    -- TODO: à¹€à¸£à¸µà¸¢à¸ Payment Gateway à¹‚à¸­à¸™à¸¡à¸±à¸”à¸ˆà¸³à¹ƒà¸«à¹‰à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸²
    NULL;
  END IF;
END;
$$;


ALTER FUNCTION public.resolve_dispute(p_report_id uuid, p_outcome text) OWNER TO postgres;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

--
-- Name: settle_rental_order(uuid, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.settle_rental_order(p_order_id uuid, p_damage_cost numeric DEFAULT 0) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_deposit         NUMERIC;
  v_net_income      NUMERIC;
  v_renter_id       UUID;
  v_item_id         UUID;
  v_refund_amount   NUMERIC;
  v_extra_needed    NUMERIC;
BEGIN
  -- à¸¥à¹‡à¸­à¸à¹à¸–à¸§à¹„à¸§à¹‰à¸à¹ˆà¸­à¸™ à¸à¸±à¸™à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸²à¸à¸”à¸›à¸´à¸”à¸­à¸­à¹€à¸”à¸­à¸£à¹Œà¸‹à¹‰à¸³ 2 à¸„à¸£à¸±à¹‰à¸‡à¸žà¸£à¹‰à¸­à¸¡à¸à¸±à¸™
  SELECT deposit, net_income, user_id, item_id
  INTO v_deposit, v_net_income, v_renter_id, v_item_id
  FROM RentalOrder
  WHERE order_id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'à¹„à¸¡à¹ˆà¸žà¸š order: %', p_order_id;
  END IF;

  -- à¹€à¸‰à¸žà¸²à¸°à¹€à¸ˆà¹‰à¸²à¸‚à¸­à¸‡à¸ªà¸´à¸™à¸„à¹‰à¸² (à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸²à¸‚à¸­à¸‡ order à¸™à¸µà¹‰) à¸«à¸£à¸·à¸­ admin à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™à¸—à¸µà¹ˆà¸•à¸±à¸”à¸ªà¸´à¸™à¸„à¹ˆà¸²à¹€à¸ªà¸µà¸¢à¸«à¸²à¸¢à¹„à¸”à¹‰
  IF NOT owns_item(v_item_id) AND NOT is_admin() THEN
    RAISE EXCEPTION 'à¹€à¸‰à¸žà¸²à¸°à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸²à¸‚à¸­à¸‡ order à¸™à¸µà¹‰à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™à¸—à¸µà¹ˆà¸›à¸´à¸”à¸à¸²à¸£à¹€à¸Šà¹ˆà¸²à¹„à¸”à¹‰';
  END IF;

  IF p_damage_cost = 0 THEN
    -- à¸à¸£à¸“à¸µ 1: à¹„à¸¡à¹ˆà¸¡à¸µà¸„à¸§à¸²à¸¡à¹€à¸ªà¸µà¸¢à¸«à¸²à¸¢ â€” à¸„à¸·à¸™à¸¡à¸±à¸”à¸ˆà¸³à¹€à¸•à¹‡à¸¡ + à¸ˆà¹ˆà¸²à¸¢à¸„à¹ˆà¸²à¹€à¸Šà¹ˆà¸²à¹ƒà¸«à¹‰à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸² + à¸›à¸´à¸”à¸­à¸­à¹€à¸”à¸­à¸£à¹Œ
    v_refund_amount := v_deposit;

    INSERT INTO Payment (order_id, user_id, amount, status)
    VALUES (p_order_id, v_renter_id, v_refund_amount, 'refunded');

    UPDATE RentalOrder SET status = 'completed', return_at = NOW() WHERE order_id = p_order_id;

    -- TODO: à¹€à¸£à¸µà¸¢à¸ Payment Gateway à¸ˆà¸£à¸´à¸‡à¸•à¸£à¸‡à¸™à¸µà¹‰ à¹€à¸žà¸·à¹ˆà¸­à¹‚à¸­à¸™ v_refund_amount à¸„à¸·à¸™à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸²
    --       à¹à¸¥à¸°à¹‚à¸­à¸™ v_net_income à¹ƒà¸«à¹‰à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸² â€” DB à¹€à¸à¹‡à¸šà¹à¸„à¹ˆà¸œà¸¥à¸¥à¸±à¸žà¸˜à¹Œ à¹„à¸¡à¹ˆà¹„à¸”à¹‰à¸¢à¸´à¸‡ API à¹€à¸­à¸‡
    RETURN 'completed_no_damage';

  ELSIF p_damage_cost <= v_deposit THEN
    -- à¸à¸£à¸“à¸µ 2: à¹€à¸ªà¸µà¸¢à¸«à¸²à¸¢à¹à¸•à¹ˆà¸¡à¸±à¸”à¸ˆà¸³à¸žà¸­à¸ˆà¹ˆà¸²à¸¢ â€” à¸«à¸±à¸à¸ˆà¸²à¸à¸¡à¸±à¸”à¸ˆà¸³ à¸—à¸µà¹ˆà¹€à¸«à¸¥à¸·à¸­à¸„à¸·à¸™à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸²
    v_refund_amount := v_deposit - p_damage_cost;

    INSERT INTO Payment (order_id, user_id, amount, status)
    VALUES (p_order_id, v_renter_id, v_refund_amount, 'refunded');

    UPDATE RentalOrder SET status = 'completed', return_at = NOW() WHERE order_id = p_order_id;

    -- TODO: à¹‚à¸­à¸™ v_refund_amount à¸„à¸·à¸™à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸² + à¹‚à¸­à¸™ v_net_income à¹ƒà¸«à¹‰à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸²
    RETURN 'completed_deposit_covers_damage';

  ELSE
    -- à¸à¸£à¸“à¸µ 3: à¸¡à¸±à¸”à¸ˆà¸³à¹„à¸¡à¹ˆà¸žà¸­à¸ˆà¹ˆà¸²à¸¢à¸„à¹ˆà¸²à¹€à¸ªà¸µà¸¢à¸«à¸²à¸¢ â€” à¸•à¹‰à¸­à¸‡à¸£à¸­à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸²à¸ˆà¹ˆà¸²à¸¢à¹€à¸žà¸´à¹ˆà¸¡ à¸¢à¸±à¸‡à¸›à¸´à¸”à¸­à¸­à¹€à¸”à¸­à¸£à¹Œà¹„à¸¡à¹ˆà¹„à¸”à¹‰
    -- (à¸–à¹‰à¸²à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸²à¹„à¸¡à¹ˆà¸¢à¸´à¸™à¸¢à¸­à¸¡à¸ˆà¹ˆà¸²à¸¢ à¹ƒà¸«à¹‰à¹„à¸›à¹€à¸‚à¹‰à¸² flow submit_report / resolve_dispute à¹à¸—à¸™)
    v_extra_needed := p_damage_cost - v_deposit;

    UPDATE RentalOrder SET status = 'awaiting_additional_payment' WHERE order_id = p_order_id;

    INSERT INTO Payment (order_id, user_id, amount, status)
    VALUES (p_order_id, v_renter_id, v_extra_needed, 'pending');

    RETURN 'awaiting_additional_payment:' || v_extra_needed::TEXT;
  END IF;
END;
$$;


ALTER FUNCTION public.settle_rental_order(p_order_id uuid, p_damage_cost numeric) OWNER TO postgres;

--
-- Name: submit_report(uuid, uuid, uuid, text, text, text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.submit_report(p_report_type_id uuid, p_user_id uuid, p_order_id uuid, p_report_topic text, p_description text, p_image_urls text[] DEFAULT '{}'::text[]) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_report_id UUID;
  v_url       TEXT;
BEGIN
  -- à¸•à¹‰à¸­à¸‡à¸£à¸²à¸¢à¸‡à¸²à¸™à¹ƒà¸™à¸™à¸²à¸¡à¸•à¸±à¸§à¹€à¸­à¸‡ à¹à¸¥à¸°à¸•à¹‰à¸­à¸‡à¹€à¸›à¹‡à¸™ participant à¸‚à¸­à¸‡ order à¸™à¸±à¹‰à¸™à¸ˆà¸£à¸´à¸‡
  IF p_user_id <> auth.uid() AND NOT is_admin() THEN
    RAISE EXCEPTION 'à¹„à¸¡à¹ˆà¸¡à¸µà¸ªà¸´à¸—à¸˜à¸´à¹Œà¸£à¸²à¸¢à¸‡à¸²à¸™à¸›à¸±à¸à¸«à¸²à¹à¸—à¸™à¸œà¸¹à¹‰à¹ƒà¸Šà¹‰à¸„à¸™à¸­à¸·à¹ˆà¸™';
  END IF;
  IF NOT is_order_participant(p_order_id) AND NOT is_admin() THEN
    RAISE EXCEPTION 'à¹„à¸¡à¹ˆà¹ƒà¸Šà¹ˆà¸œà¸¹à¹‰à¹€à¸à¸µà¹ˆà¸¢à¸§à¸‚à¹‰à¸­à¸‡à¸à¸±à¸š order à¸™à¸µà¹‰';
  END IF;

  INSERT INTO RentalReport (report_type_id, user_id, order_id, report_topic, description, status)
  VALUES (p_report_type_id, p_user_id, p_order_id, p_report_topic, p_description, 'pending_investigation')
  RETURNING report_id INTO v_report_id;

  FOREACH v_url IN ARRAY p_image_urls LOOP
    INSERT INTO RentalReportImage (report_id, image_url) VALUES (v_report_id, v_url);
  END LOOP;

  RETURN v_report_id;
END;
$$;


ALTER FUNCTION public.submit_report(p_report_type_id uuid, p_user_id uuid, p_order_id uuid, p_report_topic text, p_description text, p_image_urls text[]) OWNER TO postgres;

--
-- Name: submit_review(uuid, integer, text, text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.submit_review(p_order_id uuid, p_rating integer, p_comment text, p_image_urls text[] DEFAULT '{}'::text[]) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_review_id UUID;
  v_url       TEXT;
  v_seq       INTEGER := 1;
BEGIN
  -- à¸•à¹‰à¸­à¸‡à¹€à¸›à¹‡à¸™à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸²à¸‚à¸­à¸‡ order à¸™à¸µà¹‰à¸ˆà¸£à¸´à¸‡ à¹à¸¥à¸° order à¸•à¹‰à¸­à¸‡à¹€à¸ªà¸£à¹‡à¸ˆà¸ªà¸¡à¸šà¸¹à¸£à¸“à¹Œà¹à¸¥à¹‰à¸§à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™à¸–à¸¶à¸‡à¸£à¸µà¸§à¸´à¸§à¹„à¸”à¹‰
  IF NOT EXISTS (
    SELECT 1 FROM RentalOrder
    WHERE order_id = p_order_id AND user_id = auth.uid() AND status = 'completed'
  ) THEN
    RAISE EXCEPTION 'à¸£à¸µà¸§à¸´à¸§à¹„à¸”à¹‰à¹€à¸‰à¸žà¸²à¸° order à¸—à¸µà¹ˆà¹€à¸ªà¸£à¹‡à¸ˆà¸ªà¸¡à¸šà¸¹à¸£à¸“à¹Œà¹à¸¥à¹‰à¸§à¹à¸¥à¸°à¹€à¸›à¹‡à¸™à¸‚à¸­à¸‡à¸„à¸¸à¸“à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™';
  END IF;

  -- à¹„à¸¡à¹ˆà¸•à¹‰à¸­à¸‡à¹€à¸Šà¹‡à¸„à¹€à¸­à¸‡à¸§à¹ˆà¸²à¸£à¸µà¸§à¸´à¸§à¸‹à¹‰à¸³à¹„à¸«à¸¡ à¹€à¸žà¸£à¸²à¸° Review à¸¡à¸µ UNIQUE(order_id) à¸šà¸±à¸‡à¸„à¸±à¸šà¹„à¸§à¹‰à¸—à¸µà¹ˆà¸•à¸²à¸£à¸²à¸‡à¹à¸¥à¹‰à¸§
  -- à¸–à¹‰à¸² order à¸™à¸µà¹‰à¹€à¸„à¸¢à¸£à¸µà¸§à¸´à¸§à¹„à¸›à¹à¸¥à¹‰à¸§ à¸šà¸£à¸£à¸—à¸±à¸”à¸–à¸±à¸”à¹„à¸›à¸ˆà¸° error à¹ƒà¸«à¹‰à¹€à¸­à¸‡à¸­à¸±à¸•à¹‚à¸™à¸¡à¸±à¸•à¸´
  INSERT INTO Review (order_id, rating, comment)
  VALUES (p_order_id, p_rating, p_comment)
  RETURNING review_id INTO v_review_id;

  FOREACH v_url IN ARRAY p_image_urls LOOP
    INSERT INTO ReviewImage (review_id, image_url, sequence) VALUES (v_review_id, v_url, v_seq);
    v_seq := v_seq + 1;
  END LOOP;

  RETURN v_review_id;
END;
$$;


ALTER FUNCTION public.submit_review(p_order_id uuid, p_rating integer, p_comment text, p_image_urls text[]) OWNER TO postgres;

--
-- Name: upload_rental_evidence(uuid, uuid, text, text[], text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.upload_rental_evidence(p_order_id uuid, p_user_id uuid, p_evidence_type text, p_image_urls text[], p_new_status text DEFAULT NULL::text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_url TEXT;
BEGIN
  -- à¸•à¹‰à¸­à¸‡à¹€à¸›à¹‡à¸™ participant à¸‚à¸­à¸‡ order à¸™à¸µà¹‰à¸ˆà¸£à¸´à¸‡ (à¸œà¸¹à¹‰à¹€à¸Šà¹ˆà¸²à¸«à¸£à¸·à¸­à¸œà¸¹à¹‰à¹ƒà¸«à¹‰à¹€à¸Šà¹ˆà¸²à¸‚à¸­à¸‡ order à¸™à¸±à¹‰à¸™) à¹à¸¥à¸°à¸­à¸±à¸›à¹‚à¸«à¸¥à¸”
  -- à¹ƒà¸™à¸™à¸²à¸¡à¸•à¸±à¸§à¹€à¸­à¸‡à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™ à¸«à¹‰à¸²à¸¡à¸ªà¸§à¸¡à¸£à¸­à¸¢à¸­à¸±à¸›à¹‚à¸«à¸¥à¸”à¹à¸—à¸™à¸­à¸µà¸à¸à¹ˆà¸²à¸¢
  IF p_user_id <> auth.uid() AND NOT is_admin() THEN
    RAISE EXCEPTION 'à¹„à¸¡à¹ˆà¸¡à¸µà¸ªà¸´à¸—à¸˜à¸´à¹Œà¸­à¸±à¸›à¹‚à¸«à¸¥à¸”à¸«à¸¥à¸±à¸à¸à¸²à¸™à¹à¸—à¸™à¸œà¸¹à¹‰à¹ƒà¸Šà¹‰à¸„à¸™à¸­à¸·à¹ˆà¸™';
  END IF;
  IF NOT is_order_participant(p_order_id) AND NOT is_admin() THEN
    RAISE EXCEPTION 'à¹„à¸¡à¹ˆà¹ƒà¸Šà¹ˆà¸œà¸¹à¹‰à¹€à¸à¸µà¹ˆà¸¢à¸§à¸‚à¹‰à¸­à¸‡à¸à¸±à¸š order à¸™à¸µà¹‰';
  END IF;

  FOREACH v_url IN ARRAY p_image_urls LOOP
    INSERT INTO RentalEvidenceImage (order_id, user_id, evidence_type, image_url)
    VALUES (p_order_id, p_user_id, p_evidence_type, v_url);
  END LOOP;

  IF p_new_status IS NOT NULL THEN
    UPDATE RentalOrder SET status = p_new_status WHERE order_id = p_order_id;
  END IF;
END;
$$;


ALTER FUNCTION public.upload_rental_evidence(p_order_id uuid, p_user_id uuid, p_evidence_type text, p_image_urls text[], p_new_status text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: availability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.availability (
    availability_id uuid DEFAULT gen_random_uuid() NOT NULL,
    item_id uuid NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT availability_check CHECK ((end_date >= start_date))
);


ALTER TABLE public.availability OWNER TO postgres;

--
-- Name: bankaccount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bankaccount (
    bank_account_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    bank_name text NOT NULL,
    account_number text NOT NULL,
    account_name text NOT NULL,
    is_default boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.bankaccount OWNER TO postgres;

--
-- Name: chatroom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chatroom (
    chat_room_id uuid DEFAULT gen_random_uuid() NOT NULL,
    renter_id uuid NOT NULL,
    lender_id uuid NOT NULL,
    last_message text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chatroom_check CHECK ((renter_id <> lender_id))
);


ALTER TABLE public.chatroom OWNER TO postgres;

--
-- Name: item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item (
    item_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    category_id uuid,
    item_name text NOT NULL,
    description text,
    original_price numeric(12,2),
    rental_fee_per_day numeric(12,2),
    deposit numeric(12,2),
    status text DEFAULT 'available'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT item_deposit_check CHECK ((deposit >= (0)::numeric)),
    CONSTRAINT item_original_price_check CHECK ((original_price >= (0)::numeric)),
    CONSTRAINT item_rental_fee_per_day_check CHECK ((rental_fee_per_day >= (0)::numeric)),
    CONSTRAINT item_status_check CHECK ((status = ANY (ARRAY['available'::text, 'rented'::text, 'maintenance'::text, 'inactive'::text])))
);


ALTER TABLE public.item OWNER TO postgres;

--
-- Name: itemcategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemcategory (
    category_id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.itemcategory OWNER TO postgres;

--
-- Name: itemcondition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemcondition (
    item_id uuid NOT NULL,
    seq integer NOT NULL,
    condition text NOT NULL
);


ALTER TABLE public.itemcondition OWNER TO postgres;

--
-- Name: itemimage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemimage (
    image_id uuid DEFAULT gen_random_uuid() NOT NULL,
    item_id uuid NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    sequence integer,
    image_url text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.itemimage OWNER TO postgres;

--
-- Name: itemlocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemlocation (
    location_id uuid DEFAULT gen_random_uuid() NOT NULL,
    item_id uuid NOT NULL,
    description text,
    no text,
    alley text,
    road text,
    subdistrict text,
    district text,
    province text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.itemlocation OWNER TO postgres;

--
-- Name: message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message (
    message_id uuid DEFAULT gen_random_uuid() NOT NULL,
    chat_room_id uuid NOT NULL,
    order_id uuid,
    sender_id uuid NOT NULL,
    type text DEFAULT 'text'::text NOT NULL,
    content text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT message_type_check CHECK ((type = ANY (ARRAY['text'::text, 'image'::text])))
);


ALTER TABLE public.message OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    payment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    user_id uuid NOT NULL,
    amount numeric(12,2),
    date timestamp with time zone DEFAULT now() NOT NULL,
    slip_image_url text,
    transaction_ref text,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT payment_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT payment_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'refunded'::text])))
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: useraccount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.useraccount (
    user_id uuid DEFAULT auth.uid() NOT NULL,
    national_id text,
    username text NOT NULL,
    email text NOT NULL,
    firstname text,
    lastname text,
    status text DEFAULT 'Pending_Verification'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    bio text,
    avatar_url text,
    banner_url text,
    CONSTRAINT useraccount_status_check CHECK ((status = ANY (ARRAY['Active'::text, 'Pending_Verification'::text, 'Suspended'::text, 'Banned'::text, 'Deactivated'::text])))
);


ALTER TABLE public.useraccount OWNER TO postgres;

--
-- Name: publicuserprofile; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.publicuserprofile AS
 SELECT user_id,
    username,
    firstname,
    status
   FROM public.useraccount;


ALTER VIEW public.publicuserprofile OWNER TO postgres;

--
-- Name: rentalevidenceimage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rentalevidenceimage (
    evidence_id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    user_id uuid NOT NULL,
    evidence_type text NOT NULL,
    image_url text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT rentalevidenceimage_evidence_type_check CHECK ((evidence_type = ANY (ARRAY['renter_before'::text, 'renter_after'::text, 'lender_before'::text, 'lender_after'::text])))
);


ALTER TABLE public.rentalevidenceimage OWNER TO postgres;

--
-- Name: rentalorder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rentalorder (
    order_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    item_id uuid NOT NULL,
    meetup_location text,
    return_location text,
    start_date date NOT NULL,
    end_date date NOT NULL,
    return_at timestamp with time zone,
    rental_fee numeric(12,2),
    deposit numeric(12,2),
    total_paid numeric(12,2),
    fee numeric(12,2),
    net_income numeric(12,2),
    status text DEFAULT 'requested'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT rentalorder_check CHECK ((end_date >= start_date)),
    CONSTRAINT rentalorder_deposit_check CHECK ((deposit >= (0)::numeric)),
    CONSTRAINT rentalorder_fee_check CHECK ((fee >= (0)::numeric)),
    CONSTRAINT rentalorder_rental_fee_check CHECK ((rental_fee >= (0)::numeric)),
    CONSTRAINT rentalorder_status_check CHECK ((status = ANY (ARRAY['requested'::text, 'awaiting_payment'::text, 'paid'::text, 'item_sent'::text, 'item_returned'::text, 'awaiting_additional_payment'::text, 'completed'::text, 'rejected'::text, 'cancelled'::text]))),
    CONSTRAINT rentalorder_total_paid_check CHECK ((total_paid >= (0)::numeric))
);


ALTER TABLE public.rentalorder OWNER TO postgres;

--
-- Name: rentalreport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rentalreport (
    report_id uuid DEFAULT gen_random_uuid() NOT NULL,
    report_type_id uuid NOT NULL,
    user_id uuid NOT NULL,
    order_id uuid NOT NULL,
    report_topic text NOT NULL,
    description text,
    status text DEFAULT 'pending_investigation'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    resolved_at timestamp with time zone,
    CONSTRAINT rentalreport_status_check CHECK ((status = ANY (ARRAY['pending_investigation'::text, 'resolved'::text, 'rejected'::text])))
);


ALTER TABLE public.rentalreport OWNER TO postgres;

--
-- Name: rentalreportimage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rentalreportimage (
    image_id uuid DEFAULT gen_random_uuid() NOT NULL,
    report_id uuid NOT NULL,
    image_url text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rentalreportimage OWNER TO postgres;

--
-- Name: rentalreporttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rentalreporttype (
    report_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    report_type text NOT NULL,
    CONSTRAINT rentalreporttype_report_type_check CHECK ((report_type = ANY (ARRAY['lender_no_show'::text, 'renter_no_show'::text, 'damaged_item'::text, 'false_advertisement'::text, 'other'::text])))
);


ALTER TABLE public.rentalreporttype OWNER TO postgres;

--
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    review_id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    rating integer NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT review_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.review OWNER TO postgres;

--
-- Name: reviewimage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviewimage (
    image_id uuid DEFAULT gen_random_uuid() NOT NULL,
    review_id uuid NOT NULL,
    image_url text NOT NULL,
    sequence integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.reviewimage OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    role_id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_type text NOT NULL,
    CONSTRAINT role_role_type_check CHECK ((role_type = ANY (ARRAY['admin'::text, 'renter'::text, 'lender'::text])))
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: test_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_results (
    test_no integer,
    test_name text,
    result text,
    detail text
);


ALTER TABLE public.test_results OWNER TO postgres;

--
-- Name: user_role_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role_assignment (
    role_id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_role_assignment OWNER TO postgres;

--
-- Name: userphones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userphones (
    user_id uuid NOT NULL,
    phone text NOT NULL
);


ALTER TABLE public.userphones OWNER TO postgres;

--
-- Data for Name: availability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.availability (availability_id, item_id, start_date, end_date, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	d1111111-1111-1111-1111-111111111111	2026-08-01	2026-12-31	2026-08-01 10:00:00+00	2026-08-01 10:00:00+00
22222222-2222-2222-2222-222222222222	d2222222-2222-2222-2222-222222222222	2026-08-01	2026-12-31	2026-08-02 11:30:00+00	2026-08-02 11:30:00+00
33333333-3333-3333-3333-333333333333	d3333333-3333-3333-3333-333333333333	2026-08-01	2026-12-31	2026-08-03 09:15:00+00	2026-08-03 09:15:00+00
44444444-4444-4444-4444-444444444444	d4444444-4444-4444-4444-444444444444	2026-08-01	2026-12-31	2026-08-04 14:00:00+00	2026-08-04 14:00:00+00
\.


--
-- Data for Name: bankaccount; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bankaccount (bank_account_id, user_id, bank_name, account_number, account_name, is_default, created_at) FROM stdin;
11111111-1111-1111-1111-111111111111	b5041d3d-ba07-4230-96fa-3fbfb4411439	กสิกรไทย	123-4-56789-0	หยก มีทรัพย์	t	2026-08-22 07:44:22+00
22222222-2222-2222-2222-222222222222	b6f3e426-ba65-4b9e-becd-820e4d65d146	ไทยพาณิชย์	987-6-54321-0	แฟนต้า รวยจริง	t	2026-08-22 19:34:03+00
\.


--
-- Data for Name: chatroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatroom (chat_room_id, renter_id, lender_id, last_message, updated_at, created_at) FROM stdin;
c33e5d30-5b58-4fa2-8022-8c3d21db1189	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	b5041d3d-ba07-4230-96fa-3fbfb4411439	หวัดดีหยก	2026-08-23 14:04:53.526+00	2026-08-23 07:16:04.849645+00
77e0037c-3ddd-4c24-b2dc-5927c61af2ad	b5041d3d-ba07-4230-96fa-3fbfb4411439	b6f3e426-ba65-4b9e-becd-820e4d65d146	ไม่เชื่อก็แล้วแต่	2026-08-23 07:48:55.684+00	2026-08-23 07:37:56.575739+00
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item (item_id, user_id, category_id, item_name, description, original_price, rental_fee_per_day, deposit, status, created_at, updated_at) FROM stdin;
d1111111-1111-1111-1111-111111111111	b5041d3d-ba07-4230-96fa-3fbfb4411439	c1111111-1111-1111-1111-111111111111	กล้อง Sony Alpha 7 IV พร้อมเลนส์ 28-70mm	กล้องฟูลเฟรมยอดนิยมสำหรับงานภาพนิ่งและวิดีโอ 4K เซนเซอร์ 33MP ระบบโฟกัสแม่นยำ พร้อมแบตเตอรี่แท้ 2 ก้อน	75000.00	950.00	15000.00	available	2026-08-01 10:00:00+00	2026-08-01 10:00:00+00
d2222222-2222-2222-2222-222222222222	b5041d3d-ba07-4230-96fa-3fbfb4411439	c2222222-2222-2222-2222-222222222222	เต็นท์แคมป์ปิ้ง Vidalido สำหรับ 4 คน พร้อมฟลายชีท	เต็นท์กางอัตโนมัติ ขนาดใหญ่ กว้างขวาง กันน้ำกันแดดดีเยี่ยม เหมาะสำหรับการตั้งแคมป์ครอบครัวหรือกลุ่มเพื่อน	8500.00	350.00	2000.00	available	2026-08-02 11:30:00+00	2026-08-02 11:30:00+00
d3333333-3333-3333-3333-333333333333	b6f3e426-ba65-4b9e-becd-820e4d65d146	c4444444-4444-4444-4444-444444444444	ไมโครโฟนไร้สาย DJI Mic 2 (2 TX + 1 RX)	ชุดไมค์ไร้สายคุณภาพเสียงคมชัด บันทึกเสียงภายในตัวได้ มีระบบตัดเสียงรบกวน เหมาะสำหรับงานถ่าย Vlog และสัมภาษณ์	14000.00	350.00	3000.00	available	2026-08-03 09:15:00+00	2026-08-03 09:15:00+00
d4444444-4444-4444-4444-444444444444	b5041d3d-ba07-4230-96fa-3fbfb4411439	c3333333-3333-3333-3333-333333333333	ชุดสว่านกระแทกไร้สาย Bosch 18V พร้อมแบตเตอรี่	สว่านกระแทกไร้สายกำลังสูง เจาะปูน ไม้ เหล็ก ได้สบาย พร้อมแบตเตอรี่ 2 ก้อน แท่นชาร์จเร็ว และชุดดอกสว่านพื้นฐาน	6200.00	200.00	1500.00	available	2026-08-04 14:00:00+00	2026-08-04 14:00:00+00
\.


--
-- Data for Name: itemcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemcategory (category_id, category_name, created_at) FROM stdin;
c1111111-1111-1111-1111-111111111111	กล้องและอุปกรณ์ถ่ายภาพ	2026-08-01 10:00:00+00
c2222222-2222-2222-2222-222222222222	อุปกรณ์แคมป์ปิ้ง	2026-08-01 10:00:00+00
c3333333-3333-3333-3333-333333333333	เครื่องมือช่าง	2026-08-01 10:00:00+00
c4444444-4444-4444-4444-444444444444	อุปกรณ์เสียงและดนตรี	2026-08-01 10:00:00+00
\.


--
-- Data for Name: itemcondition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemcondition (item_id, seq, condition) FROM stdin;
d1111111-1111-1111-1111-111111111111	1	สภาพใหม่ ไม่มีรอยขีดข่วน ใช้งานปกติ 100%
d2222222-2222-2222-2222-222222222222	1	ผ้าใบกันน้ำสมบูรณ์ เสาเต็นท์ครบ ไม่มีรอยฉีกขาด
d3333333-3333-3333-3333-333333333333	1	อุปกรณ์ครบกล่อง แบตเตอรี่อึด ใช้งานได้ยาวนาน
d4444444-4444-4444-4444-444444444444	1	สว่านพลังแรง พร้อมดอกสว่านครบชุด
\.


--
-- Data for Name: itemimage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemimage (image_id, item_id, is_primary, sequence, image_url, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	d1111111-1111-1111-1111-111111111111	t	1	https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800&auto=format&fit=crop&q=80	2026-08-01 10:00:00+00	2026-08-01 10:00:00+00
22222222-2222-2222-2222-222222222222	d2222222-2222-2222-2222-222222222222	t	1	https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800&auto=format&fit=crop&q=80	2026-08-02 11:30:00+00	2026-08-02 11:30:00+00
33333333-3333-3333-3333-333333333333	d3333333-3333-3333-3333-333333333333	t	1	https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=800&auto=format&fit=crop&q=80	2026-08-03 09:15:00+00	2026-08-03 09:15:00+00
44444444-4444-4444-4444-444444444444	d4444444-4444-4444-4444-444444444444	t	1	https://images.unsplash.com/photo-1504148455328-c376907d081c?w=800&auto=format&fit=crop&q=80	2026-08-04 14:00:00+00	2026-08-04 14:00:00+00
\.


--
-- Data for Name: itemlocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemlocation (location_id, item_id, description, no, alley, road, subdistrict, district, province, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	d1111111-1111-1111-1111-111111111111	คอนโดใกล้ BTS สยาม	123/45	ซอย 5	พระราม 1	ปทุมวัน	ปทุมวัน	กรุงเทพมหานคร	10330	2026-08-01 10:00:00+00
22222222-2222-2222-2222-222222222222	d2222222-2222-2222-2222-222222222222	บ้านเดี่ยว รังสิต คลอง 2	88/9	ซอยรังสิต 2	พหลโยธิน	ประชาธิปัตย์	ธัญบุรี	ปทุมธานี	12130	2026-08-02 11:30:00+00
33333333-3333-3333-3333-333333333333	d3333333-3333-3333-3333-333333333333	อพาร์ทเมนท์ ลาดพร้าว 71	55/12	ซอย 71	ลาดพร้าว	สะพานสอง	วังทองหลาง	กรุงเทพมหานคร	10310	2026-08-03 09:15:00+00
44444444-4444-4444-4444-444444444444	d4444444-4444-4444-4444-444444444444	หน้าร้านช่างทอง สาทร	99	\N	สาทรเหนือ	สีลม	บางรัก	กรุงเทพมหานคร	10500	2026-08-04 14:00:00+00
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message (message_id, chat_room_id, order_id, sender_id, type, content, is_read, created_at) FROM stdin;
11111111-1111-1111-1111-111111111111	c33e5d30-5b58-4fa2-8022-8c3d21db1189	11111111-1111-1111-1111-111111111111	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	text	สวัสดีครับพี่หยก สนใจเช่ากล้องครับ	2026-08-22 09:00:00+00	t
22222222-2222-2222-2222-222222222222	c33e5d30-5b58-4fa2-8022-8c3d21db1189	11111111-1111-1111-1111-111111111111	b5041d3d-ba07-4230-96fa-3fbfb4411439	text	ยินดีครับ นัดรับที่ BTS สยาม ได้เลยครับ	2026-08-22 09:05:00+00	t
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (payment_id, order_id, user_id, amount, date, slip_image_url, transaction_ref, status, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	11111111-1111-1111-1111-111111111111	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	17850.00	2026-08-22 10:15:00+00	https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600&auto=format&fit=crop&q=80	approved	2026-08-22 10:15:00+00	2026-08-22 10:30:00+00	rental
22222222-2222-2222-2222-222222222222	22222222-2222-2222-2222-222222222222	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	2100.00	2026-08-25 08:15:00+00	https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600&auto=format&fit=crop&q=80	approved	2026-08-25 08:15:00+00	2026-08-25 08:20:00+00	rental
\.


--
-- Data for Name: rentalevidenceimage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rentalevidenceimage (evidence_id, order_id, user_id, evidence_type, image_url, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	11111111-1111-1111-1111-111111111111	b5041d3d-ba07-4230-96fa-3fbfb4411439	lender_pickup	https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&auto=format&fit=crop&q=80	1	2026-08-23 10:00:00+00
22222222-2222-2222-2222-222222222222	11111111-1111-1111-1111-111111111111	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	renter_return	https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&auto=format&fit=crop&q=80	1	2026-08-26 18:00:00+00
\.


--
-- Data for Name: rentalorder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rentalorder (order_id, user_id, item_id, meetup_location, return_location, start_date, end_date, return_at, rental_fee, deposit, total_paid, fee, net_income, status, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	d1111111-1111-1111-1111-111111111111	BTS สยาม ทางออก 3	BTS สยาม ทางออก 3	2026-08-23	2026-08-26	2026-08-26 18:00:00+00	2850.00	15000.00	17850.00	142.50	2707.50	completed	2026-08-22 10:00:00+00	2026-08-26 18:30:00+00
22222222-2222-2222-2222-222222222222	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	d4444444-4444-4444-4444-444444444444	MRT เพชรบุรี	MRT เพชรบุรี	2026-08-27	2026-08-29	\N	600.00	1500.00	2100.00	30.00	570.00	completed	2026-08-25 08:00:00+00	2026-08-25 08:00:00+00
33333333-3333-3333-3333-333333333333	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	d2222222-2222-2222-2222-222222222222	ฟิวเจอร์พาร์ค รังสิต	ฟิวเจอร์พาร์ค รังสิต	2026-08-24	2026-08-26	\N	1050.00	2000.00	3050.00	52.50	997.50	item_sent	2026-08-23 15:00:00+00	2026-08-24 09:00:00+00
\.


--
-- Data for Name: rentalreport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rentalreport (report_id, report_type_id, user_id, order_id, report_topic, description, status, created_at, updated_at, resolved_at) FROM stdin;
\.


--
-- Data for Name: rentalreportimage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rentalreportimage (image_id, report_id, image_url, created_at) FROM stdin;
\.


--
-- Data for Name: rentalreporttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rentalreporttype (report_type_id, report_type) FROM stdin;
2a039a6d-0e2f-4723-b39f-2baadba974a6	lender_no_show
66f2f819-72e2-432f-90b1-09c0bf848f4f	renter_no_show
edf17f01-2b1e-4e50-9455-b46173d4c2ba	damaged_item
d8674f02-48dc-43c0-affb-27b188d788c6	false_advertisement
8534106d-55af-45a9-b8a5-d96266c7cd4c	other
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (review_id, order_id, rating, comment, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	11111111-1111-1111-1111-111111111111	5	กล้องสภาพดีมาก ใช้งานราบรื่น ผู้ให้เช่าใจดีตรงเวลา แนะนำครับ!	2026-08-26 19:00:00+00	2026-08-26 19:00:00+00
\.


--
-- Data for Name: reviewimage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviewimage (image_id, review_id, image_url, sequence, created_at) FROM stdin;
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (role_id, role_type) FROM stdin;
5674b752-9a19-4679-9f69-fb3f02b26d03	admin
dff91a27-27c9-420e-902a-bb4cd96612ed	renter
f2c593f7-8479-416e-b08e-352a37727b9e	lender
\.


--
-- Data for Name: test_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_results (test_no, test_name, result, detail) FROM stdin;
1	à¸à¸±à¸™à¸ˆà¸­à¸‡à¸ªà¸´à¸™à¸„à¹‰à¸²à¸‹à¹‰à¸­à¸™à¸§à¸±à¸™ (EXCLUDE)	PASS	\N
2	à¸à¸±à¸™à¸£à¸¹à¸›à¸›à¸à¸‹à¹‰à¸³ (partial unique index)	PASS	\N
3	à¸à¸±à¸™à¸šà¸±à¸à¸Šà¸µ default à¸‹à¹‰à¸³	PASS	\N
4	à¸à¸±à¸™à¸«à¹‰à¸­à¸‡à¹à¸Šà¸—à¸‹à¹‰à¸³	PASS	\N
5	à¸à¸±à¸™à¸£à¸²à¸„à¸²à¸•à¸´à¸”à¸¥à¸š (CHECK)	PASS	\N
6	à¸à¸±à¸™ end_date à¸œà¸´à¸”à¸¥à¸³à¸”à¸±à¸š (CHECK)	PASS	\N
7	à¸à¸±à¸™à¸¥à¸š user à¸—à¸µà¹ˆà¸¢à¸±à¸‡à¸¡à¸µà¸ªà¸´à¸™à¸„à¹‰à¸² (RESTRICT)	PASS	\N
8	à¸à¸±à¸™à¸£à¸µà¸§à¸´à¸§à¸‹à¹‰à¸³ order à¹€à¸”à¸´à¸¡ (UNIQUE)	PASS	\N
9	à¸à¸±à¸™à¹à¸Šà¸—à¸à¸±à¸šà¸•à¸±à¸§à¹€à¸­à¸‡ (CHECK)	PASS	\N
10	trigger set_updated_at()	PASS	\N
11	trigger on_auth_user_created	PASS	\N
12	settle_rental_order (à¹„à¸¡à¹ˆà¸¡à¸µà¸„à¸§à¸²à¸¡à¹€à¸ªà¸µà¸¢à¸«à¸²à¸¢)	PASS	completed_no_damage
13	settle_rental_order (à¸¡à¸±à¸”à¸ˆà¸³à¹„à¸¡à¹ˆà¸žà¸­)	PASS	awaiting_additional_payment:2000.00
14	submit_review à¸šà¸¥à¹‡à¸­à¸ order à¹„à¸¡à¹ˆ completed	PASS	à¸£à¸µà¸§à¸´à¸§à¹„à¸”à¹‰à¹€à¸‰à¸žà¸²à¸° order à¸—à¸µà¹ˆà¹€à¸ªà¸£à¹‡à¸ˆà¸ªà¸¡à¸šà¸¹à¸£à¸“à¹Œà¹à¸¥à¹‰à¸§à¹à¸¥à¸°à¹€à¸›à¹‡à¸™à¸‚à¸­à¸‡à¸„à¸¸à¸“à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™
15	resolve_dispute à¸šà¸¥à¹‡à¸­à¸à¸„à¸™à¸—à¸µà¹ˆà¹„à¸¡à¹ˆà¹ƒà¸Šà¹ˆ admin	PASS	à¹€à¸‰à¸žà¸²à¸°à¹à¸­à¸”à¸¡à¸´à¸™à¹€à¸—à¹ˆà¸²à¸™à¸±à¹‰à¸™à¸—à¸µà¹ˆà¸•à¸±à¸”à¸ªà¸´à¸™à¸‚à¹‰à¸­à¸žà¸´à¸žà¸²à¸—à¹„à¸”à¹‰
16	RLS: mint à¸¡à¸­à¸‡à¹„à¸¡à¹ˆà¹€à¸«à¹‡à¸™à¸šà¸±à¸à¸Šà¸µà¸„à¸™à¸­à¸·à¹ˆà¸™	PASS	\N
17	RLS: mint à¹à¸à¹‰à¸ªà¸´à¸™à¸„à¹‰à¸²à¸„à¸™à¸­à¸·à¹ˆà¸™à¹„à¸¡à¹ˆà¹„à¸”à¹‰	PASS	\N
18	RLS: admin à¹€à¸«à¹‡à¸™à¸—à¸¸à¸à¸šà¸±à¸à¸Šà¸µ	PASS	2 à¹à¸–à¸§
\.


--
-- Data for Name: user_role_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_role_assignment (role_id, user_id, created_at, assigned_at) FROM stdin;
f2c593f7-8479-416e-b08e-352a37727b9e	b5041d3d-ba07-4230-96fa-3fbfb4411439	2026-08-22 07:44:22.06373+00	2026-08-22 07:44:22.06373+00
dff91a27-27c9-420e-902a-bb4cd96612ed	8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	2026-08-22 06:58:26.972531+00	2026-08-22 06:58:26.972531+00
f2c593f7-8479-416e-b08e-352a37727b9e	b6f3e426-ba65-4b9e-becd-820e4d65d146	2026-08-22 19:34:03.745712+00	2026-08-22 19:34:03.745712+00
dff91a27-27c9-420e-902a-bb4cd96612ed	b6f3e426-ba65-4b9e-becd-820e4d65d146	2026-08-22 19:34:03.745712+00	2026-08-22 19:34:03.745712+00
\.


--
-- Data for Name: useraccount; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.useraccount (user_id, national_id, username, email, firstname, lastname, status, created_at, updated_at, bio, avatar_url, banner_url) FROM stdin;
8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	6767676767676	romanlnw68	rommanlnw68@chaochao.local	โรมัน	ผู้เช่า	Active	2026-08-22 06:58:26.972531+00	2026-08-25 12:10:00+00	ยินดีที่ได้ร่วมเช่าของกับทุกคนครับ	/api/avatar?id=8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	\N
b5041d3d-ba07-4230-96fa-3fbfb4411439	1234567890123	yoklnw67	yoklnw67@chaochao.local	หยก	ผู้ให้เช่า	Active	2026-08-22 07:44:22.06373+00	2026-08-25 12:10:00+00	มีอุปกรณ์คุณภาพพร้อมส่งต่อความสุขครับ	/api/avatar?id=b5041d3d-ba07-4230-96fa-3fbfb4411439	\N
b6f3e426-ba65-4b9e-becd-820e4d65d146	6666666666666	fantalnw66	fantalnw66@chaochao.local	แฟนต้า	สายลุย	Active	2026-08-22 19:34:03.745712+00	2026-08-25 12:10:00+00	ชอบท่องเที่ยวและแชร์อุปกรณ์ดีๆ	/api/avatar?id=b6f3e426-ba65-4b9e-becd-820e4d65d146	\N
\.


--
-- Data for Name: userphones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userphones (user_id, phone) FROM stdin;
8a88d60a-e2cf-43a6-b4ea-baa9347bfee1	0812345678
b5041d3d-ba07-4230-96fa-3fbfb4411439	0898765432
b6f3e426-ba65-4b9e-becd-820e4d65d146	0865554433
\.


--
-- Name: availability availability_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_pkey PRIMARY KEY (availability_id);


--
-- Name: bankaccount bankaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bankaccount
    ADD CONSTRAINT bankaccount_pkey PRIMARY KEY (bank_account_id);


--
-- Name: bankaccount bankaccount_user_id_account_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bankaccount
    ADD CONSTRAINT bankaccount_user_id_account_number_key UNIQUE (user_id, account_number);


--
-- Name: chatroom chatroom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatroom
    ADD CONSTRAINT chatroom_pkey PRIMARY KEY (chat_room_id);


--
-- Name: chatroom chatroom_renter_id_lender_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatroom
    ADD CONSTRAINT chatroom_renter_id_lender_id_key UNIQUE (renter_id, lender_id);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (item_id);


--
-- Name: itemcategory itemcategory_category_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemcategory
    ADD CONSTRAINT itemcategory_category_name_key UNIQUE (category_name);


--
-- Name: itemcategory itemcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemcategory
    ADD CONSTRAINT itemcategory_pkey PRIMARY KEY (category_id);


--
-- Name: itemcondition itemcondition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemcondition
    ADD CONSTRAINT itemcondition_pkey PRIMARY KEY (item_id, seq);


--
-- Name: itemimage itemimage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemimage
    ADD CONSTRAINT itemimage_pkey PRIMARY KEY (image_id);


--
-- Name: itemlocation itemlocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemlocation
    ADD CONSTRAINT itemlocation_pkey PRIMARY KEY (location_id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (message_id);


--
-- Name: rentalorder no_overlapping_active_bookings; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalorder
    ADD CONSTRAINT no_overlapping_active_bookings EXCLUDE USING gist (item_id WITH =, daterange(start_date, end_date, '[]'::text) WITH &&) WHERE ((status = ANY (ARRAY['requested'::text, 'awaiting_payment'::text, 'paid'::text, 'item_sent'::text])));


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- Name: rentalevidenceimage rentalevidenceimage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalevidenceimage
    ADD CONSTRAINT rentalevidenceimage_pkey PRIMARY KEY (evidence_id);


--
-- Name: rentalorder rentalorder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalorder
    ADD CONSTRAINT rentalorder_pkey PRIMARY KEY (order_id);


--
-- Name: rentalreport rentalreport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalreport
    ADD CONSTRAINT rentalreport_pkey PRIMARY KEY (report_id);


--
-- Name: rentalreportimage rentalreportimage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalreportimage
    ADD CONSTRAINT rentalreportimage_pkey PRIMARY KEY (image_id);


--
-- Name: rentalreporttype rentalreporttype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalreporttype
    ADD CONSTRAINT rentalreporttype_pkey PRIMARY KEY (report_type_id);


--
-- Name: rentalreporttype rentalreporttype_report_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalreporttype
    ADD CONSTRAINT rentalreporttype_report_type_key UNIQUE (report_type);


--
-- Name: review review_order_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_order_id_key UNIQUE (order_id);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (review_id);


--
-- Name: reviewimage reviewimage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviewimage
    ADD CONSTRAINT reviewimage_pkey PRIMARY KEY (image_id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);


--
-- Name: role role_role_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_role_type_key UNIQUE (role_type);


--
-- Name: user_role_assignment user_role_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_assignment
    ADD CONSTRAINT user_role_assignment_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: useraccount useraccount_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.useraccount
    ADD CONSTRAINT useraccount_email_key UNIQUE (email);


--
-- Name: useraccount useraccount_national_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.useraccount
    ADD CONSTRAINT useraccount_national_id_key UNIQUE (national_id);


--
-- Name: useraccount useraccount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.useraccount
    ADD CONSTRAINT useraccount_pkey PRIMARY KEY (user_id);


--
-- Name: userphones userphones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userphones
    ADD CONSTRAINT userphones_pkey PRIMARY KEY (user_id, phone);


--
-- Name: idx_availability_item_daterange; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_availability_item_daterange ON public.availability USING gist (item_id, daterange(start_date, end_date, '[]'::text));


--
-- Name: idx_availability_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_availability_item_id ON public.availability USING btree (item_id);


--
-- Name: idx_bankaccount_one_default_per_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bankaccount_one_default_per_user ON public.bankaccount USING btree (user_id) WHERE (is_default = true);


--
-- Name: idx_chatroom_lender_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chatroom_lender_id ON public.chatroom USING btree (lender_id);


--
-- Name: idx_chatroom_renter_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chatroom_renter_id ON public.chatroom USING btree (renter_id);


--
-- Name: idx_evidence_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_evidence_order_id ON public.rentalevidenceimage USING btree (order_id);


--
-- Name: idx_item_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_item_category_id ON public.item USING btree (category_id);


--
-- Name: idx_item_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_item_name_trgm ON public.item USING gin (item_name public.gin_trgm_ops);


--
-- Name: idx_item_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_item_status ON public.item USING btree (status);


--
-- Name: idx_item_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_item_user_id ON public.item USING btree (user_id);


--
-- Name: idx_itemcondition_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_itemcondition_item_id ON public.itemcondition USING btree (item_id);


--
-- Name: idx_itemimage_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_itemimage_item_id ON public.itemimage USING btree (item_id);


--
-- Name: idx_itemimage_one_primary_per_item; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_itemimage_one_primary_per_item ON public.itemimage USING btree (item_id) WHERE (is_primary = true);


--
-- Name: idx_itemlocation_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_itemlocation_item_id ON public.itemlocation USING btree (item_id);


--
-- Name: idx_message_chat_room_id_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_message_chat_room_id_created_at ON public.message USING btree (chat_room_id, created_at);


--
-- Name: idx_message_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_message_order_id ON public.message USING btree (order_id);


--
-- Name: idx_message_sender_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_message_sender_id ON public.message USING btree (sender_id);


--
-- Name: idx_payment_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payment_order_id ON public.payment USING btree (order_id);


--
-- Name: idx_payment_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payment_status ON public.payment USING btree (status);


--
-- Name: idx_payment_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payment_user_id ON public.payment USING btree (user_id);


--
-- Name: idx_rentalorder_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rentalorder_item_id ON public.rentalorder USING btree (item_id);


--
-- Name: idx_rentalorder_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rentalorder_status ON public.rentalorder USING btree (status);


--
-- Name: idx_rentalorder_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rentalorder_user_id ON public.rentalorder USING btree (user_id);


--
-- Name: idx_report_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_report_order_id ON public.rentalreport USING btree (order_id);


--
-- Name: idx_report_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_report_status ON public.rentalreport USING btree (status);


--
-- Name: idx_report_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_report_user_id ON public.rentalreport USING btree (user_id);


--
-- Name: idx_review_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_review_order_id ON public.review USING btree (order_id);


--
-- Name: idx_useraccount_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_useraccount_status ON public.useraccount USING btree (status);


--
-- Name: availability trg_availability_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_availability_updated_at BEFORE UPDATE ON public.availability FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: item trg_item_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_item_updated_at BEFORE UPDATE ON public.item FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: itemimage trg_itemimage_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_itemimage_updated_at BEFORE UPDATE ON public.itemimage FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: itemlocation trg_itemlocation_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_itemlocation_updated_at BEFORE UPDATE ON public.itemlocation FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: payment trg_payment_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_payment_updated_at BEFORE UPDATE ON public.payment FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: rentalevidenceimage trg_rentalevidenceimage_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rentalevidenceimage_updated_at BEFORE UPDATE ON public.rentalevidenceimage FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: rentalorder trg_rentalorder_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rentalorder_updated_at BEFORE UPDATE ON public.rentalorder FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: rentalreport trg_rentalreport_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rentalreport_updated_at BEFORE UPDATE ON public.rentalreport FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: review trg_review_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_review_updated_at BEFORE UPDATE ON public.review FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: useraccount trg_useraccount_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_useraccount_updated_at BEFORE UPDATE ON public.useraccount FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: availability availability_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id) ON DELETE CASCADE;


--
-- Name: bankaccount bankaccount_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bankaccount
    ADD CONSTRAINT bankaccount_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.useraccount(user_id) ON DELETE CASCADE;


--
-- Name: chatroom chatroom_lender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatroom
    ADD CONSTRAINT chatroom_lender_id_fkey FOREIGN KEY (lender_id) REFERENCES public.useraccount(user_id) ON DELETE RESTRICT;


--
-- Name: chatroom chatroom_renter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatroom
    ADD CONSTRAINT chatroom_renter_id_fkey FOREIGN KEY (renter_id) REFERENCES public.useraccount(user_id) ON DELETE RESTRICT;


--
-- Name: useraccount fk_useraccount_authuser; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.useraccount
    ADD CONSTRAINT fk_useraccount_authuser FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE RESTRICT;


--
-- Name: item item_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.itemcategory(category_id) ON DELETE RESTRICT;


--
-- Name: item item_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.useraccount(user_id) ON DELETE RESTRICT;


--
-- Name: itemcondition itemcondition_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemcondition
    ADD CONSTRAINT itemcondition_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id) ON DELETE CASCADE;


--
-- Name: itemimage itemimage_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemimage
    ADD CONSTRAINT itemimage_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id) ON DELETE CASCADE;


--
-- Name: itemlocation itemlocation_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemlocation
    ADD CONSTRAINT itemlocation_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id) ON DELETE CASCADE;


--
-- Name: message message_chat_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_chat_room_id_fkey FOREIGN KEY (chat_room_id) REFERENCES public.chatroom(chat_room_id) ON DELETE CASCADE;


--
-- Name: message message_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.rentalorder(order_id) ON DELETE SET NULL;


--
-- Name: message message_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.useraccount(user_id) ON DELETE RESTRICT;


--
-- Name: payment payment_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.rentalorder(order_id) ON DELETE CASCADE;


--
-- Name: payment payment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.useraccount(user_id) ON DELETE RESTRICT;


--
-- Name: rentalevidenceimage rentalevidenceimage_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalevidenceimage
    ADD CONSTRAINT rentalevidenceimage_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.rentalorder(order_id) ON DELETE CASCADE;


--
-- Name: rentalevidenceimage rentalevidenceimage_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalevidenceimage
    ADD CONSTRAINT rentalevidenceimage_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.useraccount(user_id) ON DELETE RESTRICT;


--
-- Name: rentalorder rentalorder_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalorder
    ADD CONSTRAINT rentalorder_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id) ON DELETE RESTRICT;


--
-- Name: rentalorder rentalorder_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalorder
    ADD CONSTRAINT rentalorder_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.useraccount(user_id) ON DELETE RESTRICT;


--
-- Name: rentalreport rentalreport_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalreport
    ADD CONSTRAINT rentalreport_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.rentalorder(order_id) ON DELETE CASCADE;


--
-- Name: rentalreport rentalreport_report_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalreport
    ADD CONSTRAINT rentalreport_report_type_id_fkey FOREIGN KEY (report_type_id) REFERENCES public.rentalreporttype(report_type_id) ON DELETE RESTRICT;


--
-- Name: rentalreport rentalreport_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalreport
    ADD CONSTRAINT rentalreport_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.useraccount(user_id) ON DELETE RESTRICT;


--
-- Name: rentalreportimage rentalreportimage_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rentalreportimage
    ADD CONSTRAINT rentalreportimage_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.rentalreport(report_id) ON DELETE CASCADE;


--
-- Name: review review_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.rentalorder(order_id) ON DELETE CASCADE;


--
-- Name: reviewimage reviewimage_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviewimage
    ADD CONSTRAINT reviewimage_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.review(review_id) ON DELETE CASCADE;


--
-- Name: user_role_assignment user_role_assignment_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_assignment
    ADD CONSTRAINT user_role_assignment_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(role_id) ON DELETE RESTRICT;


--
-- Name: user_role_assignment user_role_assignment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_assignment
    ADD CONSTRAINT user_role_assignment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.useraccount(user_id) ON DELETE CASCADE;


--
-- Name: userphones userphones_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userphones
    ADD CONSTRAINT userphones_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.useraccount(user_id) ON DELETE CASCADE;


--
-- Name: availability; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.availability ENABLE ROW LEVEL SECURITY;

--
-- Name: availability availability_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY availability_select ON public.availability FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.item i
  WHERE ((i.item_id = availability.item_id) AND ((i.status = 'available'::text) OR (i.user_id = auth.uid()) OR public.is_admin())))));


--
-- Name: availability availability_write_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY availability_write_owner ON public.availability USING ((public.owns_item(item_id) OR public.is_admin())) WITH CHECK ((public.owns_item(item_id) OR public.is_admin()));


--
-- Name: bankaccount; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.bankaccount ENABLE ROW LEVEL SECURITY;

--
-- Name: bankaccount bankaccount_all_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY bankaccount_all_own_or_admin ON public.bankaccount USING (((user_id = auth.uid()) OR public.is_admin())) WITH CHECK (((user_id = auth.uid()) OR public.is_admin()));


--
-- Name: chatroom; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.chatroom ENABLE ROW LEVEL SECURITY;

--
-- Name: chatroom chatroom_insert_participant; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY chatroom_insert_participant ON public.chatroom FOR INSERT WITH CHECK (((renter_id = auth.uid()) OR (lender_id = auth.uid())));


--
-- Name: chatroom chatroom_select_participant_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY chatroom_select_participant_or_admin ON public.chatroom FOR SELECT USING (((renter_id = auth.uid()) OR (lender_id = auth.uid()) OR public.is_admin()));


--
-- Name: rentalevidenceimage evidence_insert_self; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY evidence_insert_self ON public.rentalevidenceimage FOR INSERT WITH CHECK (((user_id = auth.uid()) AND public.is_order_participant(order_id)));


--
-- Name: rentalevidenceimage evidence_select_participant_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY evidence_select_participant_or_admin ON public.rentalevidenceimage FOR SELECT USING ((public.is_order_participant(order_id) OR public.is_admin()));


--
-- Name: item; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.item ENABLE ROW LEVEL SECURITY;

--
-- Name: item item_delete_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY item_delete_own_or_admin ON public.item FOR DELETE USING (((user_id = auth.uid()) OR public.is_admin()));


--
-- Name: item item_insert_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY item_insert_own ON public.item FOR INSERT WITH CHECK ((user_id = auth.uid()));


--
-- Name: item item_select_available_or_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY item_select_available_or_own_or_admin ON public.item FOR SELECT USING (((status = 'available'::text) OR (user_id = auth.uid()) OR public.is_admin()));


--
-- Name: item item_update_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY item_update_own_or_admin ON public.item FOR UPDATE USING (((user_id = auth.uid()) OR public.is_admin()));


--
-- Name: itemcategory; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.itemcategory ENABLE ROW LEVEL SECURITY;

--
-- Name: itemcategory itemcategory_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY itemcategory_select_all ON public.itemcategory FOR SELECT USING (true);


--
-- Name: itemcategory itemcategory_write_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY itemcategory_write_admin ON public.itemcategory USING (public.is_admin()) WITH CHECK (public.is_admin());


--
-- Name: itemcondition; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.itemcondition ENABLE ROW LEVEL SECURITY;

--
-- Name: itemcondition itemcondition_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY itemcondition_select ON public.itemcondition FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.item i
  WHERE ((i.item_id = itemcondition.item_id) AND ((i.status = 'available'::text) OR (i.user_id = auth.uid()) OR public.is_admin())))));


--
-- Name: itemcondition itemcondition_write_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY itemcondition_write_owner ON public.itemcondition USING ((public.owns_item(item_id) OR public.is_admin())) WITH CHECK ((public.owns_item(item_id) OR public.is_admin()));


--
-- Name: itemimage; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.itemimage ENABLE ROW LEVEL SECURITY;

--
-- Name: itemimage itemimage_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY itemimage_select ON public.itemimage FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.item i
  WHERE ((i.item_id = itemimage.item_id) AND ((i.status = 'available'::text) OR (i.user_id = auth.uid()) OR public.is_admin())))));


--
-- Name: itemimage itemimage_write_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY itemimage_write_owner ON public.itemimage USING ((public.owns_item(item_id) OR public.is_admin())) WITH CHECK ((public.owns_item(item_id) OR public.is_admin()));


--
-- Name: itemlocation; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.itemlocation ENABLE ROW LEVEL SECURITY;

--
-- Name: itemlocation itemlocation_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY itemlocation_select ON public.itemlocation FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.item i
  WHERE ((i.item_id = itemlocation.item_id) AND ((i.status = 'available'::text) OR (i.user_id = auth.uid()) OR public.is_admin())))));


--
-- Name: itemlocation itemlocation_write_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY itemlocation_write_owner ON public.itemlocation USING ((public.owns_item(item_id) OR public.is_admin())) WITH CHECK ((public.owns_item(item_id) OR public.is_admin()));


--
-- Name: message; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.message ENABLE ROW LEVEL SECURITY;

--
-- Name: message message_insert_participant; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY message_insert_participant ON public.message FOR INSERT WITH CHECK (((sender_id = auth.uid()) AND (EXISTS ( SELECT 1
   FROM public.chatroom cr
  WHERE ((cr.chat_room_id = message.chat_room_id) AND ((cr.renter_id = auth.uid()) OR (cr.lender_id = auth.uid())))))));


--
-- Name: message message_select_participant_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY message_select_participant_or_admin ON public.message FOR SELECT USING (((EXISTS ( SELECT 1
   FROM public.chatroom cr
  WHERE ((cr.chat_room_id = message.chat_room_id) AND ((cr.renter_id = auth.uid()) OR (cr.lender_id = auth.uid()))))) OR public.is_admin()));


--
-- Name: message message_update_mark_read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY message_update_mark_read ON public.message FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.chatroom cr
  WHERE ((cr.chat_room_id = message.chat_room_id) AND ((cr.renter_id = auth.uid()) OR (cr.lender_id = auth.uid()))))));


--
-- Name: payment; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.payment ENABLE ROW LEVEL SECURITY;

--
-- Name: payment payment_select_participant_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY payment_select_participant_or_admin ON public.payment FOR SELECT USING (((user_id = auth.uid()) OR public.is_order_participant(order_id) OR public.is_admin()));


--
-- Name: rentalevidenceimage; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rentalevidenceimage ENABLE ROW LEVEL SECURITY;

--
-- Name: rentalorder; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rentalorder ENABLE ROW LEVEL SECURITY;

--
-- Name: rentalorder rentalorder_insert_renter; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rentalorder_insert_renter ON public.rentalorder FOR INSERT WITH CHECK ((user_id = auth.uid()));


--
-- Name: rentalorder rentalorder_select_participant_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rentalorder_select_participant_or_admin ON public.rentalorder FOR SELECT USING (((user_id = auth.uid()) OR public.owns_item(item_id) OR public.is_admin()));


--
-- Name: rentalorder rentalorder_update_admin_only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY rentalorder_update_admin_only ON public.rentalorder FOR UPDATE USING (public.is_admin());


--
-- Name: rentalreport; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rentalreport ENABLE ROW LEVEL SECURITY;

--
-- Name: rentalreportimage; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rentalreportimage ENABLE ROW LEVEL SECURITY;

--
-- Name: rentalreporttype; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rentalreporttype ENABLE ROW LEVEL SECURITY;

--
-- Name: rentalreport report_insert_self; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY report_insert_self ON public.rentalreport FOR INSERT WITH CHECK (((user_id = auth.uid()) AND public.is_order_participant(order_id)));


--
-- Name: rentalreport report_select_participant_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY report_select_participant_or_admin ON public.rentalreport FOR SELECT USING (((user_id = auth.uid()) OR public.is_order_participant(order_id) OR public.is_admin()));


--
-- Name: rentalreport report_update_admin_only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY report_update_admin_only ON public.rentalreport FOR UPDATE USING (public.is_admin());


--
-- Name: rentalreportimage reportimage_insert_self; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY reportimage_insert_self ON public.rentalreportimage FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.rentalreport rr
  WHERE ((rr.report_id = rentalreportimage.report_id) AND (rr.user_id = auth.uid())))));


--
-- Name: rentalreportimage reportimage_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY reportimage_select ON public.rentalreportimage FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.rentalreport rr
  WHERE ((rr.report_id = rentalreportimage.report_id) AND ((rr.user_id = auth.uid()) OR public.is_order_participant(rr.order_id) OR public.is_admin())))));


--
-- Name: rentalreporttype reporttype_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY reporttype_select_all ON public.rentalreporttype FOR SELECT USING (true);


--
-- Name: rentalreporttype reporttype_write_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY reporttype_write_admin ON public.rentalreporttype USING (public.is_admin()) WITH CHECK (public.is_admin());


--
-- Name: review; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.review ENABLE ROW LEVEL SECURITY;

--
-- Name: review review_insert_renter_after_completed; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY review_insert_renter_after_completed ON public.review FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.rentalorder ro
  WHERE ((ro.order_id = review.order_id) AND (ro.user_id = auth.uid()) AND (ro.status = 'completed'::text)))));


--
-- Name: review review_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY review_select_all ON public.review FOR SELECT USING (true);


--
-- Name: review review_update_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY review_update_own_or_admin ON public.review FOR UPDATE USING (((EXISTS ( SELECT 1
   FROM public.rentalorder ro
  WHERE ((ro.order_id = review.order_id) AND (ro.user_id = auth.uid())))) OR public.is_admin()));


--
-- Name: reviewimage; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.reviewimage ENABLE ROW LEVEL SECURITY;

--
-- Name: reviewimage reviewimage_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY reviewimage_select_all ON public.reviewimage FOR SELECT USING (true);


--
-- Name: reviewimage reviewimage_write_owner; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY reviewimage_write_owner ON public.reviewimage USING (((EXISTS ( SELECT 1
   FROM (public.review rv
     JOIN public.rentalorder ro ON ((ro.order_id = rv.order_id)))
  WHERE ((rv.review_id = reviewimage.review_id) AND (ro.user_id = auth.uid())))) OR public.is_admin())) WITH CHECK (((EXISTS ( SELECT 1
   FROM (public.review rv
     JOIN public.rentalorder ro ON ((ro.order_id = rv.order_id)))
  WHERE ((rv.review_id = reviewimage.review_id) AND (ro.user_id = auth.uid())))) OR public.is_admin()));


--
-- Name: role; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.role ENABLE ROW LEVEL SECURITY;

--
-- Name: role role_select_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY role_select_all ON public.role FOR SELECT USING (true);


--
-- Name: user_role_assignment roleassign_delete_admin_only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY roleassign_delete_admin_only ON public.user_role_assignment FOR DELETE USING (public.is_admin());


--
-- Name: user_role_assignment roleassign_insert_self_non_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY roleassign_insert_self_non_admin ON public.user_role_assignment FOR INSERT WITH CHECK ((public.is_admin() OR ((user_id = auth.uid()) AND (role_id IN ( SELECT role.role_id
   FROM public.role
  WHERE (role.role_type = ANY (ARRAY['renter'::text, 'lender'::text])))))));


--
-- Name: user_role_assignment roleassign_select_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY roleassign_select_own_or_admin ON public.user_role_assignment FOR SELECT USING (((user_id = auth.uid()) OR public.is_admin()));


--
-- Name: test_results; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.test_results ENABLE ROW LEVEL SECURITY;

--
-- Name: user_role_assignment; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_role_assignment ENABLE ROW LEVEL SECURITY;

--
-- Name: useraccount; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.useraccount ENABLE ROW LEVEL SECURITY;

--
-- Name: useraccount useraccount_insert_self; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY useraccount_insert_self ON public.useraccount FOR INSERT WITH CHECK ((user_id = auth.uid()));


--
-- Name: useraccount useraccount_select_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY useraccount_select_own_or_admin ON public.useraccount FOR SELECT USING (((user_id = auth.uid()) OR public.is_admin()));


--
-- Name: useraccount useraccount_update_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY useraccount_update_own_or_admin ON public.useraccount FOR UPDATE USING (((user_id = auth.uid()) OR public.is_admin()));


--
-- Name: userphones; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.userphones ENABLE ROW LEVEL SECURITY;

--
-- Name: userphones userphones_all_own_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY userphones_all_own_or_admin ON public.userphones USING (((user_id = auth.uid()) OR public.is_admin())) WITH CHECK (((user_id = auth.uid()) OR public.is_admin()));


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION confirm_additional_payment(p_payment_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.confirm_additional_payment(p_payment_id uuid) TO anon;
GRANT ALL ON FUNCTION public.confirm_additional_payment(p_payment_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.confirm_additional_payment(p_payment_id uuid) TO service_role;


--
-- Name: FUNCTION create_item_listing(p_user_id uuid, p_category_id uuid, p_item_name text, p_description text, p_original_price numeric, p_rental_fee_per_day numeric, p_deposit numeric, p_images jsonb, p_locations jsonb, p_availability_start date, p_availability_end date, p_conditions text[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_item_listing(p_user_id uuid, p_category_id uuid, p_item_name text, p_description text, p_original_price numeric, p_rental_fee_per_day numeric, p_deposit numeric, p_images jsonb, p_locations jsonb, p_availability_start date, p_availability_end date, p_conditions text[]) TO anon;
GRANT ALL ON FUNCTION public.create_item_listing(p_user_id uuid, p_category_id uuid, p_item_name text, p_description text, p_original_price numeric, p_rental_fee_per_day numeric, p_deposit numeric, p_images jsonb, p_locations jsonb, p_availability_start date, p_availability_end date, p_conditions text[]) TO authenticated;
GRANT ALL ON FUNCTION public.create_item_listing(p_user_id uuid, p_category_id uuid, p_item_name text, p_description text, p_original_price numeric, p_rental_fee_per_day numeric, p_deposit numeric, p_images jsonb, p_locations jsonb, p_availability_start date, p_availability_end date, p_conditions text[]) TO service_role;


--
-- Name: FUNCTION handle_new_auth_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_auth_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_auth_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_auth_user() TO service_role;


--
-- Name: FUNCTION is_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_admin() TO anon;
GRANT ALL ON FUNCTION public.is_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_admin() TO service_role;


--
-- Name: FUNCTION is_order_participant(p_order_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_order_participant(p_order_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_order_participant(p_order_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_order_participant(p_order_id uuid) TO service_role;


--
-- Name: FUNCTION owns_item(p_item_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.owns_item(p_item_id uuid) TO anon;
GRANT ALL ON FUNCTION public.owns_item(p_item_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.owns_item(p_item_id uuid) TO service_role;


--
-- Name: FUNCTION resolve_dispute(p_report_id uuid, p_outcome text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.resolve_dispute(p_report_id uuid, p_outcome text) TO anon;
GRANT ALL ON FUNCTION public.resolve_dispute(p_report_id uuid, p_outcome text) TO authenticated;
GRANT ALL ON FUNCTION public.resolve_dispute(p_report_id uuid, p_outcome text) TO service_role;


--
-- Name: FUNCTION set_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_updated_at() TO anon;
GRANT ALL ON FUNCTION public.set_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.set_updated_at() TO service_role;


--
-- Name: FUNCTION settle_rental_order(p_order_id uuid, p_damage_cost numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.settle_rental_order(p_order_id uuid, p_damage_cost numeric) TO anon;
GRANT ALL ON FUNCTION public.settle_rental_order(p_order_id uuid, p_damage_cost numeric) TO authenticated;
GRANT ALL ON FUNCTION public.settle_rental_order(p_order_id uuid, p_damage_cost numeric) TO service_role;


--
-- Name: FUNCTION submit_report(p_report_type_id uuid, p_user_id uuid, p_order_id uuid, p_report_topic text, p_description text, p_image_urls text[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.submit_report(p_report_type_id uuid, p_user_id uuid, p_order_id uuid, p_report_topic text, p_description text, p_image_urls text[]) TO anon;
GRANT ALL ON FUNCTION public.submit_report(p_report_type_id uuid, p_user_id uuid, p_order_id uuid, p_report_topic text, p_description text, p_image_urls text[]) TO authenticated;
GRANT ALL ON FUNCTION public.submit_report(p_report_type_id uuid, p_user_id uuid, p_order_id uuid, p_report_topic text, p_description text, p_image_urls text[]) TO service_role;


--
-- Name: FUNCTION submit_review(p_order_id uuid, p_rating integer, p_comment text, p_image_urls text[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.submit_review(p_order_id uuid, p_rating integer, p_comment text, p_image_urls text[]) TO anon;
GRANT ALL ON FUNCTION public.submit_review(p_order_id uuid, p_rating integer, p_comment text, p_image_urls text[]) TO authenticated;
GRANT ALL ON FUNCTION public.submit_review(p_order_id uuid, p_rating integer, p_comment text, p_image_urls text[]) TO service_role;


--
-- Name: FUNCTION upload_rental_evidence(p_order_id uuid, p_user_id uuid, p_evidence_type text, p_image_urls text[], p_new_status text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.upload_rental_evidence(p_order_id uuid, p_user_id uuid, p_evidence_type text, p_image_urls text[], p_new_status text) TO anon;
GRANT ALL ON FUNCTION public.upload_rental_evidence(p_order_id uuid, p_user_id uuid, p_evidence_type text, p_image_urls text[], p_new_status text) TO authenticated;
GRANT ALL ON FUNCTION public.upload_rental_evidence(p_order_id uuid, p_user_id uuid, p_evidence_type text, p_image_urls text[], p_new_status text) TO service_role;


--
-- Name: TABLE availability; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.availability TO anon;
GRANT ALL ON TABLE public.availability TO authenticated;
GRANT ALL ON TABLE public.availability TO service_role;


--
-- Name: TABLE bankaccount; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.bankaccount TO anon;
GRANT ALL ON TABLE public.bankaccount TO authenticated;
GRANT ALL ON TABLE public.bankaccount TO service_role;


--
-- Name: TABLE chatroom; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chatroom TO anon;
GRANT ALL ON TABLE public.chatroom TO authenticated;
GRANT ALL ON TABLE public.chatroom TO service_role;


--
-- Name: TABLE item; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.item TO anon;
GRANT ALL ON TABLE public.item TO authenticated;
GRANT ALL ON TABLE public.item TO service_role;


--
-- Name: TABLE itemcategory; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.itemcategory TO anon;
GRANT ALL ON TABLE public.itemcategory TO authenticated;
GRANT ALL ON TABLE public.itemcategory TO service_role;


--
-- Name: TABLE itemcondition; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.itemcondition TO anon;
GRANT ALL ON TABLE public.itemcondition TO authenticated;
GRANT ALL ON TABLE public.itemcondition TO service_role;


--
-- Name: TABLE itemimage; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.itemimage TO anon;
GRANT ALL ON TABLE public.itemimage TO authenticated;
GRANT ALL ON TABLE public.itemimage TO service_role;


--
-- Name: TABLE itemlocation; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.itemlocation TO anon;
GRANT ALL ON TABLE public.itemlocation TO authenticated;
GRANT ALL ON TABLE public.itemlocation TO service_role;


--
-- Name: TABLE message; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.message TO anon;
GRANT ALL ON TABLE public.message TO authenticated;
GRANT ALL ON TABLE public.message TO service_role;


--
-- Name: TABLE payment; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.payment TO anon;
GRANT ALL ON TABLE public.payment TO authenticated;
GRANT ALL ON TABLE public.payment TO service_role;


--
-- Name: TABLE useraccount; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.useraccount TO anon;
GRANT ALL ON TABLE public.useraccount TO authenticated;
GRANT ALL ON TABLE public.useraccount TO service_role;


--
-- Name: TABLE publicuserprofile; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.publicuserprofile TO anon;
GRANT ALL ON TABLE public.publicuserprofile TO authenticated;
GRANT ALL ON TABLE public.publicuserprofile TO service_role;


--
-- Name: TABLE rentalevidenceimage; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rentalevidenceimage TO anon;
GRANT ALL ON TABLE public.rentalevidenceimage TO authenticated;
GRANT ALL ON TABLE public.rentalevidenceimage TO service_role;


--
-- Name: TABLE rentalorder; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rentalorder TO anon;
GRANT ALL ON TABLE public.rentalorder TO authenticated;
GRANT ALL ON TABLE public.rentalorder TO service_role;


--
-- Name: TABLE rentalreport; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rentalreport TO anon;
GRANT ALL ON TABLE public.rentalreport TO authenticated;
GRANT ALL ON TABLE public.rentalreport TO service_role;


--
-- Name: TABLE rentalreportimage; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rentalreportimage TO anon;
GRANT ALL ON TABLE public.rentalreportimage TO authenticated;
GRANT ALL ON TABLE public.rentalreportimage TO service_role;


--
-- Name: TABLE rentalreporttype; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rentalreporttype TO anon;
GRANT ALL ON TABLE public.rentalreporttype TO authenticated;
GRANT ALL ON TABLE public.rentalreporttype TO service_role;


--
-- Name: TABLE review; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.review TO anon;
GRANT ALL ON TABLE public.review TO authenticated;
GRANT ALL ON TABLE public.review TO service_role;


--
-- Name: TABLE reviewimage; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reviewimage TO anon;
GRANT ALL ON TABLE public.reviewimage TO authenticated;
GRANT ALL ON TABLE public.reviewimage TO service_role;


--
-- Name: TABLE role; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.role TO anon;
GRANT ALL ON TABLE public.role TO authenticated;
GRANT ALL ON TABLE public.role TO service_role;


--
-- Name: TABLE test_results; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.test_results TO anon;
GRANT ALL ON TABLE public.test_results TO authenticated;
GRANT ALL ON TABLE public.test_results TO service_role;


--
-- Name: TABLE user_role_assignment; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_role_assignment TO anon;
GRANT ALL ON TABLE public.user_role_assignment TO authenticated;
GRANT ALL ON TABLE public.user_role_assignment TO service_role;


--
-- Name: TABLE userphones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.userphones TO anon;
GRANT ALL ON TABLE public.userphones TO authenticated;
GRANT ALL ON TABLE public.userphones TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- PostgreSQL database dump complete
--



--
-- PostgreSQL database dump
--



-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- PostgreSQL database dump complete
--




-- Realtime publication
DO \$\$ BEGIN
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.message, public.chatroom;
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END \$\$;



-- ==============================================================================
-- Supabase Auth Seed (Users and Identities)
-- ==============================================================================
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change, is_super_admin
) VALUES 
(
  '00000000-0000-0000-0000-000000000000',
  '8a88d60a-e2cf-43a6-b4ea-baa9347bfee1',
  'authenticated',
  'authenticated',
  'rommanlnw68@chaochao.local',
  '$2a$10$5hm5SmyBxV5uSWu1yf4j7Oq1l/Obf5M8pvauk6.UaV45gk54hWyDa',
  '2026-08-22 06:58:27+00',
  '{"provider": "email", "providers": ["email"]}',
  '{"role": "renter", "username": "romanlnw68", "avatar_url": "/api/avatar?id=8a88d60a-e2cf-43a6-b4ea-baa9347bfee1", "national_id": "6767676767676", "signup_role": "renter", "email_verified": true}',
  '2026-08-22 06:58:26.972531+00',
  '2026-08-25 12:10:00+00',
  '', '', '', '', false
),
(
  '00000000-0000-0000-0000-000000000000',
  'b5041d3d-ba07-4230-96fa-3fbfb4411439',
  'authenticated',
  'authenticated',
  'yoklnw67@chaochao.local',
  '$2a$10$AshLDfa0Lu5udzlV.2JR1OHKPawK3rA4qdJUmVY61eqIy11bKDtZK',
  '2026-08-22 07:44:22+00',
  '{"provider": "email", "providers": ["email"]}',
  '{"role": "lender", "username": "yoklnw67", "national_id": "1234567890123", "signup_role": "lender", "email_verified": true}',
  '2026-08-22 07:44:22.06373+00',
  '2026-08-25 12:10:00+00',
  '', '', '', '', false
),
(
  '00000000-0000-0000-0000-000000000000',
  'b6f3e426-ba65-4b9e-becd-820e4d65d146',
  'authenticated',
  'authenticated',
  'fantalnw66@chaochao.local',
  '$2a$10$GhnOwZx4A.bgEnYE8tdp9.obH5/ZJVOIgZzR/hax2JnTbr0DK7wYa',
  '2026-08-22 19:34:03+00',
  '{"provider": "email", "providers": ["email"]}',
  '{"role": "both", "username": "fantalnw66", "national_id": "6666666666666", "signup_role": "lender", "email_verified": true}',
  '2026-08-22 19:34:03.745712+00',
  '2026-08-25 12:10:00+00',
  '', '', '', '', false
)
ON CONFLICT (id) DO UPDATE SET
  encrypted_password = EXCLUDED.encrypted_password,
  email = EXCLUDED.email,
  raw_user_meta_data = EXCLUDED.raw_user_meta_data;

INSERT INTO auth.identities (
  id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, provider_id
) VALUES
(
  '8a88d60a-e2cf-43a6-b4ea-baa9347bfee1',
  '8a88d60a-e2cf-43a6-b4ea-baa9347bfee1',
  '{"sub": "8a88d60a-e2cf-43a6-b4ea-baa9347bfee1", "email": "rommanlnw68@chaochao.local", "email_verified": false, "phone_verified": false}',
  'email', NOW(), NOW(), NOW(), '06125dfd-ae14-4d02-8857-151e46c9ff48'
),
(
  'b5041d3d-ba07-4230-96fa-3fbfb4411439',
  'b5041d3d-ba07-4230-96fa-3fbfb4411439',
  '{"sub": "b5041d3d-ba07-4230-96fa-3fbfb4411439", "email": "yoklnw67@chaochao.local", "email_verified": false, "phone_verified": false}',
  'email', NOW(), NOW(), NOW(), 'c582972e-86f9-4113-8477-faae10dcc634'
),
(
  'b6f3e426-ba65-4b9e-becd-820e4d65d146',
  'b6f3e426-ba65-4b9e-becd-820e4d65d146',
  '{"sub": "b6f3e426-ba65-4b9e-becd-820e4d65d146", "email": "fantalnw66@chaochao.local", "email_verified": false, "phone_verified": false}',
  'email', NOW(), NOW(), NOW(), '25001b57-397c-4be7-b389-ddf7690f318e'
)
ON CONFLICT (provider, provider_id) DO NOTHING;


-- ==============================================================================
-- Schema public Permissions
-- ==============================================================================
GRANT ALL ON SCHEMA public TO postgres, supabase_admin, service_role, authenticated, anon;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, supabase_admin, service_role, authenticated, anon;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, supabase_admin, service_role, authenticated, anon;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO postgres, supabase_admin, service_role, authenticated, anon;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO postgres, supabase_admin, service_role, authenticated, anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres, supabase_admin, service_role, authenticated, anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON ROUTINES TO postgres, supabase_admin, service_role, authenticated, anon;
