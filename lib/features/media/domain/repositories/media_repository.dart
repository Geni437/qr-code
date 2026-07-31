import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';
import '../entities/media_asset.dart';

abstract class MediaRepository {
  Future<Result<List<MediaAsset>>> listForProduct(String productId);

  Future<Result<MediaAsset>> upload({
    required String productId,
    required String fileName,
    required Uint8List bytes,
    required String? extension,
  });

  Future<Result<Unit>> delete(MediaAsset media);
}
