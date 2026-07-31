# Deployment Guide

Steps and commands for shipping each platform. Nothing in this doc has
been run against a real hosting account or store listing — that needs
credentials/access this environment doesn't have. This is the guide for
*you* to follow.

## Web

The public QR→viewer experience and the admin back office both work as a
web build; this is also the one platform every AR mode
(`webxr`/`scene-viewer`/`quick-look`) and the QR scanner's camera fallback
actually reach on desktop, per the platform-limitation notes in
`ARCHITECTURE.md`/the scanner and viewer code.

```
flutter build web --release --base-href /qr-code/ \
  --dart-define=SUPABASE_URL=https://your-project-ref.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-public-key \
  --dart-define=PUBLIC_BASE_URL=https://your-domain.com/qr-code
```

**Use `--dart-define`, not just `.env`, for web production builds.**
Discovered on this project's own deployment: `SupabaseConfig`/`AppConfig`
normally read `.env` at runtime via an HTTP fetch of `assets/.env` — fine
for local dev, but plenty of production web hosts (including this one)
block any request for a dotfile as a default security measure, so the
fetch 403s and the app silently falls back to placeholder config, unable
to reach Supabase at all. `--dart-define` values get compiled straight
into `main.dart.js` at build time instead, so there's no runtime file
fetch to block. This is safe to do with these three values specifically —
the anon key is meant to be public, constrained by RLS, not secrecy — and
`main.dart` skips the `.env` fetch entirely when dart-define config is
present, so there's nothing left to 403 in the browser console either.

**Path-based URLs are required for direct/deep links to work.**
Flutter web defaults to hash-based routing (`/#/admin/login`), which only
works when navigation happens *inside* the running app — a browser typing
or QR-code-driven direct hit to a real path like `/admin/login` (no `#`)
gets ignored entirely, and the app just boots to its default route.
`lib/main.dart` calls `usePathUrlStrategy()` (from `flutter_web_plugins`,
added as a dependency for this) to fix that. This is exactly why the
`.htaccess` SPA-fallback rule below exists: with path-based routing, every
client-side route is a "real" URL as far as Apache is concerned, so the
server needs to be told to serve `index.html` for all of them.

**The `--base-href` flag matters and must match `PUBLIC_BASE_URL`.**
This project's `PUBLIC_BASE_URL` is `https://itclingua.info/qr-code` — a
*subpath*, not the domain root. If you build without `--base-href
/qr-code/` (or serve `build/web/` from anywhere other than exactly that
subpath), the app's own asset references and routes will resolve against
the wrong base and it won't load correctly. If you ever change
`PUBLIC_BASE_URL` to a bare domain root (`https://example.com`), drop the
flag (or use `--base-href /`) to match.

Host `build/web/` on any static host (Netlify, Firebase Hosting, an S3+CDN
setup, a plain nginx/Apache vhost, GitHub Pages, etc.) — it's a static
SPA, no server-side runtime needed. Whatever you choose, configure it to
serve `index.html` for unknown paths (SPA fallback routing), since
`/view/:productId` and `/admin/*` are client-side routes handled by
`go_router`, not real server paths.

### This project's actual target: `itclingua.info/qr-code`

That's Apache/cPanel-style hosting (a domain with a subpath, the classic
shared-hosting shape), so SPA fallback means an `.htaccess` rewrite rule.
`web/.htaccess` in this repo has one already written, scoped to the
`/qr-code/` subpath.

**Important, confirmed by testing**: `flutter build web` does **not** copy
dotfiles (like `.htaccess`) from `web/` into `build/web/` — everything
else in `web/` (favicon, manifest.json) gets copied, `.htaccess` doesn't.
So after every `flutter build web`, copy it in by hand before uploading:

```
flutter build web --release --base-href /qr-code/ \
  --dart-define=SUPABASE_URL=https://tdfwswupbbovnourwfyg.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRkZndzd3VwYmJvdm5vdXJ3ZnlnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU0NTc1NDUsImV4cCI6MjEwMTAzMzU0NX0.tZ0kcyuAW2wYUyQXmh9vO_k8hMusuB2dTFOVhfMm4B8 \
  --dart-define=PUBLIC_BASE_URL=https://itclingua.info/qr-code
cp web/.htaccess build/web/.htaccess
```

(The anon key above is this project's real one — safe to have in this doc
for the same reason it's safe in `.env`: it's public by design, gated by
RLS. Never do this with a service-role key.)

Then upload **the contents of `build/web/`** (not the `build/web` folder
itself — the files need to land directly in the `/qr-code` directory on
the host) via cPanel File Manager or an FTP client. Confirm afterward that
`https://itclingua.info/qr-code/.htaccess` is *not* publicly downloadable
(most Apache configs block serving `.htaccess` itself by default — worth
a quick check, not an assumption) and that opening
`https://itclingua.info/qr-code/view/some-id` directly (not just
navigating there from within the app) actually loads instead of 404ing —
that's the concrete sign the rewrite rule is working.

## Android

1. Generate a release keystore (if you don't have one):
   ```
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Reference it from `android/key.properties` (not committed — add to
   `.gitignore` if it isn't already) and wire it into
   `android/app/build.gradle` per the
   [official Flutter Android deployment guide](https://docs.flutter.dev/deployment/android).
3. Build:
   ```
   flutter build appbundle --release
   ```
4. Upload the resulting `.aab` (under `build/app/outputs/bundle/release/`)
   to the Play Console.

Camera permission (for the QR scanner) is already declared via
`mobile_scanner`'s own manifest merge — no manual manifest edit needed
(confirmed during Phase 3).

## iOS

1. Open `ios/Runner.xcworkspace` in Xcode, set your Team/signing under
   Runner target → Signing & Capabilities.
2. `NSCameraUsageDescription` is already set in `ios/Runner/Info.plist`
   (added in Phase 3 for the scanner, reused by AR/Quick Look).
3. Build an archive:
   ```
   flutter build ipa --release
   ```
4. Upload via Xcode Organizer or `xcrun altool`/Transporter to App Store
   Connect, then submit to TestFlight/App Store from there.

## Windows / macOS / Linux desktop

These builds get the admin back office and (on macOS only) the 3D
viewer/AR — `model_viewer_plus` has no Windows/Linux support, so those two
show the "use the web version" fallback documented in the viewer code.

```
flutter build windows --release   # build/windows/x64/runner/Release/
flutter build macos --release     # build/macos/Build/Products/Release/
flutter build linux --release     # build/linux/x64/release/bundle/
```

- **Windows**: package the `Release/` folder with an installer tool (Inno
  Setup, MSIX via `flutter pub run msix:create`, etc.) if you want a
  proper installer rather than a plain folder.
- **macOS**: `flutter build macos` produces a signable `.app`; codesigning
  and notarization are configured the same way as any macOS app (Xcode
  signing settings in `macos/Runner.xcworkspace`).
- **Linux**: ship the `bundle/` folder, or package as a Flatpak/Snap/AppImage
  if you want a distributable single file.

## CI

`.github/workflows/ci.yml` runs `flutter analyze`, `flutter test`, and
`flutter build web` on every push/PR to `master` — the automated version of
the manual verification this project has run by hand after every phase.
It does **not** deploy anywhere; wiring a deploy step (e.g. pushing
`build/web/` to your host of choice) is a natural next step once you've
picked one, but needs credentials stored as repo secrets that only you can
provision.
