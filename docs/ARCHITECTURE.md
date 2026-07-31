# Architecture

## Overview

QR AR Platform is a Flutter + Supabase app with two audiences sharing one
codebase: anonymous public users (scan a QR code, view a product in 3D/AR,
no login) and authenticated admins (a full back office for products,
categories, 3D models, media, QR codes, analytics, reports, notifications).

There is no separate custom backend server. Supabase provides Postgres
(with Row Level Security doing all authorization), Auth, Storage, and
Realtime; the Flutter app talks to it directly via `supabase_flutter`. The
one exception is analytics events fired from inside the 3D viewer's
injected JS, which POST straight to Supabase's REST endpoint with the
public anon key — see [`API.md`](API.md).

## Clean Architecture, per feature

Every feature under `lib/features/<name>/` follows the same three-layer
split:

```
lib/features/<name>/
  domain/
    entities/          # Freezed data classes — plain Dart, no Supabase types
    repositories/       # Abstract classes — the contract, no implementation
  data/
    repositories/        # Concrete implementations, talk to SupabaseClient
  presentation/
    controllers/          # Riverpod providers wiring data -> UI
    pages/                  # Full-screen widgets, routed
    widgets/                 # Reusable pieces used by more than one page
```

- **Domain** never imports `supabase_flutter`. `ProductRepository`
  (`lib/features/products/domain/repositories/product_repository.dart`) is
  a pure abstract class; nothing about Postgres or REST leaks into it.
- **Data** implements the domain contract against a real `SupabaseClient`,
  and is where all error handling lives: every method wraps its Supabase
  calls in try/catch and returns a `Result<T>` (see below) instead of
  letting exceptions propagate.
- **Presentation** depends only on the domain repository interface via a
  Riverpod `Provider`, e.g. `productRepositoryProvider` in
  `lib/features/products/presentation/controllers/product_providers.dart`
  binds the interface to `ProductRepositoryImpl`. Widgets never construct a
  `SupabaseClient` or a `*RepositoryImpl` directly.

This means swapping the backend (or writing a fake for a test) only ever
touches the `data/` folder — nothing in `presentation/` needs to change.

## The `Result`/`Failure` pattern

`lib/core/utilities/result.dart` defines `typedef Result<T> = Either<Failure, T>`
(from the `fpdart` package). `lib/core/utilities/failure.dart` defines a
small sealed hierarchy (`AuthFailure`, `NetworkFailure`, `ServerFailure`,
`ValidationFailure`, `UnknownFailure`). Every repository method returns a
`Future<Result<T>>` — `Right(value)` on success, `Left(failure)` on any
caught exception. Callers use `.match((failure) => ..., (value) => ...)`
rather than try/catch, so error handling is a compile-time-checked branch,
not something that can be silently forgotten.

## State management: Riverpod, no code generation

The project deliberately does **not** use `riverpod_generator` — an early
attempt hit a version conflict between `riverpod_generator` and the `meta`
package pinned by this Flutter SDK. Every provider in the app is a plain,
hand-written `Provider`/`FutureProvider`/`StreamProvider`/`AsyncNotifierProvider`.
List-editing screens (`ProductListController`, `CategoryListController`)
use `AsyncNotifier` for create/update/delete methods; read-only aggregate
data (`DashboardStats`, `AnalyticsOverview`) uses a plain `FutureProvider`
since there's no mutation to coordinate.

## Routing

`lib/core/routing/app_router.dart` defines one `GoRouter` for the whole
app. Public routes (`/`, `/scan`, `/view/:productId`) sit outside any auth
guard. Everything under `/admin/*` is wrapped in a `ShellRoute` rendering
`AdminShell` (`lib/core/widgets/admin_shell.dart`) — the persistent
nav rail/drawer plus the notification bell — except `/admin/login` and
`/admin/forgot-password`, which render standalone. The router's `redirect`
callback checks `AuthRepository.currentUser` (via
`GoRouterRefreshStream` reacting to `authStateChanges()`) and bounces
unauthenticated visitors to `/admin/*` back to `/admin/login`, and
authenticated visitors away from the login/forgot-password screens.

## Cross-feature composition

Features reference each other directly where that's the natural
relationship, rather than going through an extra indirection layer:
- `product_form_page.dart` embeds `ModelUploadSection`, `MediaUploadSection`,
  and `QrCodeSection` as tabs — a product's models/media/QR code are edited
  in the same form, not separate pages.
- The `viewer` feature (`lib/features/viewer/`) depends on `hotspots` and
  `media` to resolve a hotspot's attached image/video/audio/PDF to a signed
  URL before baking it into the 3D viewer's injected HTML.
- The public `PublicProductPage` and the admin `ModelPreviewPage` both
  build on the same `Model3DViewer` widget
  (`lib/features/viewer/presentation/widgets/model_3d_viewer.dart`) — one
  viewer implementation, two different callers with different feature
  flags (`placementEnabled` for admin hotspot placement, `trackAnalytics`
  for the public page).

## The 3D viewer's biggest architectural constraint

`model_viewer_plus` (wrapping Google's `<model-viewer>` web component)
builds its page exactly once in `initState` and never reacts to prop
changes afterward — confirmed by reading its source during Phase 4, not
assumed. Every viewer control (`Model3DViewerController` in
`lib/features/viewer/presentation/widgets/model_3d_viewer_controller.dart`)
therefore works by forcing a full widget remount (a new `ValueKey`) with
the new attributes baked into a freshly loaded page, rather than mutating
an already-loaded one. This was a deliberate, documented trade-off:
one predictable code path across every platform the viewer supports,
instead of a smoother mobile-only path (via the WebView JS bridge) plus a
degraded fallback on web.

## Known scaling limits, stated rather than hidden

- `AnalyticsOverviewRepositoryImpl` (`lib/features/analytics/data/repositories/analytics_overview_repository_impl.dart`)
  aggregates a 30-day window of raw rows **client-side**. That's a real,
  correct implementation at this app's current scale; at high scan volume
  it should move to a Postgres view/RPC doing the aggregation server-side.
- Country/city analytics need IP geolocation (a Supabase Edge Function);
  browser detection needs user-agent parsing. Neither is implemented —
  documented as a deliberate cut in the Phase 3 and Phase 6 plans, not an
  oversight.
