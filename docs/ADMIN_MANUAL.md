# Administrator Manual

## Signing in

Go to `/admin/login` (or open the app — an unauthenticated visit to any
`/admin/*` page redirects there automatically). There's no admin sign-up
screen: your account is created for you (see [`SETUP.md`](SETUP.md#5-create-your-first-admin-user))
and defaults to the `administrator` role. Forgot your password? Use the
"Forgot password?" link on the login screen.

## Dashboard

Landing page after login. Shows total/active products, categories,
models, QR codes (a proxy — one per published product), total scans,
storage used, a 7-day scan chart, recent uploads, and a system-health
badge (green "Operational" / red "Degraded", based on a lightweight
database check).

## Products

**Products** in the nav rail. Search by name, filter by category/status,
paginate through results (20 per page). Row actions: **Edit**,
**Duplicate** (copies everything except id/timestamps, resets to draft),
**Publish/Unpublish**, **Archive**, **Delete** (soft delete — hidden from
lists, not gone from the database).

Opening a product (or **New Product**) shows a tabbed form:
- **Details** — name (auto-generates a slug as you type, editable), category,
  manufacturer, model/serial number, version, tags (comma-separated),
  status, and thumbnail/cover image upload. Images are compressed
  client-side (downscaled to 1600px, re-encoded JPEG) before upload.
- **3D Models** and **Media** — locked until the product is saved once (they
  need the product's id to attach files to). Upload a `.glb`/`.gltf` model;
  optionally attach a `.usdz` variant per model for iOS Quick Look AR. Each
  model has a **Preview & hotspots** button (see below). Media accepts any
  file type and is categorized automatically (image/video/audio/PDF/document).
- **QR Code** — also locked until saved. Shows the live QR preview
  (encoding `{PUBLIC_BASE_URL}/view/{productId}`), and Download PNG/SVG,
  Copy Link, Share, and Print actions. There's no "Regenerate" button — the
  code is generated fresh from the product id every time, so there's
  nothing stale to refresh.

## Categories

**Categories** in the nav rail — simpler than products, no pagination
(admin-authored, expected to be a short list). Create/edit/publish/
archive/delete, optional parent category for a hierarchy.

## 3D model preview & hotspots

From a product's **3D Models** tab, tap the eye icon on any model to open
the preview/hotspot editor: the model rendered live, plus existing
hotspots as tappable markers.

- **On Android/iOS**: tap **"Tap model to add hotspot"**, then tap
  anywhere on the model — a form opens with the exact 3D position
  pre-filled. Fill in a title, optional description/attached media/link/
  animation name, and save.
- **Everywhere else (including the web admin panel)**: there's no
  tap-to-place — use **"Add hotspot (enter position manually)"** and type
  X/Y/Z coordinates directly. This is a real platform limitation (no
  Flutter package exposes the needed WebView JS bridge on
  desktop/web), not a missing feature. Position values are in the
  model's own coordinate units; use the preview to check placement and
  delete/redo if it's off (there's no "move" — only add/delete).

## Analytics

**Analytics** in the nav rail: a 30-day scan chart, most-viewed products
(top 10), event-type counts (viewer opens, AR launches, downloads, video
plays, hotspot clicks, screenshots), and a device-type breakdown. Hotspot
clicks/downloads/video plays/AR launches are recorded directly from the
viewer (in the visitor's browser/app), not through anything in the admin
panel — so they show up here without any admin action needed.

## Reports

**Reports** in the nav rail: pick a report type (Products, Categories,
Models, Scans, Analytics — with an optional event-type filter, e.g. to get
just downloads or just AR launches — or Storage Usage), pick a format
(CSV/Excel/PDF), and **Generate & Download**. Each generation is logged
(for your own records) but the file itself isn't kept anywhere — download
it when you generate it.

## Notifications

The bell icon (top of the nav rail / app bar) shows a live unread count.
Click it to see the full list: new model uploads, failed uploads, storage
warnings, and system-health failures all show up here automatically, no
setup required. Mark individual notifications read, or **mark all as
read** from the notifications page's app bar.
