import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utilities/image_compression.dart';
import '../../../notifications/presentation/controllers/notification_providers.dart';
import '../../domain/entities/media_asset.dart';
import '../controllers/media_providers.dart';

const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp'};

IconData _iconForType(String type) => switch (type) {
  'image' => Icons.image_outlined,
  'video' => Icons.videocam_outlined,
  'audio' => Icons.audiotrack_outlined,
  'pdf' => Icons.picture_as_pdf_outlined,
  'document' => Icons.description_outlined,
  _ => Icons.attach_file,
};

/// Media/attachment upload+list section embedded in the product edit form.
/// Page-local state, same reasoning as [ModelUploadSection].
class MediaUploadSection extends ConsumerStatefulWidget {
  const MediaUploadSection({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<MediaUploadSection> createState() => _MediaUploadSectionState();
}

class _MediaUploadSectionState extends ConsumerState<MediaUploadSection> {
  List<MediaAsset>? _media;
  bool _uploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await ref.read(mediaRepositoryProvider).listForProduct(widget.productId);
    if (!mounted) return;
    result.match(
      (failure) => setState(() => _error = failure.message),
      (media) => setState(() {
        _media = media;
        _error = null;
      }),
    );
  }

  Future<void> _pickAndUpload() async {
    final picked = await FilePicker.pickFiles(withData: true);
    final file = picked?.files.single;
    if (file?.bytes == null) return;

    setState(() => _uploading = true);
    final isImage = _imageExtensions.contains((file!.extension ?? '').toLowerCase());
    final bytes = isImage ? compressImageIfNeeded(file.bytes!) : file.bytes!;
    final result = await ref
        .read(mediaRepositoryProvider)
        .upload(
          productId: widget.productId,
          fileName: file.name,
          bytes: bytes,
          extension: file.extension,
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
              title: 'Media upload failed',
              message: failure.message,
            );
      },
      (_) => _load(),
    );
  }

  Future<void> _delete(MediaAsset media) async {
    await ref.read(mediaRepositoryProvider).delete(media);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Media Library', style: Theme.of(context).textTheme.titleMedium),
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
              label: const Text('Upload attachment'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        if (_media == null)
          const Center(child: CircularProgressIndicator())
        else if (_media!.isEmpty)
          const Text('No attachments yet')
        else
          ..._media!.map(
            (media) => Card(
              child: ListTile(
                leading: Icon(_iconForType(media.type)),
                title: Text(media.fileName ?? media.filePath.split('/').last),
                subtitle: Text(
                  '${media.type}'
                  '${media.fileSizeBytes != null ? ' · ${(media.fileSizeBytes! / 1024).toStringAsFixed(1)} KB' : ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete',
                  onPressed: () => _delete(media),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
