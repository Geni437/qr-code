# Setup Guide

Local development setup, from a clean checkout to a running app.

## 1. Install Flutter

Install the Flutter SDK (stable channel) per the
[official install guide](https://docs.flutter.dev/get-started/install).
This project was built against Flutter 3.41 / Dart 3.11 — check with
`flutter --version` and `flutter upgrade` if you're on something older.

## 2. Get dependencies

```
flutter pub get
```

Then generate the Freezed/JSON-serializable code (every `*.freezed.dart`
file in the repo is generated, not hand-written):

```
flutter pub run build_runner build --delete-conflicting-outputs
```

Re-run this whenever you add/change a `@freezed` class.

## 3. Create a Supabase project

Create a project at [supabase.com](https://supabase.com) (or run one
locally with the [Supabase CLI](https://supabase.com/docs/guides/cli):
`supabase init && supabase start`).

## 4. Run the schema

Open the SQL Editor in your Supabase project's dashboard and run each file
under [`supabase/migrations/`](../supabase/migrations/) **in order** (or,
once you have the CLI installed and linked: `supabase db push`):

| File | What it does |
|---|---|
| `0001_init_schema.sql` | Every table, the two seeded roles (`super_admin`, `administrator`), and RLS everywhere |
| `0002_storage_setup.sql` | Creates the 7 storage buckets, admin-only policies |
| `0003_public_asset_read.sql` | Public read for a published product's thumbnail/cover images |
| `0004_public_model_read.sql` | Public read for a published model's file + video/audio/document media; adds `hotspots.animation_name` |
| `0005_model_usdz.sql` | Adds `models.usdz_file_path` (optional iOS Quick Look AR variant) |

See [`DATABASE_SCHEMA.md`](DATABASE_SCHEMA.md) for what each table/policy
actually does.

## 5. Create your first admin user

Every row created in `auth.users` automatically gets a `profiles` row via
the `handle_new_user` trigger, defaulting to the `administrator` role —
there are no public sign-ups in this app, only admins authenticate.
Dashboard → Authentication → Users → **Add user** (or
`supabase.auth.admin.createUser(...)` via the CLI/API). To promote someone
to `super_admin`, update their `profiles.role_id` to point at the
`super_admin` row in `roles`.

## 6. Configure the app

Edit the `.env` file at the project root (already present with placeholder
values, and tracked in git so the app runs out of the box without any
setup — see the comment in that file for why that's fine for these
specific values):

```
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-public-key
PUBLIC_BASE_URL=https://your-domain.example.com
```

`SUPABASE_URL`/`SUPABASE_ANON_KEY` are under **Settings → API**. The anon
key is safe to ship client-side — it's constrained entirely by RLS. Never
put a service-role key in `.env` or anywhere in the Flutter app.

`PUBLIC_BASE_URL` is encoded into every generated QR code
(`{PUBLIC_BASE_URL}/view/{productId}`). Update it to your real deployed URL
before printing QR codes for actual products — see
[`DEPLOYMENT.md`](DEPLOYMENT.md) for what "deployed" means per platform.

## 7. Run the app

```
flutter run
```

## 8. Run the tests

```
flutter test
```

See [`DEVELOPER_GUIDE.md`](DEVELOPER_GUIDE.md) for the testing conventions
and how to add a new feature.
