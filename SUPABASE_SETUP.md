# Supabase Setup

This project has no Supabase backend wired up yet — the app runs against
placeholder config until you complete these steps.

## 1. Create a project

Create a project at [supabase.com](https://supabase.com) (or run one
locally with the [Supabase CLI](https://supabase.com/docs/guides/cli) once
installed: `supabase init && supabase start`).

## 2. Run the schema

Open the SQL Editor in your Supabase project's dashboard and run each file
under [`supabase/migrations/`](supabase/migrations/) in order (or, once you
have the CLI installed and linked: `supabase db push`):

- `0001_init_schema.sql` — all tables (`profiles`, `roles`, `products`,
  `categories`, `models`, `hotspots`, `media`, `analytics`, `scans`,
  `reports`, `settings`, `logs`, `notifications`), the two seeded roles
  (`super_admin`, `administrator`), and RLS everywhere: public (anonymous)
  callers get read-only access to published content and can insert
  scan/analytics events; everything else requires an authenticated admin
- `0002_storage_setup.sql` — creates the 7 storage buckets and admin-only
  policies on them
- `0003_public_asset_read.sql` — adds public read access to a published
  product's thumbnail/cover images, for the public product page

## 3. Create your first admin user

Every row created in `auth.users` automatically gets a `profiles` row via
the `handle_new_user` trigger, defaulting to the `administrator` role (there
are no public sign-ups in this app — only admins authenticate). To create
your first user:

- Dashboard → Authentication → Users → **Add user**, or
- `supabase.auth.admin.createUser(...)` via the CLI/API.

To promote someone to `super_admin`, update their `profiles.role_id` to
point at the `super_admin` row in `roles`.

## 4. Storage buckets

Already created by `0002_storage_setup.sql` above — no manual step needed.

## 5. Configure the app

Edit the `.env` file at the project root (already present with placeholder
values, and already tracked so the app runs out of the box):

```
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-public-key
PUBLIC_BASE_URL=https://your-domain.example.com
```

`SUPABASE_URL`/`SUPABASE_ANON_KEY` are under **Settings → API**. The anon
key is safe to ship client-side — it's constrained entirely by the RLS
policies above. Never put a service-role key in this file or anywhere in the
Flutter app.

`PUBLIC_BASE_URL` is encoded into every generated QR code
(`{PUBLIC_BASE_URL}/view/{productId}`). It stays a placeholder until you set
it — update it to your real deployed URL before printing QR codes for
actual products, otherwise scanned codes won't resolve anywhere.

## 6. Run the app

```
flutter pub get
flutter run
```
