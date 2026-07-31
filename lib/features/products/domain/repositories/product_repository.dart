import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  /// Fetches [pageSize] products for [page] (0-indexed), optionally filtered
  /// by [search] (matches name), [categoryId], and [status].
  Future<Result<List<Product>>> list({
    int page = 0,
    int pageSize = 20,
    String? search,
    String? categoryId,
    String? status,
  });

  Future<Result<Product>> getById(String id);

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
  });

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
  });

  Future<Result<Product>> updateImages({
    required String id,
    String? thumbnailUrl,
    String? coverImageUrl,
  });

  Future<Result<Product>> duplicate(String id);

  Future<Result<Product>> setStatus({required String id, required String status});

  Future<Result<Unit>> softDelete(String id);
}
