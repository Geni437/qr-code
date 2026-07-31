import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';

/// Single-image picker for a product's thumbnail/cover image: uploads
/// straight to the given (private) bucket under `{productId}/...` and
/// hands the resulting storage path back via [onUploaded]. Renders a
/// preview by generating a short-lived signed URL for [currentPath].
class ProductImagePicker extends ConsumerStatefulWidget {
  const ProductImagePicker({
    super.key,
    required this.label,
    required this.bucket,
    required this.productId,
    required this.currentPath,
    required this.onUploaded,
  });

  final String label;
  final String bucket;
  final String productId;
  final String? currentPath;
  final ValueChanged<String> onUploaded;

  @override
  ConsumerState<ProductImagePicker> createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends ConsumerState<ProductImagePicker> {
  String? _signedUrl;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _resolvePreview();
  }

  @override
  void didUpdateWidget(covariant ProductImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPath != widget.currentPath) {
      _resolvePreview();
    }
  }

  Future<void> _resolvePreview() async {
    final path = widget.currentPath;
    if (path == null) {
      setState(() => _signedUrl = null);
      return;
    }
    try {
      final url = await ref
          .read(supabaseClientProvider)
          .storage
          .from(widget.bucket)
          .createSignedUrl(path, 60 * 10);
      if (mounted) setState(() => _signedUrl = url);
    } catch (_) {
      if (mounted) setState(() => _signedUrl = null);
    }
  }

  Future<void> _pickAndUpload() async {
    final picked = await FilePicker.pickFiles(type: FileType.image, withData: true);
    final file = picked?.files.single;
    if (file?.bytes == null) return;

    setState(() => _uploading = true);
    try {
      final path = '${widget.productId}/${DateTime.now().microsecondsSinceEpoch}_${file!.name}';
      await ref
          .read(supabaseClientProvider)
          .storage
          .from(widget.bucket)
          .uploadBinary(path, file.bytes!);
      widget.onUploaded(path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        InkWell(
          onTap: _uploading ? null : _pickAndUpload,
          child: Container(
            height: 140,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _uploading
                ? const Center(child: CircularProgressIndicator())
                : _signedUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_signedUrl!, fit: BoxFit.cover),
                  )
                : const Center(child: Icon(Icons.add_photo_alternate_outlined)),
          ),
        ),
      ],
    );
  }
}
