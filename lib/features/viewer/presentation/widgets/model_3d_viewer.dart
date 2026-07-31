import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

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
  });

  final String src;
  final Model3DViewerController controller;
  final String hotspotInnerHtml;
  final String hotspotRelatedJs;
  final String hotspotRelatedCss;
  final bool placementEnabled;
  final PlacementCallback? onPlacement;

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
    final relatedJs = placementEnabled ? '$hotspotRelatedJs\n$_placementJs' : hotspotRelatedJs;

    // model_viewer_plus builds its page once in initState and never reacts
    // to prop changes (see Model3DViewerController's doc comment) — so any
    // input that should change what's rendered has to be part of the key,
    // forcing Flutter to tear down and recreate the element.
    final key = ValueKey(
      Object.hash(controller.remountKey, placementEnabled, hotspotInnerHtml, src),
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
