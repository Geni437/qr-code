import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotspot.freezed.dart';

@freezed
abstract class Hotspot with _$Hotspot {
  const factory Hotspot({
    required String id,
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
    required String status,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Hotspot;

  const Hotspot._();

  factory Hotspot.fromRow(Map<String, dynamic> json) => Hotspot(
    id: json['id'] as String,
    productId: json['product_id'] as String,
    modelId: json['model_id'] as String,
    mediaId: json['media_id'] as String?,
    title: json['title'] as String,
    description: json['description'] as String?,
    positionX: (json['position_x'] as num).toDouble(),
    positionY: (json['position_y'] as num).toDouble(),
    positionZ: (json['position_z'] as num).toDouble(),
    linkUrl: json['link_url'] as String?,
    animationName: json['animation_name'] as String?,
    status: json['status'] as String,
    isDeleted: json['is_deleted'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}
