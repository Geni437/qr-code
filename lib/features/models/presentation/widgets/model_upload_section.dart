import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notifications/presentation/controllers/notification_providers.dart';
import '../../../viewer/presentation/pages/model_preview_page.dart';
import '../../domain/entities/model_asset.dart';
import '../controllers/model_providers.dart';

/// 3D model upload/list section embedded in the product edit form. Kept as
/// page-local state (not a shared Riverpod controller) since nothing else
/// in the app needs a given product's model list.
class ModelUploadSection extends ConsumerStatefulWidget {
  const ModelUploadSection({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ModelUploadSection> createState() => _ModelUploadSectionState();
}

class _ModelUploadSectionState extends ConsumerState<ModelUploadSection> {
  List<ModelAsset>? _models;
  bool _uploading = false;
  String? _error;
  final Set<String> _uploadingUsdzIds = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await ref.read(modelRepositoryProvider).listForProduct(widget.productId);
    if (!mounted) return;
    result.match(
      (failure) => setState(() => _error = failure.message),
      (models) => setState(() {
        _models = models;
        _error = null;
      }),
    );
  }

  Future<void> _pickAndUpload() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['glb', 'gltf'],
      withData: true,
    );
    final file = picked?.files.single;
    if (file?.bytes == null) return;

    setState(() => _uploading = true);
    final result = await ref
        .read(modelRepositoryProvider)
        .upload(
          productId: widget.productId,
          fileName: file!.name,
          bytes: file.bytes!,
          format: (file.extension ?? 'glb').toLowerCase(),
        );
    if (!mounted) return;
    setState(() => _uploading = false);
    result.match(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
        ref
            .read(notificationRepositoryProvider)
            .create(
              type: 'failed_upload',
              title: '3D model upload failed',
              message: failure.message,
            );
      },
      (model) {
        _load();
        ref
            .read(notificationRepositoryProvider)
            .create(
              type: 'new_model',
              title: 'New 3D model uploaded',
              message: '${model.format.toUpperCase()} model added to a product.',
            );
      },
    );
  }

  Future<void> _pickAndUploadUsdz(ModelAsset model) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['usdz'],
      withData: true,
    );
    final file = picked?.files.single;
    if (file?.bytes == null) return;

    setState(() => _uploadingUsdzIds.add(model.id));
    final result = await ref
        .read(modelRepositoryProvider)
        .attachUsdz(model: model, fileName: file!.name, bytes: file.bytes!);
    if (!mounted) return;
    setState(() => _uploadingUsdzIds.remove(model.id));
    result.match(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) => _load(),
    );
  }

  Future<void> _delete(ModelAsset model) async {
    await ref.read(modelRepositoryProvider).delete(model);
    _load();
  }

  Future<void> _copySignedLink(ModelAsset model) async {
    final result = await ref.read(modelRepositoryProvider).getSignedUrl(model.filePath);
    if (!mounted) return;
    result.match(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (url) {
        Clipboard.setData(ClipboardData(text: url));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Signed link copied (valid 10 minutes)')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('3D Models', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            FilledButton.icon(
              onPressed: _uploading ? null : _pickAndUpload,
              icon: _uploading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: const Text('Upload model (.glb/.gltf)'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        if (_models == null)
          const Center(child: CircularProgressIndicator())
        else if (_models!.isEmpty)
          const Text('No models uploaded yet')
        else
          ..._models!.map(
            (model) => Card(
              child: ListTile(
                leading: const Icon(Icons.view_in_ar_outlined),
                title: Text(model.filePath.split('/').last),
                subtitle: Text(
                  '${model.format.toUpperCase()} · v${model.version}'
                  '${model.fileSizeBytes != null ? ' · ${(model.fileSizeBytes! / 1024).toStringAsFixed(1)} KB' : ''}'
                  '${model.usdzFilePath != null ? ' · USDZ attached (iOS AR)' : ''}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: _uploadingUsdzIds.contains(model.id)
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              model.usdzFilePath != null
                                  ? Icons.phone_iphone
                                  : Icons.add_to_home_screen_outlined,
                            ),
                      tooltip: model.usdzFilePath != null
                          ? 'Replace USDZ (iOS AR)'
                          : 'Add USDZ (iOS AR)',
                      onPressed: _uploadingUsdzIds.contains(model.id)
                          ? null
                          : () => _pickAndUploadUsdz(model),
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined),
                      tooltip: 'Preview & hotspots',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ModelPreviewPage(productId: widget.productId, model: model),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: 'Copy signed link',
                      onPressed: () => _copySignedLink(model),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete',
                      onPressed: () => _delete(model),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
