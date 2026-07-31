import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/core/utilities/result.dart';
import 'package:qr_ar_platform/features/categories/domain/entities/category.dart';
import 'package:qr_ar_platform/features/categories/domain/repositories/category_repository.dart';
import 'package:qr_ar_platform/features/categories/presentation/controllers/category_providers.dart';
import 'package:qr_ar_platform/features/categories/presentation/pages/category_list_page.dart';

class FakeCategoryRepository implements CategoryRepository {
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
  testWidgets('CategoryListPage shows an empty state with no categories', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [categoryRepositoryProvider.overrideWithValue(FakeCategoryRepository())],
        child: const MaterialApp(home: CategoryListPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No categories yet'), findsOneWidget);
  });
}
