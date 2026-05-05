-- Pe na Areia - Supabase/PostgreSQL schema draft for Phase A and Phase B.
--
-- DRAFT - do not execute without technical, product, and security review.
-- The current MVP 1 is still mocked and does not use a real Supabase backend.
-- This file is not an official migration.
-- This file does not contain complete Row Level Security policies.
-- This file does not contain seed data.
-- Do not add secrets, API keys, URLs, passwords, or real personal data here.

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

do $$
begin
  if not exists (select 1 from pg_type where typname = 'beach_status') then
    create type beach_status as enum ('active', 'inactive');
  end if;

  if not exists (select 1 from pg_type where typname = 'establishment_status') then
    create type establishment_status as enum (
      'pending',
      'approved',
      'rejected',
      'suspended',
      'inactive'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'signup_request_status') then
    create type signup_request_status as enum ('pending', 'approved', 'rejected');
  end if;

  if not exists (select 1 from pg_type where typname = 'profile_role') then
    create type profile_role as enum (
      'customer',
      'establishment_owner',
      'establishment_staff',
      'platform_admin'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'operation_type') then
    create type operation_type as enum (
      'bar',
      'beach_tent',
      'beach_restaurant',
      'kiosk'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'menu_item_status') then
    create type menu_item_status as enum ('available', 'unavailable');
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- Phase B foundation: profiles
-- ---------------------------------------------------------------------------

create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null references auth.users(id) on delete cascade,
  full_name text,
  email text,
  phone text,
  avatar_url text,
  role profile_role not null default 'customer',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint profiles_auth_user_id_unique unique (auth_user_id),
  constraint profiles_email_unique unique (email),
  constraint profiles_email_format_check check (
    email is null or email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
  )
);

comment on table public.profiles is
  'Draft profile table for future Supabase Auth users. Visitors without login do not need profiles.';
comment on column public.profiles.auth_user_id is
  'Future relationship with Supabase Auth auth.users(id).';

-- ---------------------------------------------------------------------------
-- Phase A: public MVP 1 data
-- ---------------------------------------------------------------------------

create table if not exists public.beaches (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null,
  city text not null,
  state text not null,
  country text not null default 'Brasil',
  neighborhood text,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  status beach_status not null default 'active',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint beaches_slug_unique unique (slug),
  constraint beaches_name_city_state_unique unique (name, city, state),
  constraint beaches_name_not_blank check (length(trim(name)) > 0),
  constraint beaches_slug_not_blank check (length(trim(slug)) > 0),
  constraint beaches_city_not_blank check (length(trim(city)) > 0),
  constraint beaches_state_not_blank check (length(trim(state)) > 0),
  constraint beaches_latitude_check check (latitude is null or latitude between -90 and 90),
  constraint beaches_longitude_check check (longitude is null or longitude between -180 and 180)
);

create table if not exists public.establishments (
  id uuid primary key default gen_random_uuid(),
  beach_id uuid not null references public.beaches(id) on delete restrict,
  name text not null,
  slug text not null,
  description text,
  operation_type operation_type not null,
  phone text,
  address text,
  reference_point text,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  cover_image_url text,
  logo_url text,
  opening_hours jsonb,
  average_rating numeric(3, 2),
  reviews_count integer not null default 0,
  status establishment_status not null default 'pending',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint establishments_slug_unique unique (slug),
  constraint establishments_name_not_blank check (length(trim(name)) > 0),
  constraint establishments_slug_not_blank check (length(trim(slug)) > 0),
  constraint establishments_rating_check check (
    average_rating is null or average_rating between 0 and 5
  ),
  constraint establishments_reviews_count_check check (reviews_count >= 0),
  constraint establishments_latitude_check check (latitude is null or latitude between -90 and 90),
  constraint establishments_longitude_check check (longitude is null or longitude between -180 and 180)
);

create table if not exists public.establishment_photos (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  url text not null,
  alt_text text,
  display_order integer not null default 0,
  is_cover boolean not null default false,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint establishment_photos_url_not_blank check (length(trim(url)) > 0),
  constraint establishment_photos_display_order_check check (display_order >= 0)
);

create table if not exists public.menu_categories (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  name text not null,
  description text,
  display_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint menu_categories_establishment_name_unique unique (establishment_id, name),
  constraint menu_categories_id_establishment_unique unique (id, establishment_id),
  constraint menu_categories_name_not_blank check (length(trim(name)) > 0),
  constraint menu_categories_display_order_check check (display_order >= 0)
);

create table if not exists public.menu_items (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null,
  category_id uuid not null,
  name text not null,
  description text,
  price_cents integer not null,
  image_url text,
  status menu_item_status not null default 'available',
  is_active boolean not null default true,
  display_order integer not null default 0,
  preparation_time_minutes integer,
  cashback_preview_text text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint menu_items_establishment_fk foreign key (establishment_id)
    references public.establishments(id) on delete cascade,
  constraint menu_items_category_establishment_fk foreign key (category_id, establishment_id)
    references public.menu_categories(id, establishment_id) on delete restrict,
  constraint menu_items_name_not_blank check (length(trim(name)) > 0),
  constraint menu_items_price_cents_check check (price_cents >= 0),
  constraint menu_items_display_order_check check (display_order >= 0),
  constraint menu_items_preparation_time_check check (
    preparation_time_minutes is null or preparation_time_minutes >= 0
  )
);

create table if not exists public.establishment_availability_snapshots (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  total_sets integer not null,
  available_sets integer not null,
  occupied_sets integer,
  availability_label text,
  source text,
  is_active boolean not null default true,
  captured_at timestamptz not null default now(),
  created_at timestamptz not null default now(),

  constraint availability_total_sets_check check (total_sets >= 0),
  constraint availability_available_sets_check check (available_sets >= 0),
  constraint availability_occupied_sets_check check (occupied_sets is null or occupied_sets >= 0),
  constraint availability_available_lte_total_check check (available_sets <= total_sets),
  constraint availability_occupied_lte_total_check check (
    occupied_sets is null or occupied_sets <= total_sets
  )
);

comment on table public.establishment_availability_snapshots is
  'Aggregated public availability snapshots. This does not model physical sets, QR Codes, reservations, orders, or tabs.';

-- ---------------------------------------------------------------------------
-- Phase B: signup requests, members, and audit logs
-- ---------------------------------------------------------------------------

create table if not exists public.establishment_signup_requests (
  id uuid primary key default gen_random_uuid(),
  beach_id uuid references public.beaches(id) on delete set null,
  requester_profile_id uuid references public.profiles(id) on delete set null,
  requester_name text not null,
  requester_phone text,
  requester_email text,
  establishment_name text not null,
  operation_type operation_type,
  address text,
  reference_point text,
  message text,
  status signup_request_status not null default 'pending',
  reviewed_by_profile_id uuid references public.profiles(id) on delete set null,
  reviewed_at timestamptz,
  rejection_reason text,
  created_establishment_id uuid references public.establishments(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint signup_requests_requester_name_not_blank check (length(trim(requester_name)) > 0),
  constraint signup_requests_establishment_name_not_blank check (length(trim(establishment_name)) > 0),
  constraint signup_requests_email_format_check check (
    requester_email is null
    or requester_email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
  ),
  constraint signup_requests_review_check check (
    (status = 'pending' and reviewed_at is null)
    or (status in ('approved', 'rejected') and reviewed_at is not null)
  )
);

create table if not exists public.establishment_members (
  id uuid primary key default gen_random_uuid(),
  establishment_id uuid not null references public.establishments(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  role profile_role not null,
  permissions jsonb,
  is_active boolean not null default true,
  invited_by_profile_id uuid references public.profiles(id) on delete set null,
  invited_at timestamptz,
  accepted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint establishment_members_unique unique (establishment_id, profile_id),
  constraint establishment_members_role_check check (
    role in ('establishment_owner', 'establishment_staff')
  )
);

comment on table public.establishment_members is
  'Draft relationship table that links future profiles to establishments.';

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_profile_id uuid references public.profiles(id) on delete set null,
  establishment_id uuid references public.establishments(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  metadata jsonb,
  ip_address text,
  user_agent text,
  created_at timestamptz not null default now(),

  constraint audit_logs_action_not_blank check (length(trim(action)) > 0),
  constraint audit_logs_entity_type_not_blank check (length(trim(entity_type)) > 0)
);

comment on table public.audit_logs is
  'Draft audit table. Do not store secrets or unnecessary personal data in metadata.';

-- ---------------------------------------------------------------------------
-- Useful indexes
-- ---------------------------------------------------------------------------

create index if not exists idx_profiles_auth_user_id on public.profiles(auth_user_id);
create index if not exists idx_profiles_role on public.profiles(role);
create index if not exists idx_profiles_is_active on public.profiles(is_active);

create index if not exists idx_beaches_status on public.beaches(status);
create index if not exists idx_beaches_is_active on public.beaches(is_active);
create index if not exists idx_beaches_slug on public.beaches(slug);

create index if not exists idx_establishments_beach_id on public.establishments(beach_id);
create index if not exists idx_establishments_status on public.establishments(status);
create index if not exists idx_establishments_is_active on public.establishments(is_active);
create index if not exists idx_establishments_slug on public.establishments(slug);

create index if not exists idx_establishment_photos_establishment_id
  on public.establishment_photos(establishment_id);
create index if not exists idx_establishment_photos_is_active
  on public.establishment_photos(is_active);

create index if not exists idx_menu_categories_establishment_id
  on public.menu_categories(establishment_id);
create index if not exists idx_menu_categories_is_active
  on public.menu_categories(is_active);

create index if not exists idx_menu_items_establishment_id
  on public.menu_items(establishment_id);
create index if not exists idx_menu_items_category_id
  on public.menu_items(category_id);
create index if not exists idx_menu_items_status
  on public.menu_items(status);
create index if not exists idx_menu_items_is_active
  on public.menu_items(is_active);

create index if not exists idx_availability_establishment_id
  on public.establishment_availability_snapshots(establishment_id);
create index if not exists idx_availability_is_active
  on public.establishment_availability_snapshots(is_active);
create index if not exists idx_availability_captured_at
  on public.establishment_availability_snapshots(captured_at desc);

create index if not exists idx_signup_requests_beach_id
  on public.establishment_signup_requests(beach_id);
create index if not exists idx_signup_requests_requester_profile_id
  on public.establishment_signup_requests(requester_profile_id);
create index if not exists idx_signup_requests_status
  on public.establishment_signup_requests(status);
create index if not exists idx_signup_requests_created_establishment_id
  on public.establishment_signup_requests(created_establishment_id);

create index if not exists idx_establishment_members_establishment_id
  on public.establishment_members(establishment_id);
create index if not exists idx_establishment_members_profile_id
  on public.establishment_members(profile_id);
create index if not exists idx_establishment_members_is_active
  on public.establishment_members(is_active);

create index if not exists idx_audit_logs_actor_profile_id
  on public.audit_logs(actor_profile_id);
create index if not exists idx_audit_logs_establishment_id
  on public.audit_logs(establishment_id);
create index if not exists idx_audit_logs_entity
  on public.audit_logs(entity_type, entity_id);
create index if not exists idx_audit_logs_created_at
  on public.audit_logs(created_at desc);

-- ---------------------------------------------------------------------------
-- RLS note
-- ---------------------------------------------------------------------------

-- Do not create complete Row Level Security in this draft.
-- RLS must be created and reviewed in a separate script/cycle before real data
-- is inserted or exposed through the app.
--
-- Future RLS should cover, at minimum:
-- - public read access only for active beaches and approved active establishments;
-- - public read access only for active photos, categories, menu items, and availability;
-- - authenticated users reading/updating only allowed fields in their own profile;
-- - establishment members accessing only their own establishment records;
-- - platform admins managing approvals and administrative records;
-- - restricted access to audit_logs.

-- ---------------------------------------------------------------------------
-- Seed note
-- ---------------------------------------------------------------------------

-- No seed data belongs in this file.
-- Initial Boa Viagem and mock-equivalent data should be handled in a separate,
-- reviewed seed script after schema and RLS review.
