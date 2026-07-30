-- Phase 1 schema: roles, profiles, content tables, analytics, admin
-- support tables, and Row Level Security. Run this against a fresh
-- Supabase project (SQL Editor, or `supabase db push` once linked).
--
-- Conventions used throughout:
--   * every table has: id (uuid pk), created_at, updated_at, created_by,
--     updated_by, status, is_deleted (soft delete flag) — except `logs`,
--     which is an append-only audit trail and intentionally has none of the
--     mutable/status columns.
--   * `status` is a free-text field constrained per-table via CHECK; content
--     tables use draft/published/archived, profiles use active/suspended.
--   * RLS is enabled on every table. Public (anon) access is read-only and
--     limited to published, non-deleted rows; all writes require the caller
--     to be an admin (see `is_admin()` below).

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Roles & profiles
-- ---------------------------------------------------------------------------

create table public.roles (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into public.roles (name, description) values
  ('super_admin', 'Full access, including user and system management'),
  ('administrator', 'Manage products, models, content, and analytics')
on conflict (name) do nothing;

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  display_name text,
  role_id uuid not null references public.roles (id),
  status text not null default 'active' check (status in ('active', 'suspended')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

-- Auto-provision a profile (defaulting to 'administrator') whenever a new
-- Supabase auth user is created. Public users never sign up, so every
-- auth.users row is, by definition, an admin.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  default_role_id uuid;
begin
  select id into default_role_id from public.roles where name = 'administrator';

  insert into public.profiles (id, email, role_id, created_by, updated_by)
  values (new.id, new.email, default_role_id, new.id, new.id);

  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Categories
-- ---------------------------------------------------------------------------

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  parent_id uuid references public.categories (id) on delete set null,
  status text not null default 'published' check (status in ('draft', 'published', 'archived')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

-- ---------------------------------------------------------------------------
-- Products
-- ---------------------------------------------------------------------------

create table public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  category_id uuid references public.categories (id) on delete set null,
  manufacturer text,
  model_number text,
  serial_number text,
  version text,
  thumbnail_url text,
  cover_image_url text,
  tags text[] not null default '{}',
  status text not null default 'draft' check (status in ('draft', 'published', 'archived')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

create index products_category_id_idx on public.products (category_id);
create index products_tags_idx on public.products using gin (tags);

-- ---------------------------------------------------------------------------
-- Media (images, video, audio, documents — the general attachment library)
-- ---------------------------------------------------------------------------

create table public.media (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references public.products (id) on delete cascade,
  type text not null check (type in ('image', 'video', 'audio', 'pdf', 'document', 'other')),
  file_path text not null,
  file_name text,
  mime_type text,
  file_size_bytes bigint,
  status text not null default 'published' check (status in ('draft', 'published', 'archived')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

create index media_product_id_idx on public.media (product_id);

-- ---------------------------------------------------------------------------
-- 3D Models
-- ---------------------------------------------------------------------------

create table public.models (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  file_path text not null,
  format text not null check (format in ('glb', 'gltf', 'obj', 'fbx')),
  version integer not null default 1,
  file_size_bytes bigint,
  status text not null default 'draft' check (status in ('draft', 'published', 'archived')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

create index models_product_id_idx on public.models (product_id);

-- ---------------------------------------------------------------------------
-- Hotspots (interactive markers placed on a model)
-- ---------------------------------------------------------------------------

create table public.hotspots (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  model_id uuid not null references public.models (id) on delete cascade,
  media_id uuid references public.media (id) on delete set null,
  title text not null,
  description text,
  position_x double precision not null default 0,
  position_y double precision not null default 0,
  position_z double precision not null default 0,
  link_url text,
  status text not null default 'published' check (status in ('draft', 'published', 'archived')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

create index hotspots_model_id_idx on public.hotspots (model_id);

-- ---------------------------------------------------------------------------
-- Scans (one row per QR-code scan; anonymous)
-- ---------------------------------------------------------------------------

create table public.scans (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references public.products (id) on delete set null,
  scanned_at timestamptz not null default now(),
  device_type text,
  os text,
  browser text,
  country text,
  city text,
  referrer text,
  language text,
  status text not null default 'active' check (status in ('active', 'flagged')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

create index scans_product_id_idx on public.scans (product_id);
create index scans_scanned_at_idx on public.scans (scanned_at);

-- ---------------------------------------------------------------------------
-- Analytics (viewer/AR interaction events beyond the initial scan)
-- ---------------------------------------------------------------------------

create table public.analytics (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references public.products (id) on delete set null,
  event_type text not null check (
    event_type in ('viewer_open', 'ar_launch', 'download', 'video_play', 'hotspot_click', 'screenshot')
  ),
  metadata jsonb not null default '{}',
  occurred_at timestamptz not null default now(),
  device_type text,
  os text,
  browser text,
  country text,
  city text,
  referrer text,
  language text,
  status text not null default 'active' check (status in ('active', 'flagged')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

create index analytics_product_id_idx on public.analytics (product_id);
create index analytics_event_type_idx on public.analytics (event_type);

-- ---------------------------------------------------------------------------
-- Reports (generated report history)
-- ---------------------------------------------------------------------------

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  type text not null check (
    type in ('products', 'analytics', 'scans', 'models', 'categories', 'storage', 'downloads', 'ar_usage')
  ),
  format text not null check (format in ('pdf', 'excel', 'csv')),
  file_path text,
  parameters jsonb not null default '{}',
  status text not null default 'pending' check (status in ('pending', 'completed', 'failed')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

-- ---------------------------------------------------------------------------
-- Settings (system configuration, key/value)
-- ---------------------------------------------------------------------------

create table public.settings (
  id uuid primary key default gen_random_uuid(),
  key text not null unique,
  value jsonb not null default '{}',
  description text,
  status text not null default 'active' check (status in ('active', 'inactive')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

-- ---------------------------------------------------------------------------
-- Logs (append-only admin action audit trail — no status/soft-delete/updated
-- columns by design, since audit rows must never be mutated)
-- ---------------------------------------------------------------------------

create table public.logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references auth.users (id),
  action text not null,
  table_name text not null,
  record_id uuid,
  old_data jsonb,
  new_data jsonb,
  created_at timestamptz not null default now()
);

create index logs_table_name_record_id_idx on public.logs (table_name, record_id);

-- ---------------------------------------------------------------------------
-- Notifications (admin-facing system notifications)
-- ---------------------------------------------------------------------------

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid references auth.users (id), -- null = broadcast to all admins
  type text not null check (
    type in ('failed_upload', 'storage_limit', 'new_model', 'system_error', 'security_alert')
  ),
  title text not null,
  message text,
  is_read boolean not null default false,
  metadata jsonb not null default '{}',
  status text not null default 'active' check (status in ('active', 'archived')),
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id),
  updated_by uuid references auth.users (id)
);

create index notifications_recipient_id_idx on public.notifications (recipient_id);

-- ---------------------------------------------------------------------------
-- Shared trigger: auto-touch updated_at on every table that has one
-- ---------------------------------------------------------------------------

create function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

do $$
declare
  t text;
begin
  foreach t in array array[
    'profiles', 'categories', 'products', 'media', 'models', 'hotspots',
    'scans', 'analytics', 'reports', 'settings', 'notifications'
  ]
  loop
    execute format(
      'create trigger trg_%I_updated_at before update on public.%I for each row execute function public.set_updated_at();',
      t, t
    );
  end loop;
end;
$$;

-- ---------------------------------------------------------------------------
-- Representative audit-log trigger (products). Replicate this pattern onto
-- other admin-writable tables (categories, models, media, hotspots, ...) in
-- a later phase rather than repeating it 13 times up front.
-- ---------------------------------------------------------------------------

create function public.log_product_changes()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if (tg_op = 'INSERT') then
    insert into public.logs (actor_id, action, table_name, record_id, new_data)
    values (auth.uid(), 'product.create', 'products', new.id, to_jsonb(new));
    return new;
  elsif (tg_op = 'UPDATE') then
    insert into public.logs (actor_id, action, table_name, record_id, old_data, new_data)
    values (auth.uid(), 'product.update', 'products', new.id, to_jsonb(old), to_jsonb(new));
    return new;
  elsif (tg_op = 'DELETE') then
    insert into public.logs (actor_id, action, table_name, record_id, old_data)
    values (auth.uid(), 'product.delete', 'products', old.id, to_jsonb(old));
    return old;
  end if;
  return null;
end;
$$;

create trigger trg_products_audit
after insert or update or delete on public.products
for each row execute function public.log_product_changes();

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

alter table public.roles enable row level security;
alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.media enable row level security;
alter table public.models enable row level security;
alter table public.hotspots enable row level security;
alter table public.scans enable row level security;
alter table public.analytics enable row level security;
alter table public.reports enable row level security;
alter table public.settings enable row level security;
alter table public.logs enable row level security;
alter table public.notifications enable row level security;

-- `security definer` so checking a caller's role never recurses back into
-- the `profiles` RLS policy that itself calls this function.
create function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles p
    join public.roles r on r.id = p.role_id
    where p.id = auth.uid()
      and p.is_deleted = false
      and p.status = 'active'
      and r.name in ('super_admin', 'administrator')
  );
$$;

-- roles: admins only (public never needs to read this table directly)
create policy roles_admin_all on public.roles
  for all using (public.is_admin()) with check (public.is_admin());

-- profiles: a user can read/update their own row; admins can read/manage all
create policy profiles_select_own on public.profiles
  for select using (auth.uid() = id or public.is_admin());
create policy profiles_update_own on public.profiles
  for update using (auth.uid() = id or public.is_admin());
create policy profiles_admin_write on public.profiles
  for insert with check (public.is_admin());
create policy profiles_admin_delete on public.profiles
  for delete using (public.is_admin());

-- Reusable pair of policies for the "public reads published content, admins
-- do everything" tables: categories, products, media, models, hotspots.
create policy categories_public_read on public.categories
  for select using (status = 'published' and is_deleted = false);
create policy categories_admin_all on public.categories
  for all using (public.is_admin()) with check (public.is_admin());

create policy products_public_read on public.products
  for select using (status = 'published' and is_deleted = false);
create policy products_admin_all on public.products
  for all using (public.is_admin()) with check (public.is_admin());

create policy media_public_read on public.media
  for select using (status = 'published' and is_deleted = false);
create policy media_admin_all on public.media
  for all using (public.is_admin()) with check (public.is_admin());

create policy models_public_read on public.models
  for select using (status = 'published' and is_deleted = false);
create policy models_admin_all on public.models
  for all using (public.is_admin()) with check (public.is_admin());

create policy hotspots_public_read on public.hotspots
  for select using (status = 'published' and is_deleted = false);
create policy hotspots_admin_all on public.hotspots
  for all using (public.is_admin()) with check (public.is_admin());

-- scans / analytics: anonymous inserts allowed (that's the whole point —
-- tracking without login), but only admins can read the collected data.
create policy scans_public_insert on public.scans
  for insert with check (true);
create policy scans_admin_read on public.scans
  for select using (public.is_admin());
create policy scans_admin_manage on public.scans
  for update using (public.is_admin()) with check (public.is_admin());
create policy scans_admin_delete on public.scans
  for delete using (public.is_admin());

create policy analytics_public_insert on public.analytics
  for insert with check (true);
create policy analytics_admin_read on public.analytics
  for select using (public.is_admin());
create policy analytics_admin_manage on public.analytics
  for update using (public.is_admin()) with check (public.is_admin());
create policy analytics_admin_delete on public.analytics
  for delete using (public.is_admin());

-- reports / settings / logs / notifications: admin-only, no public access
create policy reports_admin_all on public.reports
  for all using (public.is_admin()) with check (public.is_admin());
create policy settings_admin_all on public.settings
  for all using (public.is_admin()) with check (public.is_admin());
create policy logs_admin_read on public.logs
  for select using (public.is_admin());
create policy notifications_admin_all on public.notifications
  for all using (public.is_admin()) with check (public.is_admin());
