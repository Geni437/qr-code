import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/responsive_table.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/category.dart';
import '../controllers/category_providers.dart';

class CategoryListPage extends ConsumerWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New category',
            onPressed: () => context.go('/admin/categories/new'),
          ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.read(categoryListControllerProvider.notifier).refresh(),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories yet'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(categoryListControllerProvider.notifier).refresh(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: ResponsiveTable<Category>(
                items: categories,
                columns: [
                  ResponsiveColumn(
                    label: 'Name',
                    cellBuilder: (context, item) => Text(item.name),
                  ),
                  ResponsiveColumn(
                    label: 'Slug',
                    cellBuilder: (context, item) => Text(item.slug),
                  ),
                  ResponsiveColumn(
                    label: 'Status',
                    cellBuilder: (context, item) => StatusBadge(status: item.status),
                  ),
                ],
                actionsBuilder: (context, item) => _CategoryActions(category: item),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryActions extends ConsumerWidget {
  const _CategoryActions({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(categoryListControllerProvider.notifier);

    return PopupMenuButton<String>(
      onSelected: (action) {
        switch (action) {
          case 'edit':
            context.go('/admin/categories/${category.id}/edit');
          case 'publish':
            controller.setStatus(id: category.id, status: 'published');
          case 'unpublish':
            controller.setStatus(id: category.id, status: 'draft');
          case 'archive':
            controller.setStatus(id: category.id, status: 'archived');
          case 'delete':
            controller.softDelete(category.id);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        if (category.status != 'published')
          const PopupMenuItem(value: 'publish', child: Text('Publish')),
        if (category.status == 'published')
          const PopupMenuItem(value: 'unpublish', child: Text('Unpublish')),
        if (category.status != 'archived')
          const PopupMenuItem(value: 'archive', child: Text('Archive')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }
}
