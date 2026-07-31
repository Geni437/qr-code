import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../hotspots/domain/entities/hotspot.dart';
import '../../../hotspots/presentation/controllers/hotspot_providers.dart';
import '../../../media/domain/entities/media_asset.dart';
import '../../../media/presentation/controllers/media_providers.dart';
import '../../../models/domain/entities/model_asset.dart';
import '../../../models/presentation/controllers/model_providers.dart';
import '../../data/hotspot_html_builder.dart';
import '../../data/hotspot_media_resolver.dart';
import '../widgets/model_3d_viewer.dart';
import '../widgets/model_3d_viewer_controller.dart';
import '../widgets/model_3d_viewer_controls.dart';

/// Admin model preview + visual hotspot editor. Placement (tap the model to
/// place a hotspot) only works where the JS bridge exists — Android/iOS.
/// On web (the likely platform for admins using the back office in a
/// browser), a manual X/Y/Z entry form is offered instead — same fallback
/// pattern as the Phase 3 scanner.
class ModelPreviewPage extends ConsumerStatefulWidget {
  const ModelPreviewPage({super.key, required this.productId, required this.model});

  final String productId;
  final ModelAsset model;

  @override
  ConsumerState<ModelPreviewPage> createState() => _ModelPreviewPageState();
}

class _ModelPreviewPageState extends ConsumerState<ModelPreviewPage> {
  final _controller = Model3DViewerController();
  String? _signedUrl;
  String? _error;
  List<Hotspot> _hotspots = [];
  Map<String, ResolvedMedia> _mediaByHotspot = {};
  bool _placementEnabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final urlResult = await ref.read(modelRepositoryProvider).getSignedUrl(widget.model.filePath);
    final hotspotsResult = await ref
        .read(hotspotRepositoryProvider)
        .listForModel(widget.model.id);

    final hotspots = hotspotsResult.match((_) => const <Hotspot>[], (list) => list);
    final mediaByHotspot = await resolveHotspotMedia(ref, widget.productId, hotspots);

    if (!mounted) return;
    setState(() {
      _signedUrl = urlResult.match((_) => null, (url) => url);
      _error = urlResult.match((failure) => failure.message, (_) => null);
      _hotspots = hotspots;
      _mediaByHotspot = mediaByHotspot;
      _loading = false;
    });
  }

  Future<void> _onPlacement(double x, double y, double z) async {
    setState(() => _placementEnabled = false);
    await _showHotspotForm(x: x, y: y, z: z);
  }

  Future<void> _showHotspotForm({required double x, required double y, required double z}) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final linkController = TextEditingController();
    final animationController = TextEditingController();
    String? selectedMediaId;

    final mediaResult = await ref.read(mediaRepositoryProvider).listForProduct(widget.productId);
    final mediaOptions = mediaResult.match((_) => const <MediaAsset>[], (list) => list);

    if (!mounted) return;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New Hotspot'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Position: ${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}, ${z.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setDialogState) => DropdownButtonFormField<String?>(
                  initialValue: selectedMediaId,
                  decoration: const InputDecoration(labelText: 'Attached media (optional)'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...mediaOptions.map(
                      (m) => DropdownMenuItem(
                        value: m.id,
                        child: Text(m.fileName ?? m.filePath.split('/').last),
                      ),
                    ),
                  ],
                  onChanged: (value) => setDialogState(() => selectedMediaId = value),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(labelText: 'Link URL (optional)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: animationController,
                decoration: const InputDecoration(
                  labelText: 'Animation name to trigger (optional)',
                  helperText: 'Must match a name in the .glb/.gltf file',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved != true || titleController.text.trim().isEmpty) return;

    final result = await ref
        .read(hotspotRepositoryProvider)
        .create(
          productId: widget.productId,
          modelId: widget.model.id,
          mediaId: selectedMediaId,
          title: titleController.text.trim(),
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
          positionX: x,
          positionY: y,
          positionZ: z,
          linkUrl: linkController.text.trim().isEmpty ? null : linkController.text.trim(),
          animationName: animationController.text.trim().isEmpty
              ? null
              : animationController.text.trim(),
        );

    if (!mounted) return;
    result.match(
      (failure) =>
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) => _load(),
    );
  }

  Future<void> _deleteHotspot(Hotspot hotspot) async {
    await ref.read(hotspotRepositoryProvider).delete(hotspot.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Model Preview')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 360,
                    child: Builder(
                      builder: (context) {
                        final html = buildHotspotHtml(
                          _hotspots,
                          mediaByHotspotId: _mediaByHotspot,
                        );
                        return Model3DViewer(
                          src: _signedUrl!,
                          controller: _controller,
                          hotspotInnerHtml: html.innerHtml,
                          hotspotRelatedJs: html.relatedJs,
                          hotspotRelatedCss: html.relatedCss,
                          placementEnabled: _placementEnabled,
                          onPlacement: _onPlacement,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Model3DViewerControls(controller: _controller),
                  const SizedBox(height: 12),
                  if (_controller.hasJsBridge)
                    FilledButton.icon(
                      onPressed: () => setState(() => _placementEnabled = !_placementEnabled),
                      icon: Icon(_placementEnabled ? Icons.close : Icons.add_location_alt),
                      label: Text(_placementEnabled ? 'Cancel placement' : 'Tap model to add hotspot'),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => _showHotspotForm(x: 0, y: 0, z: 0),
                      icon: const Icon(Icons.add_location_alt),
                      label: const Text('Add hotspot (enter position manually)'),
                    ),
                  if (!_controller.hasJsBridge)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Tap-to-place isn\'t available on this platform (no WebView JS '
                        'bridge here) — enter the X/Y/Z position directly. Position values '
                        'are in the model\'s own coordinate units; check placement above '
                        'and delete/redo if it\'s off.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text('Hotspots', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _hotspots.isEmpty
                        ? const Text('No hotspots yet')
                        : ListView(
                            children: _hotspots
                                .map(
                                  (hotspot) => Card(
                                    child: ListTile(
                                      leading: const Icon(Icons.location_on_outlined),
                                      title: Text(hotspot.title),
                                      subtitle: Text(
                                        '${hotspot.positionX.toStringAsFixed(2)}, '
                                        '${hotspot.positionY.toStringAsFixed(2)}, '
                                        '${hotspot.positionZ.toStringAsFixed(2)}',
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _deleteHotspot(hotspot),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
