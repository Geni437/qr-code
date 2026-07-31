# QR AR Platform

Enterprise QR-based AR platform built with Flutter and Supabase. Anyone
can scan a product's QR code and instantly view it in an interactive 3D
viewer (with AR on supported devices) — no account, no download beyond the
app itself. Administrators get a full back office: products, categories,
3D models, media, QR code generation, analytics, reports, and
notifications.

## Status

Built in 7 phases, all committed:

1. Project scaffold, Clean Architecture, Supabase schema, admin auth
2. Admin dashboard, product/category management, model & media upload
3. QR code generator, QR scanner, public product pages
4. Interactive 3D viewer, animations, hotspots, info panels
5. Augmented reality (ARCore/ARKit/WebXR)
6. Analytics, reports, notifications, performance optimization
7. Testing, documentation, production deployment prep

## Documentation

| Doc | For |
|---|---|
| [`docs/SETUP.md`](docs/SETUP.md) | Getting a local dev environment running |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | How the codebase is organized and why |
| [`docs/DATABASE_SCHEMA.md`](docs/DATABASE_SCHEMA.md) | Every table, column, and RLS policy |
| [`docs/API.md`](docs/API.md) | The app's internal repository contracts + the one raw REST call |
| [`docs/ADMIN_MANUAL.md`](docs/ADMIN_MANUAL.md) | Using the back office |
| [`docs/USER_MANUAL.md`](docs/USER_MANUAL.md) | The public scan → view → AR flow |
| [`docs/DEVELOPER_GUIDE.md`](docs/DEVELOPER_GUIDE.md) | Adding a feature, testing conventions |
| [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) | Building/releasing each platform |

## Quick start

```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

You'll need a Supabase project wired up first — see
[`docs/SETUP.md`](docs/SETUP.md) for the full walkthrough (schema
migrations, first admin user, `.env` config).

## Tech stack

Flutter · Riverpod (hand-written providers, no codegen) · GoRouter ·
Freezed · Supabase (Postgres, Auth, Storage, Realtime) · `model_viewer_plus`
(3D/AR) · `mobile_scanner` (QR) · `fl_chart` · `pdf`/`printing`/`excel`
(reports).

## Known, deliberate limitations

Documented in-place rather than silently shipped:
- No live camera QR scanning or 3D/AR viewing on native Windows/Linux
  desktop builds — no current Flutter package supports it; the web build
  is the practical desktop path for both.
- iOS AR (Quick Look) needs an admin-uploaded USDZ file per model; without
  one, iOS simply doesn't offer the AR button.
- Analytics aggregation is client-side over a 30-day window — correct at
  this app's scale, not how you'd do it at high traffic (see
  `docs/ARCHITECTURE.md`).
- No country/city/browser analytics (would need IP geolocation and
  user-agent parsing, respectively) and no "average viewing time".

## License

Not yet decided — do not assume this is open source.
