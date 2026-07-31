# API

There is no custom HTTP API server in this project. "The API" is two
things: the app's internal repository interfaces (Dart contracts,
implemented against Supabase), and one raw REST call made directly from
injected JavaScript. Documenting it as anything more than that would be
inventing an API that doesn't exist.

## Repository interfaces (the real internal API)

Every feature exposes an abstract repository in `domain/repositories/`
that the rest of the app codes against — this is the contract presentation
code actually depends on. The full list:

| Repository | File | Backs |
|---|---|---|
| `AuthRepository` | `lib/features/authentication/domain/repositories/auth_repository.dart` | Admin login/logout/password reset |
| `CategoryRepository` | `lib/features/categories/domain/repositories/category_repository.dart` | Category CRUD |
| `ProductRepository` | `lib/features/products/domain/repositories/product_repository.dart` | Product CRUD, pagination, duplicate |
| `ModelRepository` | `lib/features/models/domain/repositories/model_repository.dart` | 3D model upload/delete/signed URL, USDZ attach |
| `MediaRepository` | `lib/features/media/domain/repositories/media_repository.dart` | Attachment upload/delete |
| `HotspotRepository` | `lib/features/hotspots/domain/repositories/hotspot_repository.dart` | Hotspot CRUD |
| `DashboardRepository` | `lib/features/dashboard/domain/repositories/dashboard_repository.dart` | Dashboard stat aggregation |
| `ScanRepository` / `AnalyticsRepository` / `AnalyticsOverviewRepository` | `lib/features/analytics/domain/repositories/` | Scan/event recording, analytics aggregation |
| `ReportRepository` | `lib/features/reports/domain/repositories/report_repository.dart` | Report-generation audit trail |
| `NotificationRepository` | `lib/features/notifications/domain/repositories/notification_repository.dart` | Notification list/create/mark-read |

Every method returns `Future<Result<T>>` (see [`ARCHITECTURE.md`](ARCHITECTURE.md#the-resultfailure-pattern))
— callers pattern-match on success/failure, never on a thrown exception.

## The one raw REST call: client-side analytics tracking

`lib/features/viewer/data/analytics_tracking_js_builder.dart` builds a JS
snippet (`window.appTrackEvent(eventType, metadata)`) injected into the 3D
viewer. It POSTs directly to:

```
POST {SUPABASE_URL}/rest/v1/analytics
apikey: {SUPABASE_ANON_KEY}
Authorization: Bearer {SUPABASE_ANON_KEY}
Content-Type: application/json

{ "product_id": "...", "event_type": "...", "metadata": {...}, "language": "..." }
```

This exists because hotspot clicks, media downloads, and video plays
happen inside the viewer's injected HTML/JS — which deliberately has no
Dart/JS bridge (see the "3D viewer" note in `ARCHITECTURE.md`), so calling
back into a Dart repository isn't possible from there. Posting straight to
Supabase's auto-generated REST API works instead, and is safe: the anon
key is meant to be public (it's already checked into `.env`), and the
`analytics` table's RLS policy (`analytics_public_insert`, `with check
(true)`) is what actually authorizes the insert — the key alone grants
nothing beyond what RLS allows.

## Everything else is Supabase's own auto-generated REST/Realtime API

Every other database read/write in the app goes through `supabase_flutter`'s
Dart client (`SupabaseClient.from(table)...`), which talks to Supabase's
PostgREST-generated REST API under the hood — there's no separate API
surface to document beyond the table/RLS reference in
[`DATABASE_SCHEMA.md`](DATABASE_SCHEMA.md). The one place Realtime is used
is `unreadNotificationCountProvider`
(`lib/features/notifications/presentation/controllers/notification_providers.dart`),
subscribed via `client.channel(...).onPostgresChanges(...)` for the admin
shell's live unread-notification badge.
