import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'model_3d_viewer_controller.dart';

/// Chrome buttons for a [Model3DViewer]: reset, auto-rotate toggle,
/// play/pause/restart, and (where the platform supports it) screenshot.
/// Shared between the public page and the admin preview so the two don't
/// duplicate this row.
class Model3DViewerControls extends StatelessWidget {
  const Model3DViewerControls({super.key, required this.controller, this.onScreenshot});

  final Model3DViewerController controller;
  final ValueChanged<Uint8List>? onScreenshot;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            IconButton.filledTonal(
              tooltip: 'Reset view',
              icon: const Icon(Icons.center_focus_strong),
              onPressed: controller.resetCamera,
            ),
            IconButton.filledTonal(
              tooltip: controller.autoRotate ? 'Stop auto-rotate' : 'Auto-rotate',
              icon: Icon(controller.autoRotate ? Icons.pause_circle_outline : Icons.threesixty),
              onPressed: controller.toggleAutoRotate,
            ),
            IconButton.filledTonal(
              tooltip: controller.isPlaying ? 'Pause animation' : 'Play animation',
              icon: Icon(controller.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: controller.isPlaying ? controller.pause : () => controller.play(),
            ),
            IconButton.filledTonal(
              tooltip: 'Restart animation',
              icon: const Icon(Icons.replay),
              onPressed: controller.restart,
            ),
            if (controller.hasJsBridge && onScreenshot != null)
              IconButton.filledTonal(
                tooltip: 'Screenshot',
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () async {
                  final bytes = await controller.takeScreenshot();
                  if (bytes != null) onScreenshot!(bytes);
                },
              ),
          ],
        );
      },
    );
  }
}
