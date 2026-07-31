import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qr_ar_platform/core/utilities/result.dart';
import 'package:qr_ar_platform/features/categories/domain/entities/category.dart';
import 'package:qr_ar_platform/features/categories/domain/repositories/category_repository.dart';
import 'package:qr_ar_platform/features/categories/presentation/controllers/category_providers.dart';
import 'package:qr_ar_platform/features/products/domain/entities/product.dart';
import 'package:qr_ar_platform/features/products/domain/repositories/product_repository.dart';
import 'package:qr_ar_platform/features/products/presentation/controllers/product_providers.dart';
import 'package:qr_ar_platform/features/products/presentation/pages/product_list_page.dart';

class FakeEmptyProductRepository implements ProductRepository {
  @override
  Future<Result<List<Product>>> list({
    int page = 0,
    int pageSize = 20,
    String? search,
    String? categoryId,
    String? status,
  }) async => const Right([]);

  @override
  Future<Result<Product>> getById(String id) async => throw UnimplementedError();

  @override
  Future<Result<Product>> create({
    required String name,
    required String slug,
    String? description,
    String? categoryId,
    String? manufacturer,
    String? modelNumber,
    String? serialNumber,
    String? version,
    List<String> tags = const [],
    required String status,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Product>> update({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? categoryId,
    String? manufacturer,
    String? modelNumber,
    String? serialNumber,
    String? version,
    List<String> tags = const [],
  }) async => throw UnimplementedError();

  @override
  Future<Result<Product>> updateImages({
    required String id,
    String? thumbnailUrl,
    String? coverImageUrl,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Product>> duplicate(String id) async => throw UnimplementedError();

  @override
  Future<Result<Product>> setStatus({required String id, required String status}) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit>> softDelete(String id) async => throw UnimplementedError();
}

class FakeEmptyCategoryRepository implements CategoryRepository {
  @override
  Future<Result<List<Category>>> list() async => const Right([]);

  @override
  Future<Result<Category>> create({
    required String name,
    required String slug,
    String? description,
    String? parentId,
    required String status,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Category>> update({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? parentId,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Category>> setStatus({required String id, required String status}) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit>> softDelete(String id) async => throw UnimplementedError();
}

void main() {
  testWidgets('ProductListPage shows an empty state with no products', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productRepositoryProvider.overrideWithValue(FakeEmptyProductRepository()),
          categoryRepositoryProvider.overrideWithValue(FakeEmptyCategoryRepository()),
        ],
        child: const MaterialApp(home: ProductListPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No products found'), findsOneWidget);
  });
}
