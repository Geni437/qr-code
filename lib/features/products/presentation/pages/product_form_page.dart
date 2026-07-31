import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/slug.dart';
import '../../../../core/utilities/validators.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../../media/presentation/widgets/media_upload_section.dart';
import '../../../models/presentation/widgets/model_upload_section.dart';
import '../../../qr_codes/presentation/widgets/qr_code_section.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_providers.dart';
import '../widgets/product_image_picker.dart';

/// Create/edit form for a product. `productId` is null when creating; the
/// 3D Models, Media, and QR Code tabs stay locked until the product has an
/// id, since all three need a `product_id` (the QR encodes it directly).
class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({super.key, this.productId});

  final String? productId;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _modelNumberController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _versionController = TextEditingController();
  final _tagsController = TextEditingController();
  String _status = 'draft';
  String? _categoryId;
  String? _thumbnailUrl;
  String? _coverImageUrl;
  bool _slugManuallyEdited = false;
  bool _saving = false;
  bool _prefilled = false;
  String? _productId;

  bool get _isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _productId = widget.productId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _manufacturerController.dispose();
    _modelNumberController.dispose();
    _serialNumberController.dispose();
    _versionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _prefill(Product product) {
    if (_prefilled) return;
    _nameController.text = product.name;
    _slugController.text = product.slug;
    _descriptionController.text = product.description ?? '';
    _manufacturerController.text = product.manufacturer ?? '';
    _modelNumberController.text = product.modelNumber ?? '';
    _serialNumberController.text = product.serialNumber ?? '';
    _versionController.text = product.version ?? '';
    _tagsController.text = product.tags.join(', ');
    _status = product.status;
    _categoryId = product.categoryId;
    _thumbnailUrl = product.thumbnailUrl;
    _coverImageUrl = product.coverImageUrl;
    _slugManuallyEdited = true;
    _prefilled = true;
  }

  List<String> get _tags => _tagsController.text
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final repository = ref.read(productRepositoryProvider);
    final name = _nameController.text.trim();
    final slug = _slugController.text.trim();
    final description = _descriptionController.text.trim();
    final manufacturer = _manufacturerController.text.trim();
    final modelNumber = _modelNumberController.text.trim();
    final serialNumber = _serialNumberController.text.trim();
    final version = _versionController.text.trim();

    final result = _isEditing
        ? await repository.update(
            id: _productId!,
            name: name,
            slug: slug,
            description: description.isEmpty ? null : description,
            categoryId: _categoryId,
            manufacturer: manufacturer.isEmpty ? null : manufacturer,
            modelNumber: modelNumber.isEmpty ? null : modelNumber,
            serialNumber: serialNumber.isEmpty ? null : serialNumber,
            version: version.isEmpty ? null : version,
            tags: _tags,
          )
        : await repository.create(
            name: name,
            slug: slug,
            description: description.isEmpty ? null : description,
            categoryId: _categoryId,
            manufacturer: manufacturer.isEmpty ? null : manufacturer,
            modelNumber: modelNumber.isEmpty ? null : modelNumber,
            serialNumber: serialNumber.isEmpty ? null : serialNumber,
            version: version.isEmpty ? null : version,
            tags: _tags,
            status: _status,
          );

    if (!mounted) return;
    setState(() => _saving = false);

    result.match(
      (failure) =>
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
      (product) {
        ref.invalidate(productListControllerProvider);
        if (!_isEditing) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product created — you can now add models, media, and images'),
            ),
          );
          context.go('/admin/products/${product.id}/edit');
        } else {
          ref.invalidate(productByIdProvider(product.id));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
        }
      },
    );
  }

  Future<void> _updateImage({String? thumbnailPath, String? coverPath}) async {
    final result = await ref
        .read(productRepositoryProvider)
        .updateImages(id: _productId!, thumbnailUrl: thumbnailPath, coverImageUrl: coverPath);
    result.match((failure) {}, (product) {
      setState(() {
        _thumbnailUrl = product.thumbnailUrl;
        _coverImageUrl = product.coverImageUrl;
      });
      ref.invalidate(productListControllerProvider);
    });
  }

  Widget _buildDetailsTab(List<Category> categories) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product name'),
                validator: (v) => Validators.required(v, fieldName: 'Name'),
                onChanged: (value) {
                  if (!_slugManuallyEdited) _slugController.text = slugify(value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _slugController,
                decoration: const InputDecoration(labelText: 'Slug'),
                validator: (v) => Validators.required(v, fieldName: 'Slug'),
                onChanged: (_) => _slugManuallyEdited = true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                initialValue: _categoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  for (final category in categories)
                    DropdownMenuItem(value: category.id, child: Text(category.name)),
                ],
                onChanged: (value) => setState(() => _categoryId = value),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _manufacturerController,
                      decoration: const InputDecoration(labelText: 'Manufacturer'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _versionController,
                      decoration: const InputDecoration(labelText: 'Version'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _modelNumberController,
                      decoration: const InputDecoration(labelText: 'Model number'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _serialNumberController,
                      decoration: const InputDecoration(labelText: 'Serial number'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  helperText: 'Comma-separated',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'draft', child: Text('Draft')),
                  DropdownMenuItem(value: 'published', child: Text('Published')),
                  DropdownMenuItem(value: 'archived', child: Text('Archived')),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 24),
              if (_productId != null) ...[
                Text('Images', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ProductImagePicker(
                      label: 'Thumbnail',
                      bucket: AppConstants.thumbnailsBucket,
                      productId: _productId!,
                      currentPath: _thumbnailUrl,
                      onUploaded: (path) => _updateImage(thumbnailPath: path),
                    ),
                    ProductImagePicker(
                      label: 'Cover image',
                      bucket: AppConstants.imagesBucket,
                      productId: _productId!,
                      currentPath: _coverImageUrl,
                      onUploaded: (path) => _updateImage(coverPath: path),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ] else ...[
                const Text('Save the product to upload a thumbnail or cover image.'),
                const SizedBox(height: 24),
              ],
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Save Changes' : 'Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lockedTab(String message) {
    return Center(
      child: Padding(padding: const EdgeInsets.all(24), child: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListControllerProvider);

    if (_isEditing && !_prefilled) {
      final productAsync = ref.watch(productByIdProvider(widget.productId!));
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Product')),
        body: productAsync.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(message: error.toString()),
          data: (product) {
            _prefill(product);
            return _buildScaffoldBody(categoriesAsync.value ?? const []);
          },
        ),
      );
    }

    return _buildScaffoldBody(categoriesAsync.value ?? const []);
  }

  Widget _buildScaffoldBody(List<Category> categories) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Product' : 'New Product'),
          leading: BackButton(onPressed: () => context.go('/admin/products')),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Details'),
              Tab(text: '3D Models'),
              Tab(text: 'Media'),
              Tab(text: 'QR Code'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDetailsTab(categories),
            _productId != null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: ModelUploadSection(productId: _productId!),
                  )
                : _lockedTab('Save the product details first to upload 3D models.'),
            _productId != null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: MediaUploadSection(productId: _productId!),
                  )
                : _lockedTab('Save the product details first to add media.'),
            _productId != null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: QrCodeSection(
                      productId: _productId!,
                      productName: _nameController.text.trim().isEmpty
                          ? 'product'
                          : _nameController.text.trim(),
                    ),
                  )
                : _lockedTab('Save the product details first to generate a QR code.'),
          ],
        ),
      ),
    );
  }
}
