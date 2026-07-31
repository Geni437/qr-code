import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Drives a [Model3DViewer].
///
/// Important, verified constraint: `model_viewer_plus` builds its
/// `<model-viewer>` page exactly once in `initState` (there is no
/// `didUpdateWidget` — it never reacts to prop changes after the first
/// build, on either its mobile or web implementation). So every control
/// here — camera orbit, auto-rotate, which animation plays — works by
/// bumping [remountKey] to force a full widget remount with the new
/// attributes baked into a freshly-loaded page, rather than mutating an
/// already-loaded one. That means every action causes a brief visible
/// reload rather than a seamless in-place update; accepted deliberately
/// here as the one code path that behaves identically on every platform
/// `model_viewer_plus` supports, rather than a smoother mobile-only path
/// (via direct JS mutation) plus a separate degraded web path.
///
/// [takeScreenshot] is the one action that's genuinely imperative (it
/// needs a value *back* from JS) and has no remount-based equivalent — it
/// only works where `model_viewer_plus` exposes a real `WebViewController`
/// (Android/iOS). [hasJsBridge] reflects that so callers can hide
/// bridge-only affordances (screenshot, admin hotspot placement) on web
/// rather than show ones that silently do nothing.
class Model3DViewerController extends ChangeNotifier {
  Model3DViewerController({bool autoRotate = true, this.cameraControls = true})
    : _autoRotate = autoRotate;

  final bool cameraControls;

  bool _autoRotate;
  bool get autoRotate => _autoRotate;

  String? _cameraOrbit;
  String? get cameraOrbit => _cameraOrbit;

  String? _animationName;
  String? get animationName => _animationName;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  int _remountKey = 0;
  int get remountKey => _remountKey;

  WebViewController? _webViewController;
  bool get hasJsBridge => _webViewController != null;

  // ignore: use_setters_to_change_properties
  void attachWebViewController(WebViewController controller) {
    _webViewController = controller;
  }

  void toggleAutoRotate() {
    _autoRotate = !_autoRotate;
    _remountKey++;
    notifyListeners();
  }

  /// Plays [animationName] (or the current one if unspecified) from the
  /// start — "resume from where it paused" isn't achievable without the JS
  /// bridge on every platform, so play always restarts.
  void play({String? animationName}) {
    if (animationName != null) _animationName = animationName;
    _isPlaying = true;
    _remountKey++;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _remountKey++;
    notifyListeners();
  }

  void restart() {
    _isPlaying = true;
    _remountKey++;
    notifyListeners();
  }

  void resetCamera() {
    _cameraOrbit = null;
    _remountKey++;
    notifyListeners();
  }

  void setCameraOrbit(String orbit) {
    _cameraOrbit = orbit;
    _remountKey++;
    notifyListeners();
  }

  Future<Uint8List?> takeScreenshot() async {
    final controller = _webViewController;
    if (controller == null) return null;

    final raw = await controller.runJavaScriptReturningResult(
      "document.querySelector('model-viewer').toDataURL('image/png')",
    );
    var dataUrl = raw.toString();
    if (dataUrl.startsWith('"') && dataUrl.endsWith('"')) {
      dataUrl = jsonDecode(dataUrl) as String;
    }
    final base64Part = dataUrl.split(',').last;
    return base64Decode(base64Part);
  }
}
