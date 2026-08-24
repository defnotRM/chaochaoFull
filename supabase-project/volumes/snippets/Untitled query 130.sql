-- =========================================================
-- Chao-Chao Database Schema (ฉบับย่อ — 2 ตาราง)
-- UserAccount + Role เท่านั้น
-- (Phone, BankAccount เก็บเป็น array/jsonb ในตัว UserAccount เอง
--  ส่วนความสัมพันธ์ M:N กับ Role เก็บเป็น array ของ role_id)
-- =========================================================

create extension if not exists "pgcrypto";

-- ENUM สำหรับ RoleType
create type role_type_enum as enum ('Admin', 'Renter', 'Lender');

-- =========================================================
-- 1) ตาราง Role
-- =========================================================
create table public.role (
    role_id     uuid primary key default gen_random_uuid(),
    role_type   role_type_enum not null,
    created_at  timestamptz not null default now()
);

-- =========================================================
-- 2) ตาราง UserAccount
--    - phone_numbers   : เก็บได้หลายเบอร์ (multivalued -> array)
--    - bank_accounts   : เก็บ BankName/AccountName/AccountNumber
--                        หลายบัญชี (composite + multivalued -> jsonb array)
--    - role_ids        : เก็บ role ที่ user มี ได้หลาย role
--                        (M:N -> array of uuid, อ้างอิง role.role_id)
-- =========================================================
create table public.user_account (
    user_id        uuid primary key default gen_random_uuid(),
    username       varchar(50)  not null unique,
    password       varchar(255) not null,     -- ควรเก็บเป็น hash เท่านั้น
    email          varchar(255) not null unique,
    national_id    varchar(20)  not null unique,
    first_name     varchar(100) not null,
    last_name      varchar(100) not null,
    phone_numbers  text[] not null default '{}',
    bank_accounts  jsonb  not null default '[]',
    -- ตัวอย่างรูปแบบ bank_accounts:
    -- [{"bank_name": "SCB", "account_name": "Somchai", "account_number": "1234567890"}]
    role_ids       uuid[] not null default '{}',
    created_at     timestamptz not null default now(),
    updated_at     timestamptz not null default now()
);

-- =========================================================
-- Trigger: อัปเดต updated_at อัตโนมัติ
-- =========================================================
create or replace function public.set_updated_at()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

create trigger trg_user_account_updated_at
before update on public.user_account
for each row execute function public.set_updated_at();

-- =========================================================
-- Index: ช่วยค้นหา user ตาม role (GIN index สำหรับ array)
-- =========================================================
create index idx_user_account_role_ids on public.user_account using gin (role_ids);

-- =========================================================
-- RLS (ปิดไว้เป็นค่าเริ่มต้น เปิด/ตั้ง policy เพิ่มก่อนใช้จริง)
-- =========================================================
alter table public.user_account enable row level security;
alter table public.role         enable row level security;