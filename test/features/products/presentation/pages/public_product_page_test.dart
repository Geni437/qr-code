import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/core/utilities/result.dart';
import 'package:qr_ar_platform/features/analytics/domain/repositories/scan_repository.dart';
import 'package:qr_ar_platform/features/analytics/presentation/controllers/scan_providers.dart';
import 'package:qr_ar_platform/features/products/domain/entities/product.dart';
import 'package:qr_ar_platform/features/products/domain/repositories/product_repository.dart';
import 'package:qr_ar_platform/features/products/presentation/controllers/product_providers.dart';
import 'package:qr_ar_platform/features/products/presentation/pages/public_product_page.dart';

class FakeScanRepository implements ScanRepository {
  @override
  Future<Result<Unit>> recordScan({required String productId}) async => const Right(unit);
}

class FakeProductRepository implements ProductRepository {
  FakeProductRepository(this._result);

  final Result<Product> _result;

  @override
  Future<Result<Product>> getById(String id) async => _result;

  @override
  Future<Result<List<Product>>> list({
    int page = 0,
    int pageSize = 20,
    String? search,
    String? categoryId,
    String? status,
  }) async => throw UnimplementedError();

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

Product _publishedProduct() => Product(
  id: 'prod-1',
  name: 'Heavy Duty Pump',
  slug: 'heavy-duty-pump',
  tags: const [],
  status: 'published',
  isDeleted: false,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  Widget buildSubject(ProductRepository repository) {
    return ProviderScope(
      overrides: [
        productRepositoryProvider.overrideWithValue(repository),
        scanRepositoryProvider.overrideWithValue(FakeScanRepository()),
      ],
      child: const MaterialApp(home: PublicProductPage(productId: 'prod-1')),
    );
  }

  testWidgets('renders the product name when found and published', (tester) async {
    await tester.pumpWidget(buildSubject(FakeProductRepository(Right(_publishedProduct()))));
    await tester.pumpAndSettle();

    expect(find.text('Heavy Duty Pump'), findsOneWidget);
  });

  testWidgets('renders a not-available state when the product is unavailable', (tester) async {
    await tester.pumpWidget(
      buildSubject(FakeProductRepository(const Left(ServerFailure('not found')))),
    );
    await tester.pumpAndSettle();

    expect(find.text('This product isn\'t available.'), findsOneWidget);
  });
}
