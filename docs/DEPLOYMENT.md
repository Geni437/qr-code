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
flutter build web --release --base-href /qr-code/
```

**The `--base-href` flag matters and must match `PUBLIC_BASE_URL`.**
`.env`'s `PUBLIC_BASE_URL` is currently `https://itclingua.info/qr-code` —
a *subpath*, not the domain root. If you build without `--base-href
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
