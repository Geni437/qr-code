import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_asset.freezed.dart';

@freezed
abstract class ModelAsset with _$ModelAsset {
  const factory ModelAsset({
    required String id,
    required String productId,
    required String filePath,
    required String format,
    required int version,
    int? fileSizeBytes,
    // Optional USDZ variant for iOS Quick Look AR -- iOS can't AR-launch a
    // .glb/.gltf directly. Absent for most models; AR on iOS is simply not
    // offered when this is null, not an error.
    String? usdzFilePath,
    required String status,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ModelAsset;

  const ModelAsset._();

  factory ModelAsset.fromRow(Map<String, dynamic> json) => ModelAsset(
    id: json['id'] as String,
    productId: json['product_id'] as String,
    filePath: json['file_path'] as String,
    format: json['format'] as String,
    version: json['version'] as int,
    fileSizeBytes: json['file_size_bytes'] as int?,
    usdzFilePath: json['usdz_file_path'] as String?,
    status: json['status'] as String,
    isDeleted: json['is_deleted'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}
