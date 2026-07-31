import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';
import '../entities/hotspot.dart';

abstract class HotspotRepository {
  Future<Result<List<Hotspot>>> listForModel(String modelId);

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
  });

  Future<Result<Hotspot>> update({
    required String id,
    String? mediaId,
    required String title,
    String? description,
    String? linkUrl,
    String? animationName,
  });

  /// Hard delete — same reasoning as `ModelRepository`/`MediaRepository`: a
  /// hotspot with no purpose isn't a meaningful "archived" state.
  Future<Result<Unit>> delete(String id);
}
