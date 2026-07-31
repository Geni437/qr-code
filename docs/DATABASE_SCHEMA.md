# Database Schema

Source of truth: `supabase/migrations/*.sql`, applied in order. This is the
human-readable index — if this doc and a migration ever disagree, the
migration is right.

## Conventions

Every table has `id uuid primary key default gen_random_uuid()`,
`created_at`/`updated_at` (auto-touched by a shared `set_updated_at()`
trigger), `created_by`/`updated_by` (nullable `auth.users` references),
`status`, and `is_deleted` (soft delete) — **except `logs`**, an
append-only audit trail with none of those, since audit rows must never be
mutated.

Row Level Security is enabled on every table. The `public.is_admin()`
function (`security definer`, checks the caller's `profiles`/`roles` row)
gates every admin write; public (anonymous) access is read-only and scoped
to `status = 'published' and is_deleted = false`.

## Tables

| Table | Purpose | Notable columns |
|---|---|---|
| `roles` | Seed data: `super_admin`, `administrator` | `name`, `description` |
| `profiles` | 1:1 with `auth.users`, auto-created by the `handle_new_user` trigger on signup (defaults to `administrator` — there are no public sign-ups) | `role_id` |
| `categories` | Admin-authored product categories, optional hierarchy | `slug`, `parent_id` |
| `products` | The core catalog entity | `slug`, `category_id`, `manufacturer`, `model_number`, `serial_number`, `version`, `thumbnail_url`/`cover_image_url` (storage paths, not resolvable URLs — see below), `tags text[]` |
| `media` | Arbitrary attachments per product (images/video/audio/PDF/docs) | `type`, `file_path`, `file_name`, `file_size_bytes` |
| `models` | 3D model files (`.glb`/`.gltf`) per product | `file_path`, `format`, `version`, `file_size_bytes`, `usdz_file_path` (optional, added in `0005`, for iOS Quick Look AR) |
| `hotspots` | Interactive markers placed on a specific model | `model_id`, `media_id` (optional attached media), `position_x/y/z`, `link_url`, `animation_name` (added in `0004`, triggers a named animation on click) |
| `scans` | One row per QR scan (anonymous) | `product_id`, `device_type`, `os`, `language`, `scanned_at` |
| `analytics` | Viewer interaction events (anonymous) | `event_type` (`viewer_open`/`ar_launch`/`download`/`video_play`/`hotspot_click`/`screenshot`), `metadata jsonb`, `occurred_at` |
| `reports` | Audit trail of generated reports — the file itself isn't stored, just a record that one was generated | `type`, `format`, `parameters jsonb` |
| `settings` | Key/value system config (currently just used as a lightweight health-check target) | `key`, `value jsonb` |
| `logs` | Append-only admin action audit trail | `actor_id`, `action`, `table_name`, `record_id`, `old_data`/`new_data jsonb` |
| `notifications` | Admin-facing notifications | `recipient_id` (null = broadcast), `type` (`failed_upload`/`storage_limit`/`new_model`/`system_error`/`security_alert`), `is_read` |

`thumbnail_url`/`cover_image_url`/`file_path`/`usdz_file_path` all store a
**storage path** (`{productId}/{filename}`), not a public URL — every
bucket is private; the app always resolves a short-lived signed URL
on-demand (`SupabaseClient.storage.from(bucket).createSignedUrl(...)`).

## Row Level Security summary

| Table | Public (anon) | Admin |
|---|---|---|
| `products`/`categories`/`media`/`models`/`hotspots` | `select` where `status='published' and is_deleted=false` | full CRUD |
| `scans`/`analytics` | `insert` only (`with check (true)`) | full CRUD |
| `profiles` | a user can read/update their own row | full CRUD |
| `roles`/`reports`/`settings`/`notifications` | no access | full CRUD |
| `logs` | no access | read-only (append-only by design) |

## Storage buckets (`0002`-`0004`)

`models`, `images`, `videos`, `documents`, `audio`, `thumbnails`,
`qr_codes` — all private (`public = false`). Admin-only read/write on all
of them, **plus** an additional public-read policy on `models`/`images`/
`thumbnails`/`videos`/`audio`/`documents` scoped to the owning row's
`status = 'published' and is_deleted = false` (checked against the actual
`models`/`media` table row for `models`/`videos`/`audio`/`documents`, or
just the parent product's path prefix for `images`/`thumbnails`, which
have no status of their own — see `0003`'s and `0004`'s comments for why
those two migrations took different approaches). `qr_codes` has no public
policy: QR codes are generated on-demand client-side, never persisted to
storage, so nothing is ever written there today.

## Representative audit trigger

`0001` wires one audit-logging trigger, on `products`, as the pattern to
replicate onto other admin-writable tables if/when needed — not
replicated onto all of them up front, to avoid 13 near-identical trigger
definitions with no consumer yet.
