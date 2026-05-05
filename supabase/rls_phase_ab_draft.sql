-- Pe na Areia - Row Level Security draft for Phase A and Phase B.
--
-- DRAFT - do not execute without technical, product, and security review.
-- The current MVP 1 is still mocked and does not use a real Supabase backend.
-- This file is not an official migration.
-- This file depends on the draft schema in supabase/schema_phase_ab_draft.sql.
-- This file does not contain seed data.
-- This file does not contain Storage policies.
-- Do not use this file in production without tests, review, and validation with real roles.
-- Do not add secrets, API keys, URLs, passwords, or real personal data here.
--
-- Security notes:
-- - Never use the service_role key in Flutter or any client app.
-- - Test every policy before inserting or exposing real data.
-- - Keep public data separate from administrative and personal data.
-- - Review LGPD requirements before collecting or exposing personal data.
-- - Write policies should remain conservative.
-- - Avoid permissive policies using `true` without a specific restriction.
-- - This draft assumes the columns and enums from schema_phase_ab_draft.sql.
-- - This draft does not create, modify, or seed application data.

-- ---------------------------------------------------------------------------
-- Helper functions
-- ---------------------------------------------------------------------------

create or replace function public.is_platform_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles p
    where p.auth_user_id = auth.uid()
      and p.role = 'platform_admin'
      and p.is_active = true
  );
$$;

comment on function public.is_platform_admin() is
  'Draft helper. Returns true when the authenticated user has an active platform_admin profile.';

create or replace function public.is_establishment_member(target_establishment_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.establishment_members m
    join public.profiles p on p.id = m.profile_id
    where p.auth_user_id = auth.uid()
      and p.is_active = true
      and m.establishment_id = target_establishment_id
      and m.is_active = true
      and m.role in ('establishment_owner', 'establishment_staff')
  );
$$;

comment on function public.is_establishment_member(uuid) is
  'Draft helper. Returns true when the authenticated user is an active member of the requested establishment.';

create or replace function public.can_manage_establishment(target_establishment_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.is_platform_admin()
    or exists (
      select 1
      from public.establishment_members m
      join public.profiles p on p.id = m.profile_id
      where p.auth_user_id = auth.uid()
        and p.is_active = true
        and m.establishment_id = target_establishment_id
        and m.is_active = true
        and (
          m.role = 'establishment_owner'
          or m.permissions @> '{"manage_establishment": true}'::jsonb
          or m.permissions @> '{"manage_menu": true}'::jsonb
          or m.permissions @> '{"manage_availability": true}'::jsonb
        )
    );
$$;

comment on function public.can_manage_establishment(uuid) is
  'Draft helper. Returns true for platform admins, establishment owners, or members with future management permissions.';

-- TODO before execution:
-- Review whether granular helpers are needed, for example:
-- - can_manage_menu(establishment_id uuid)
-- - can_manage_availability(establishment_id uuid)
-- - can_manage_establishment_photos(establishment_id uuid)
-- The current helper is intentionally simple for review and should not be
-- treated as final authorization design.

-- ---------------------------------------------------------------------------
-- Enable RLS
-- ---------------------------------------------------------------------------

alter table public.profiles enable row level security;
alter table public.beaches enable row level security;
alter table public.establishments enable row level security;
alter table public.establishment_photos enable row level security;
alter table public.menu_categories enable row level security;
alter table public.menu_items enable row level security;
alter table public.establishment_availability_snapshots enable row level security;
alter table public.establishment_signup_requests enable row level security;
alter table public.establishment_members enable row level security;
alter table public.audit_logs enable row level security;

-- ---------------------------------------------------------------------------
-- Public read policies for Phase A data
-- ---------------------------------------------------------------------------

create policy "Visitors can read active beaches"
on public.beaches
for select
to anon, authenticated
using (
  status = 'active'
  and is_active = true
);

create policy "Platform admins can manage beaches"
on public.beaches
for all
to authenticated
using (public.is_platform_admin())
with check (public.is_platform_admin());

create policy "Visitors can read approved active establishments"
on public.establishments
for select
to anon, authenticated
using (
  status = 'approved'
  and is_active = true
  and exists (
    select 1
    from public.beaches b
    where b.id = establishments.beach_id
      and b.status = 'active'
      and b.is_active = true
  )
);

create policy "Members can read their own establishment"
on public.establishments
for select
to authenticated
using (
  public.is_establishment_member(id)
  or public.is_platform_admin()
);

create policy "Authorized members can update their own establishment"
on public.establishments
for update
to authenticated
using (public.can_manage_establishment(id))
with check (
  public.can_manage_establishment(id)
  -- TODO before execution:
  -- Restrict sensitive fields such as status, beach_id, slug, and approval data.
  -- PostgreSQL RLS cannot limit changed columns by itself; consider column
  -- privileges, RPC functions, triggers, or a separate admin-only workflow.
);

create policy "Platform admins can insert establishments"
on public.establishments
for insert
to authenticated
with check (public.is_platform_admin());

create policy "Platform admins can manage establishments"
on public.establishments
for delete
to authenticated
using (public.is_platform_admin());

create policy "Visitors can read public establishment photos"
on public.establishment_photos
for select
to anon, authenticated
using (
  is_active = true
  and exists (
    select 1
    from public.establishments e
    join public.beaches b on b.id = e.beach_id
    where e.id = establishment_photos.establishment_id
      and e.status = 'approved'
      and e.is_active = true
      and b.status = 'active'
      and b.is_active = true
  )
);

create policy "Authorized members can manage establishment photos"
on public.establishment_photos
for all
to authenticated
using (public.can_manage_establishment(establishment_id))
with check (public.can_manage_establishment(establishment_id));

create policy "Visitors can read public menu categories"
on public.menu_categories
for select
to anon, authenticated
using (
  is_active = true
  and exists (
    select 1
    from public.establishments e
    join public.beaches b on b.id = e.beach_id
    where e.id = menu_categories.establishment_id
      and e.status = 'approved'
      and e.is_active = true
      and b.status = 'active'
      and b.is_active = true
  )
);

create policy "Authorized members can manage menu categories"
on public.menu_categories
for all
to authenticated
using (public.can_manage_establishment(establishment_id))
with check (public.can_manage_establishment(establishment_id));

create policy "Visitors can read public menu items"
on public.menu_items
for select
to anon, authenticated
using (
  status = 'available'
  and is_active = true
  and exists (
    select 1
    from public.menu_categories c
    join public.establishments e on e.id = c.establishment_id
    join public.beaches b on b.id = e.beach_id
    where c.id = menu_items.category_id
      and c.establishment_id = menu_items.establishment_id
      and c.is_active = true
      and e.status = 'approved'
      and e.is_active = true
      and b.status = 'active'
      and b.is_active = true
  )
);

create policy "Authorized members can manage menu items"
on public.menu_items
for all
to authenticated
using (public.can_manage_establishment(establishment_id))
with check (
  public.can_manage_establishment(establishment_id)
  and exists (
    select 1
    from public.menu_categories c
    where c.id = menu_items.category_id
      and c.establishment_id = menu_items.establishment_id
  )
);

create policy "Visitors can read public availability snapshots"
on public.establishment_availability_snapshots
for select
to anon, authenticated
using (
  is_active = true
  and exists (
    select 1
    from public.establishments e
    join public.beaches b on b.id = e.beach_id
    where e.id = establishment_availability_snapshots.establishment_id
      and e.status = 'approved'
      and e.is_active = true
      and b.status = 'active'
      and b.is_active = true
  )
);

create policy "Authorized members can insert availability snapshots"
on public.establishment_availability_snapshots
for insert
to authenticated
with check (public.can_manage_establishment(establishment_id));

create policy "Authorized members can read own availability history"
on public.establishment_availability_snapshots
for select
to authenticated
using (
  public.can_manage_establishment(establishment_id)
  or public.is_platform_admin()
);

-- Availability snapshots should generally be append-only.
-- Prefer inserting a new snapshot instead of updating old rows.
create policy "Platform admins can correct availability snapshots"
on public.establishment_availability_snapshots
for update
to authenticated
using (public.is_platform_admin())
with check (public.is_platform_admin());

-- ---------------------------------------------------------------------------
-- Profiles
-- ---------------------------------------------------------------------------

create policy "Authenticated users can read own profile"
on public.profiles
for select
to authenticated
using (
  auth_user_id = auth.uid()
  and is_active = true
);

create policy "Authenticated users can insert own profile"
on public.profiles
for insert
to authenticated
with check (
  auth_user_id = auth.uid()
  and role = 'customer'
  and is_active = true
);

create policy "Authenticated users can update basic own profile"
on public.profiles
for update
to authenticated
using (
  auth_user_id = auth.uid()
  and is_active = true
)
with check (
  auth_user_id = auth.uid()
  and role = 'customer'
  and is_active = true
  -- TODO before execution:
  -- Protect role, is_active, auth_user_id, email verification assumptions, and
  -- any future sensitive fields with column privileges, triggers, or RPC.
  -- RLS alone cannot verify which specific columns changed.
);

create policy "Platform admins can read profiles"
on public.profiles
for select
to authenticated
using (public.is_platform_admin());

create policy "Platform admins can manage profiles"
on public.profiles
for update
to authenticated
using (public.is_platform_admin())
with check (public.is_platform_admin());

-- ---------------------------------------------------------------------------
-- Signup requests
-- ---------------------------------------------------------------------------

create policy "Authenticated users can create own signup requests"
on public.establishment_signup_requests
for insert
to authenticated
with check (
  status = 'pending'
  and reviewed_by_profile_id is null
  and reviewed_at is null
  and rejection_reason is null
  and created_establishment_id is null
  and exists (
    select 1
    from public.profiles p
    where p.id = establishment_signup_requests.requester_profile_id
      and p.auth_user_id = auth.uid()
      and p.is_active = true
  )
);

create policy "Authenticated users can read own signup requests"
on public.establishment_signup_requests
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles p
    where p.id = establishment_signup_requests.requester_profile_id
      and p.auth_user_id = auth.uid()
      and p.is_active = true
  )
);

create policy "Platform admins can manage signup requests"
on public.establishment_signup_requests
for all
to authenticated
using (public.is_platform_admin())
with check (public.is_platform_admin());

-- TODO before execution:
-- Decide whether unauthenticated visitors may create signup requests. If yes,
-- create a separate, carefully limited insert policy with anti-abuse controls.

-- ---------------------------------------------------------------------------
-- Establishment members
-- ---------------------------------------------------------------------------

create policy "Members can read own membership rows"
on public.establishment_members
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles p
    where p.id = establishment_members.profile_id
      and p.auth_user_id = auth.uid()
      and p.is_active = true
  )
);

create policy "Establishment owners can read members from own establishment"
on public.establishment_members
for select
to authenticated
using (
  public.can_manage_establishment(establishment_id)
  or public.is_platform_admin()
);

create policy "Platform admins can manage establishment members"
on public.establishment_members
for all
to authenticated
using (public.is_platform_admin())
with check (public.is_platform_admin());

-- TODO before execution:
-- If owners may invite staff later, add a narrow insert/update policy that:
-- - allows only the owner's own establishment;
-- - blocks changes to platform_admin;
-- - prevents staff from changing their own role or permissions;
-- - creates audit_logs through a safe server-side process.

-- ---------------------------------------------------------------------------
-- Audit logs
-- ---------------------------------------------------------------------------

create policy "Platform admins can read audit logs"
on public.audit_logs
for select
to authenticated
using (public.is_platform_admin());

-- Best-practice draft:
-- Audit logs should be append-only and written by trusted server-side paths,
-- such as triggers, Edge Functions, or backend jobs using carefully protected
-- credentials. Client apps should not write arbitrary audit_logs directly.
--
-- This conservative draft only allows platform admins to insert audit rows.
-- Before production, prefer a dedicated RPC or trigger path instead of broad
-- client-side insert access.
create policy "Platform admins can insert audit logs"
on public.audit_logs
for insert
to authenticated
with check (public.is_platform_admin());

-- No public, customer, establishment owner, or staff update/delete policies are
-- defined for audit_logs. Keeping those policies absent means normal clients
-- cannot update or delete logs under RLS.

-- ---------------------------------------------------------------------------
-- Final review checklist
-- ---------------------------------------------------------------------------

-- Before executing any part of this draft:
-- - Review all policies against the final schema.
-- - Test as anon, customer, establishment_owner, establishment_staff, and platform_admin.
-- - Verify public reads expose only approved, active, non-sensitive records.
-- - Verify users cannot read or update another user's profile.
-- - Verify users cannot grant themselves platform_admin or establishment access.
-- - Verify establishments cannot access another establishment's records.
-- - Verify signup request personal data is not public.
-- - Verify audit_logs cannot be edited or deleted by normal clients.
-- - Review LGPD data minimization and retention requirements.
-- - Keep Storage policies in a separate reviewed file.
-- - Keep seed data in a separate reviewed file.
