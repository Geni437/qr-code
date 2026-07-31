import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../../core/config/supabase_config.dart';
import '../../data/analytics_tracking_js_builder.dart';
import 'model_3d_viewer_controller.dart';

typedef PlacementCallback = void Function(double x, double y, double z);

/// The shared 3D viewer used by both the public product page and the
/// admin model-preview/hotspot-editor page. Hotspot markers/popovers (see
/// `hotspot_html_builder.dart`) are pure HTML/CSS/JS baked in via
/// [hotspotInnerHtml]/[hotspotRelatedJs]/[hotspotRelatedCss] — no Dart/JS
/// bridge needed, so they render identically everywhere. [placementEnabled]
/// (admin hotspot placement) does need the bridge, and so only actually
/// calls [onPlacement] where `model_viewer_plus` provides one (Android/iOS
/// — see [Model3DViewerController.hasJsBridge]); on web the tap is simply
/// never reported, by construction, not by a runtime check here.
class Model3DViewer extends StatelessWidget {
  const Model3DViewer({
    super.key,
    required this.src,
    required this.controller,
    this.hotspotInnerHtml = '',
    this.hotspotRelatedJs = '',
    this.hotspotRelatedCss = '',
    this.placementEnabled = false,
    this.onPlacement,
    this.arEnabled = false,
    this.iosSrc,
    this.trackAnalytics = false,
    this.productId,
  });

  final String src;
  final Model3DViewerController controller;
  final String hotspotInnerHtml;
  final String hotspotRelatedJs;
  final String hotspotRelatedCss;
  final bool placementEnabled;
  final PlacementCallback? onPlacement;

  /// Turns on `model-viewer`'s own built-in AR launch button — it already
  /// detects whether the current device/browser can actually do AR and
  /// hides itself otherwise, so there's no separate Flutter-side "can this
  /// device do AR" check here; that would just duplicate logic the
  /// component already gets right.
  final bool arEnabled;

  /// Optional USDZ variant for iOS Quick Look AR. Without it, iOS simply
  /// isn't offered the AR button — `model-viewer` handles the absence
  /// gracefully, not as an error.
  final String? iosSrc;

  /// Whether to inject the analytics-tracking JS (see
  /// `analytics_tracking_js_builder.dart`). Opt-in and off by default so the
  /// admin model-preview page doesn't pollute real product analytics —
  /// only the public product page sets this. Requires [productId].
  final bool trackAnalytics;
  final String? productId;

  static const _placementJs = '''
(function () {
  var mv = document.querySelector('model-viewer');
  if (!mv) return;
  mv.addEventListener('click', function (event) {
    var rect = mv.getBoundingClientRect();
    var hit = mv.positionAndNormalFromPoint(event.clientX - rect.left, event.clientY - rect.top);
    if (hit && window.AppPlacement) {
      window.AppPlacement.postMessage(JSON.stringify({
        x: hit.position.x, y: hit.position.y, z: hit.position.z
      }));
    }
  });
})();
''';

  @override
  Widget build(BuildContext context) {
    final trackingJs = trackAnalytics && productId != null
        ? buildAnalyticsTrackingJs(
            supabaseUrl: SupabaseConfig.url,
            supabaseAnonKey: SupabaseConfig.anonKey,
            productId: productId!,
            includeArStatusListener: arEnabled,
          )
        : '';
    final relatedJs = [
      hotspotRelatedJs,
      trackingJs,
      if (placementEnabled) _placementJs,
    ].join('\n');

    // model_viewer_plus builds its page once in initState and never reacts
    // to prop changes (see Model3DViewerController's doc comment) — so any
    // input that should change what's rendered has to be part of the key,
    // forcing Flutter to tear down and recreate the element.
    final key = ValueKey(
      Object.hash(controller.remountKey, placementEnabled, hotspotInnerHtml, src, arEnabled, iosSrc),
    );

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ModelViewer(
          key: key,
          src: src,
          alt: 'Product 3D model',
          backgroundColor: Colors.transparent,
          cameraControls: controller.cameraControls,
          autoRotate: controller.autoRotate,
          cameraOrbit: controller.cameraOrbit,
          animationName: controller.animationName,
          autoPlay: controller.isPlaying,
          ar: arEnabled,
          arModes: arEnabled ? const ['webxr', 'scene-viewer', 'quick-look'] : null,
          iosSrc: iosSrc,
          innerModelViewerHtml: hotspotInnerHtml,
          relatedJs: relatedJs,
          relatedCss: hotspotRelatedCss,
          javascriptChannels: placementEnabled && onPlacement != null
              ? {
                  JavascriptChannel(
                    'AppPlacement',
                    onMessageReceived: (message) {
                      final data = jsonDecode(message.message) as Map<String, dynamic>;
                      onPlacement!(
                        (data['x'] as num).toDouble(),
                        (data['y'] as num).toDouble(),
                        (data['z'] as num).toDouble(),
                      );
                    },
                  ),
                }
              : null,
          onWebViewCreated: controller.attachWebViewController,
        );
      },
    );
  }
}
