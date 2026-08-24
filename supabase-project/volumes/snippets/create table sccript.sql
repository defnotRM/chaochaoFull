-- ตาราง renters (ผู้เช่า)
create table renters (
  id uuid primary key default gen_random_uuid(),
  username text not null unique,
  password text not null,
  national_id text not null,
  created_at timestamptz not null default now()
);

-- ตาราง lenders (ผู้ให้เช่า)
create table lenders (
  id uuid primary key default gen_random_uuid(),
  username text not null unique,
  password text not null,
  national_id text not null,
  created_at timestamptz not null default now()
);