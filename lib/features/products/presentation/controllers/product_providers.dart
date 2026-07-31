import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(supabaseClientProvider));
});

/// Fetches a single product by id — used by the edit form, which navigates
/// directly to `/admin/products/:id/edit` and can't assume the product is
/// already loaded in [ProductListController]'s current page.
final productByIdProvider = FutureProvider.family<Product, String>((ref, id) async {
  final result = await ref.watch(productRepositoryProvider).getById(id);
  return result.match((failure) => throw failure, (product) => product);
});

const productPageSize = 20;

/// Drives the product list screen: paginated + filterable fetch, plus the
/// row actions (duplicate, publish/unpublish/archive, soft-delete).
class ProductListController extends AsyncNotifier<List<Product>> {
  String? _search;
  String? _categoryId;
  String? _status;
  int _page = 0;

  int get page => _page;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  Future<List<Product>> build() => _fetch();

  Future<List<Product>> _fetch() async {
    final result = await ref
        .watch(productRepositoryProvider)
        .list(
          page: _page,
          pageSize: productPageSize,
          search: _search,
          categoryId: _categoryId,
          status: _status,
        );
    return result.match((failure) => throw failure, (products) {
      _hasMore = products.length == productPageSize;
      return products;
    });
  }

  Future<void> applyFilters({String? search, String? categoryId, String? status}) async {
    _search = search;
    _categoryId = categoryId;
    _status = status;
    _page = 0;
    await refresh();
  }

  Future<void> nextPage() async {
    if (!_hasMore) return;
    _page++;
    await refresh();
  }

  Future<void> previousPage() async {
    if (_page == 0) return;
    _page--;
    await refresh();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<String?> duplicate(String id) async {
    final result = await ref.read(productRepositoryProvider).duplicate(id);
    return result.match((failure) => failure.message, (_) {
      refresh();
      return null;
    });
  }

  Future<void> setStatus({required String id, required String status}) async {
    await ref.read(productRepositoryProvider).setStatus(id: id, status: status);
    await refresh();
  }

  Future<void> softDelete(String id) async {
    await ref.read(productRepositoryProvider).softDelete(id);
    await refresh();
  }
}

final productListControllerProvider =
    AsyncNotifierProvider<ProductListController, List<Product>>(
      ProductListController.new,
    );
