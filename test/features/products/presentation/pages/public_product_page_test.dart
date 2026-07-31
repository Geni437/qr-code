import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/core/utilities/result.dart';
import 'package:qr_ar_platform/features/analytics/domain/repositories/scan_repository.dart';
import 'package:qr_ar_platform/features/analytics/presentation/controllers/scan_providers.dart';
import 'package:qr_ar_platform/features/hotspots/domain/entities/hotspot.dart';
import 'package:qr_ar_platform/features/hotspots/domain/repositories/hotspot_repository.dart';
import 'package:qr_ar_platform/features/hotspots/presentation/controllers/hotspot_providers.dart';
import 'package:qr_ar_platform/features/models/domain/entities/model_asset.dart';
import 'package:qr_ar_platform/features/models/domain/repositories/model_repository.dart';
import 'package:qr_ar_platform/features/models/presentation/controllers/model_providers.dart';
import 'package:qr_ar_platform/features/products/domain/entities/product.dart';
import 'package:qr_ar_platform/features/products/domain/repositories/product_repository.dart';
import 'package:qr_ar_platform/features/products/presentation/controllers/product_providers.dart';
import 'package:qr_ar_platform/features/products/presentation/pages/public_product_page.dart';

class FakeScanRepository implements ScanRepository {
  @override
  Future<Result<Unit>> recordScan({required String productId}) async => const Right(unit);
}

/// Always reports no models for the product, so `_Product3DViewerSection`
/// renders its "No 3D model available" state instead of touching the real
/// Supabase client (not initialized in a widget test).
class FakeEmptyModelRepository implements ModelRepository {
  @override
  Future<Result<List<ModelAsset>>> listForProduct(String productId) async => const Right([]);

  @override
  Future<Result<ModelAsset>> upload({
    required String productId,
    required String fileName,
    required Uint8List bytes,
    required String format,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Unit>> delete(ModelAsset model) async => throw UnimplementedError();

  @override
  Future<Result<String>> getSignedUrl(String filePath) async => throw UnimplementedError();

  @override
  Future<Result<ModelAsset>> attachUsdz({
    required ModelAsset model,
    required String fileName,
    required Uint8List bytes,
  }) async => throw UnimplementedError();
}

class FakeEmptyHotspotRepository implements HotspotRepository {
  @override
  Future<Result<List<Hotspot>>> listForModel(String modelId) async => const Right([]);

  @override
  Future<Result<Hotspot>> create({
    required String productId,
    required String modelId,
    String? mediaId,
    required String title,
    String? description,
    required double positionX,
    required double positionY,
    required double positionZ,
    String? linkUrl,
    String? animationName,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Hotspot>> update({
    required String id,
    String? mediaId,
    required String title,
    String? description,
    String? linkUrl,
    String? animationName,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Unit>> delete(String id) async => throw UnimplementedError();
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
        modelRepositoryProvider.overrideWithValue(FakeEmptyModelRepository()),
        hotspotRepositoryProvider.overrideWithValue(FakeEmptyHotspotRepository()),
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

  testWidgets('shows the disabled 3D button when the product has no model', (tester) async {
    await tester.pumpWidget(buildSubject(FakeProductRepository(Right(_publishedProduct()))));
    await tester.pumpAndSettle();

    expect(find.text('View in 3D / AR'), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });
}
