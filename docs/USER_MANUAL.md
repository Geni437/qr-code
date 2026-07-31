# User Manual

For anyone viewing a product — no account, no sign-up, nothing to
install beyond opening a link or using your phone's browser.

## Scanning a QR code

Open the app (or the web version in a browser) and tap **Scan QR Code**.

- **On a phone (Android/iOS) or in a mobile browser**: point your camera
  at the code — it opens the product automatically.
- **On a desktop computer**: live camera scanning isn't available in the
  native Windows/macOS/Linux apps (no current Flutter tooling supports
  it) — open the **web version** in a browser instead, which handles the
  webcam itself, or use the "enter a link or id" option to paste a
  product link directly.

You can also just open a shared product link directly
(`.../view/{productId}`) without scanning anything.

## Viewing a product

The product page shows its name, description, manufacturer, model/serial
number, version, tags, and photos. If the product has a 3D model attached,
you'll see an interactive viewer below the details:

- **Drag** to rotate, **pinch/scroll** to zoom.
- **Reset view** returns to the default angle.
- **Auto-rotate** toggles a slow automatic spin.
- **Play/Pause/Restart** control the model's animation, if it has one.
- **Screenshot** (where available — see below) saves an image of the
  current view.

Revisiting a product you've looked at before shows it instantly from a
local cache while it quietly refreshes in the background, rather than a
blank loading screen every time.

## Hotspots

Small dots on the model are hotspots — tap one to see its title,
description, and any attached photo/video/audio/document or link. Some
hotspots have a **Play animation** button that plays a specific part of
the model's animation.

## Viewing in AR

If your device supports it, an AR button appears on the viewer
automatically:
- **Android**: opens Google's Scene Viewer — point your camera at a flat
  surface to place the product life-size in your space.
- **iPhone/iPad**: opens Apple's Quick Look (only if the admin attached a
  USDZ file for that product — if you don't see an AR button on iOS,
  that's why).
- **Chrome for Android**: can also launch AR directly in the browser via
  WebXR.
- **Desktop browsers and iOS Safari**: AR isn't available (neither
  supports the underlying technology) — you'll still get the regular
  rotate/zoom/pan viewer.

Once AR launches, you're in Google's/Apple's own AR viewer app, with their
own place/move/rotate/scale gestures — the hotspots and other controls
from the regular viewer aren't part of that screen.

## Your privacy

Viewing a product records an anonymous scan (device type, rough
language/locale, timestamp) — no account, no personal information, no
tracking beyond what's needed to show admins basic usage counts like
"how many times was this scanned."
