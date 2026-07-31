import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(supabaseClientProvider));
});

/// Drives the category list screen: load, create, update, publish/archive,
/// soft-delete — each mutation refetches the list so the UI always reflects
/// what's actually in the database.
class CategoryListController extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build() async {
    final result = await ref.watch(categoryRepositoryProvider).list();
    return result.match((failure) => throw failure, (categories) => categories);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<String?> create({
    required String name,
    required String slug,
    String? description,
    String? parentId,
    required String status,
  }) async {
    final result = await ref
        .read(categoryRepositoryProvider)
        .create(
          name: name,
          slug: slug,
          description: description,
          parentId: parentId,
          status: status,
        );
    return result.match((failure) => failure.message, (_) {
      refresh();
      return null;
    });
  }

  Future<String?> updateCategory({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? parentId,
  }) async {
    final result = await ref
        .read(categoryRepositoryProvider)
        .update(id: id, name: name, slug: slug, description: description, parentId: parentId);
    return result.match((failure) => failure.message, (_) {
      refresh();
      return null;
    });
  }

  Future<void> setStatus({required String id, required String status}) async {
    await ref.read(categoryRepositoryProvider).setStatus(id: id, status: status);
    await refresh();
  }

  Future<void> softDelete(String id) async {
    await ref.read(categoryRepositoryProvider).softDelete(id);
    await refresh();
  }
}

final categoryListControllerProvider =
    AsyncNotifierProvider<CategoryListController, List<Category>>(
      CategoryListController.new,
    );
