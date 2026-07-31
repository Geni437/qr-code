import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../analytics/presentation/controllers/scan_providers.dart';
import '../../../hotspots/domain/entities/hotspot.dart';
import '../../../hotspots/presentation/controllers/hotspot_providers.dart';
import '../../../models/presentation/controllers/model_providers.dart';
import '../../../viewer/data/hotspot_html_builder.dart';
import '../../../viewer/data/hotspot_media_resolver.dart';
import '../../../viewer/presentation/widgets/model_3d_viewer.dart';
import '../../../viewer/presentation/widgets/model_3d_viewer_controller.dart';
import '../../../viewer/presentation/widgets/model_3d_viewer_controls.dart';
import '../../data/product_cache.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_providers.dart';

/// Public, no-login product page reached by scanning a QR code (or opening
/// a `/view/:productId` link directly). Records one scan event on
/// successful load — that single moment covers both entry paths without
/// double-counting. Also a stale-while-revalidate cache: a previously
/// viewed product renders instantly from the local cache while a fresh
/// fetch runs underneath, rather than a blank spinner every time.
class PublicProductPage extends ConsumerStatefulWidget {
  const PublicProductPage({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<PublicProductPage> createState() => _PublicProductPageState();
}

class _PublicProductPageState extends ConsumerState<PublicProductPage> {
  Product? _cachedProduct;

  @override
  void initState() {
    super.initState();
    _loadCache();
    _recordScanOnceLoaded();
  }

  Future<void> _loadCache() async {
    final cached = await ProductCache.read(widget.productId);
    if (mounted && cached != null) setState(() => _cachedProduct = cached);
  }

  Future<void> _recordScanOnceLoaded() async {
    try {
      final product = await ref.read(productByIdProvider(widget.productId).future);
      await ProductCache.write(product);
      await ref.read(scanRepositoryProvider).recordScan(productId: widget.productId);
    } catch (_) {
      // Product not found/not published (or the insert itself failed) —
      // nothing meaningful to record either way.
    }
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: productAsync.when(
        loading: () =>
            _cachedProduct != null ? _ProductDetails(product: _cachedProduct!) : const LoadingView(),
        error: (error, _) =>
            _cachedProduct != null ? _ProductDetails(product: _cachedProduct!) : const _NotAvailable(),
        data: (product) => _ProductDetails(product: product),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            const Text('This product isn\'t available.'),
          ],
        ),
      ),
    );
  }
}

class _ProductDetails extends ConsumerWidget {
  const _ProductDetails({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.coverImageUrl != null)
              _SignedImage(bucket: AppConstants.imagesBucket, path: product.coverImageUrl!)
            else if (product.thumbnailUrl != null)
              _SignedImage(bucket: AppConstants.thumbnailsBucket, path: product.thumbnailUrl!),
            const SizedBox(height: 24),
            Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
            if (product.manufacturer != null) ...[
              const SizedBox(height: 4),
              Text(
                product.manufacturer!,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
            if (product.description != null) ...[
              const SizedBox(height: 16),
              Text(product.description!),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in product.tags) Chip(label: Text(tag)),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.modelNumber != null)
                      _SpecRow(label: 'Model number', value: product.modelNumber!),
                    if (product.serialNumber != null)
                      _SpecRow(label: 'Serial number', value: product.serialNumber!),
                    if (product.version != null) _SpecRow(label: 'Version', value: product.version!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _Product3DViewerSection(productId: product.id),
          ],
        ),
      ),
    );
  }
}

/// Loads the product's published model (if any) and renders the shared
/// viewer with its hotspots and AR enabled. `model-viewer` shows its own AR
/// button only when the current device/browser can actually launch AR
/// (Scene Viewer on Android, Quick Look on iOS with a USDZ variant, WebXR
/// on Chrome for Android) — there's no separate Flutter-side button here.
class _Product3DViewerSection extends ConsumerStatefulWidget {
  const _Product3DViewerSection({required this.productId});

  final String productId;

  @override
  ConsumerState<_Product3DViewerSection> createState() => _Product3DViewerSectionState();
}

class _Product3DViewerSectionState extends ConsumerState<_Product3DViewerSection> {
  final _controller = Model3DViewerController();
  bool _loading = true;
  String? _signedUrl;
  String? _iosSrc;
  List<Hotspot> _hotspots = [];
  Map<String, ResolvedMedia> _mediaByHotspot = {};

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
    final modelsResult = await ref
        .read(modelRepositoryProvider)
        .listForProduct(widget.productId);
    final models = modelsResult.match((_) => const [], (list) => list);
    if (models.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final model = models.first;
    final urlResult = await ref.read(modelRepositoryProvider).getSignedUrl(model.filePath);
    final hotspotsResult = await ref.read(hotspotRepositoryProvider).listForModel(model.id);
    final hotspots = hotspotsResult.match((_) => const <Hotspot>[], (list) => list);
    final mediaByHotspot = await resolveHotspotMedia(ref, widget.productId, hotspots);

    String? iosSrc;
    final usdzPath = model.usdzFilePath;
    if (usdzPath != null) {
      final usdzUrlResult = await ref.read(modelRepositoryProvider).getSignedUrl(usdzPath);
      iosSrc = usdzUrlResult.match((_) => null, (url) => url);
    }

    if (!mounted) return;
    final signedUrl = urlResult.match((_) => null, (url) => url);
    setState(() {
      _signedUrl = signedUrl;
      _iosSrc = iosSrc;
      _hotspots = hotspots;
      _mediaByHotspot = mediaByHotspot;
      _loading = false;
    });

    if (signedUrl != null) {
      ref
          .read(analyticsRepositoryProvider)
          .recordEvent(productId: widget.productId, eventType: 'viewer_open');
    }
  }

  Future<void> _handleScreenshot(Uint8List bytes) async {
    await FilePicker.saveFile(
      fileName: 'screenshot.png',
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: const ['png'],
    );
    ref
        .read(analyticsRepositoryProvider)
        .recordEvent(productId: widget.productId, eventType: 'screenshot');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_signedUrl == null) {
      return Tooltip(
        message: 'No 3D model available',
        child: FilledButton.icon(
          onPressed: null,
          icon: const Icon(Icons.view_in_ar_outlined),
          label: const Text('View in 3D / AR'),
        ),
      );
    }

    final html = buildHotspotHtml(_hotspots, mediaByHotspotId: _mediaByHotspot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 320,
          child: Model3DViewer(
            src: _signedUrl!,
            controller: _controller,
            hotspotInnerHtml: html.innerHtml,
            hotspotRelatedJs: html.relatedJs,
            hotspotRelatedCss: html.relatedCss,
            arEnabled: true,
            iosSrc: _iosSrc,
            trackAnalytics: true,
            productId: widget.productId,
          ),
        ),
        const SizedBox(height: 12),
        Model3DViewerControls(controller: _controller, onScreenshot: _handleScreenshot),
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: Theme.of(context).textTheme.labelMedium)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

/// Resolves a private-bucket object to a short-lived signed URL and shows
/// it. Same technique `ProductImagePicker` uses on the admin side — it
/// works for anon callers too now that Phase 3's storage migration grants
/// public read for published products' images.
class _SignedImage extends ConsumerStatefulWidget {
  const _SignedImage({required this.bucket, required this.path});

  final String bucket;
  final String path;

  @override
  ConsumerState<_SignedImage> createState() => _SignedImageState();
}

class _SignedImageState extends ConsumerState<_SignedImage> {
  String? _signedUrl;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    try {
      final url = await ref
          .read(supabaseClientProvider)
          .storage
          .from(widget.bucket)
          .createSignedUrl(widget.path, 60 * 10);
      if (mounted) setState(() => _signedUrl = url);
    } catch (_) {
      // Image unavailable — the rest of the page still renders fine.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_signedUrl == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(_signedUrl!, fit: BoxFit.cover, height: 240, width: double.infinity),
    );
  }
}
