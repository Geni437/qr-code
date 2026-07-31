import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utilities/slug.dart';
import '../../../../core/utilities/validators.dart';
import '../../domain/entities/category.dart';
import '../controllers/category_providers.dart';

/// Create/edit form for a category. `categoryId` is null when creating;
/// when editing, the category is looked up from the already-loaded list
/// controller rather than issuing a second fetch.
class CategoryFormPage extends ConsumerStatefulWidget {
  const CategoryFormPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  ConsumerState<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends ConsumerState<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = 'published';
  String? _parentId;
  bool _slugManuallyEdited = false;
  bool _saving = false;
  bool _loaded = false;

  bool get _isEditing => widget.categoryId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadExisting(List<Category> categories) {
    if (_loaded || !_isEditing) return;
    Category? match;
    for (final category in categories) {
      if (category.id == widget.categoryId) {
        match = category;
        break;
      }
    }
    if (match != null) {
      _nameController.text = match.name;
      _slugController.text = match.slug;
      _descriptionController.text = match.description ?? '';
      _status = match.status;
      _parentId = match.parentId;
      _slugManuallyEdited = true;
    }
    _loaded = true;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final controller = ref.read(categoryListControllerProvider.notifier);
    final name = _nameController.text.trim();
    final slug = _slugController.text.trim();
    final description = _descriptionController.text.trim();

    final error = _isEditing
        ? await controller.updateCategory(
            id: widget.categoryId!,
            name: name,
            slug: slug,
            description: description.isEmpty ? null : description,
            parentId: _parentId,
          )
        : await controller.create(
            name: name,
            slug: slug,
            description: description.isEmpty ? null : description,
            parentId: _parentId,
            status: _status,
          );

    if (!mounted) return;
    setState(() => _saving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    context.go('/admin/categories');
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListControllerProvider);
    categoriesAsync.whenData(_loadExisting);

    final parentOptions = categoriesAsync.value
            ?.where((c) => c.id != widget.categoryId)
            .toList() ??
        const <Category>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Category' : 'New Category'),
        leading: BackButton(onPressed: () => context.go('/admin/categories')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) => Validators.required(v, fieldName: 'Name'),
                    onChanged: (value) {
                      if (!_slugManuallyEdited) {
                        _slugController.text = slugify(value);
                      }
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
                    initialValue: _parentId,
                    decoration: const InputDecoration(labelText: 'Parent category'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('None')),
                      ...parentOptions.map(
                        (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ),
                    ],
                    onChanged: (value) => setState(() => _parentId = value),
                  ),
                  if (!_isEditing) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(value: 'draft', child: Text('Draft')),
                        DropdownMenuItem(value: 'published', child: Text('Published')),
                      ],
                      onChanged: (value) => setState(() => _status = value!),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isEditing ? 'Save Changes' : 'Create Category'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
