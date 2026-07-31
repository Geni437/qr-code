import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_asset.freezed.dart';

@freezed
abstract class MediaAsset with _$MediaAsset {
  const factory MediaAsset({
    required String id,
    required String productId,
    required String type,
    required String filePath,
    String? fileName,
    String? mimeType,
    int? fileSizeBytes,
    required String status,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MediaAsset;

  const MediaAsset._();

  factory MediaAsset.fromRow(Map<String, dynamic> json) => MediaAsset(
    id: json['id'] as String,
    productId: json['product_id'] as String,
    type: json['type'] as String,
    filePath: json['file_path'] as String,
    fileName: json['file_name'] as String?,
    mimeType: json['mime_type'] as String?,
    fileSizeBytes: json['file_size_bytes'] as int?,
    status: json['status'] as String,
    isDeleted: json['is_deleted'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}
