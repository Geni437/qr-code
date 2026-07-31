import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/responsive_table.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_providers.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final _searchController = TextEditingController();
  String? _categoryFilter;
  String? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref
        .read(productListControllerProvider.notifier)
        .applyFilters(
          search: _searchController.text,
          categoryId: _categoryFilter,
          status: _statusFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListControllerProvider);
    final categoriesAsync = ref.watch(categoryListControllerProvider);
    final controller = ref.read(productListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New product',
            onPressed: () => context.go('/admin/products/new'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _applyFilters(),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String?>(
                    initialValue: _categoryFilter,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All categories')),
                      ...?categoriesAsync.value?.map(
                        (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _categoryFilter = value);
                      _applyFilters();
                    },
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<String?>(
                    initialValue: _statusFilter,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All statuses')),
                      DropdownMenuItem(value: 'draft', child: Text('Draft')),
                      DropdownMenuItem(value: 'published', child: Text('Published')),
                      DropdownMenuItem(value: 'archived', child: Text('Archived')),
                    ],
                    onChanged: (value) {
                      setState(() => _statusFilter = value);
                      _applyFilters();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt),
                  tooltip: 'Apply search',
                  onPressed: _applyFilters,
                ),
              ],
            ),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const LoadingView(),
              error: (error, _) =>
                  ErrorView(message: error.toString(), onRetry: controller.refresh),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ResponsiveTable<Product>(
                    items: products,
                    columns: [
                      ResponsiveColumn(
                        label: 'Name',
                        cellBuilder: (context, item) => Text(item.name),
                      ),
                      ResponsiveColumn(
                        label: 'Manufacturer',
                        cellBuilder: (context, item) => Text(item.manufacturer ?? '—'),
                      ),
                      ResponsiveColumn(
                        label: 'Status',
                        cellBuilder: (context, item) => StatusBadge(status: item.status),
                      ),
                      ResponsiveColumn(
                        label: 'Updated',
                        cellBuilder: (context, item) => Text(
                          '${item.updatedAt.year}-${item.updatedAt.month.toString().padLeft(2, '0')}-${item.updatedAt.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ],
                    actionsBuilder: (context, item) => _ProductActions(product: item),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: controller.page > 0 ? controller.previousPage : null,
                  child: const Text('Previous'),
                ),
                Text('Page ${controller.page + 1}'),
                TextButton(
                  onPressed: controller.hasMore ? controller.nextPage : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductActions extends ConsumerWidget {
  const _ProductActions({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(productListControllerProvider.notifier);

    return PopupMenuButton<String>(
      onSelected: (action) async {
        switch (action) {
          case 'edit':
            context.go('/admin/products/${product.id}/edit');
          case 'duplicate':
            final error = await controller.duplicate(product.id);
            if (error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            }
          case 'publish':
            controller.setStatus(id: product.id, status: 'published');
          case 'unpublish':
            controller.setStatus(id: product.id, status: 'draft');
          case 'archive':
            controller.setStatus(id: product.id, status: 'archived');
          case 'delete':
            controller.softDelete(product.id);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
        if (product.status != 'published')
          const PopupMenuItem(value: 'publish', child: Text('Publish')),
        if (product.status == 'published')
          const PopupMenuItem(value: 'unpublish', child: Text('Unpublish')),
        if (product.status != 'archived')
          const PopupMenuItem(value: 'archive', child: Text('Archive')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }
}
