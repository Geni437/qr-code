import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';
import '../entities/model_asset.dart';

abstract class ModelRepository {
  Future<Result<List<ModelAsset>>> listForProduct(String productId);

  Future<Result<ModelAsset>> upload({
    required String productId,
    required String fileName,
    required Uint8List bytes,
    required String format,
  });

  /// Hard-deletes both the storage object and its row — unlike content
  /// tables, a model row with no backing file isn't a meaningful "archived"
  /// state, so the soft-delete convention doesn't apply here.
  Future<Result<Unit>> delete(ModelAsset model);

  Future<Result<String>> getSignedUrl(String filePath);
}
