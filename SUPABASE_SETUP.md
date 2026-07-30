# Supabase Setup

This project has no Supabase backend wired up yet — the app runs against
placeholder config until you complete these steps.

## 1. Create a project

Create a project at [supabase.com](https://supabase.com) (or run one
locally with the [Supabase CLI](https://supabase.com/docs/guides/cli) once
installed: `supabase init && supabase start`).

## 2. Run the schema

Open the SQL Editor in your Supabase project's dashboard and run the
contents of [`supabase/migrations/0001_init_schema.sql`](supabase/migrations/0001_init_schema.sql)
(or, once you have the CLI installed and linked: `supabase db push`).

This creates all Phase 1 tables (`profiles`, `roles`, `products`,
`categories`, `models`, `hotspots`, `media`, `analytics`, `scans`,
`reports`, `settings`, `logs`, `notifications`), seeds the two roles
(`super_admin`, `administrator`), and enables Row Level Security everywhere:
public (anonymous) callers get read-only access to published content and can
insert scan/analytics events; everything else requires an authenticated
admin.

## 3. Create your first admin user

Every row created in `auth.users` automatically gets a `profiles` row via
the `handle_new_user` trigger, defaulting to the `administrator` role (there
are no public sign-ups in this app — only admins authenticate). To create
your first user:

- Dashboard → Authentication → Users → **Add user**, or
- `supabase.auth.admin.createUser(...)` via the CLI/API.

To promote someone to `super_admin`, update their `profiles.role_id` to
point at the `super_admin` row in `roles`.

## 4. Create storage buckets

Create these buckets under Storage (names must match
`lib/core/constants/app_constants.dart`): `models`, `images`, `videos`,
`documents`, `audio`, `thumbnails`, `qr_codes`. Storage policies aren't
scripted yet — that lands with the Model/Media upload feature in a later
phase.

## 5. Configure the app

Edit the `.env` file at the project root (already present with placeholder
values, and already tracked so the app runs out of the box) with your
project's URL and anon key, both found under **Settings → API**:

```
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-public-key
```

The anon key is safe to ship client-side — it's constrained entirely by the
RLS policies above. Never put a service-role key in this file or anywhere in
the Flutter app.

## 6. Run the app

```
flutter pub get
flutter run
```
