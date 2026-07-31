import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? categoryId,
    String? manufacturer,
    String? modelNumber,
    String? serialNumber,
    String? version,
    // Storage path (bucket-relative), not a resolvable URL yet — the
    // `thumbnails`/`images` buckets are admin-only in Phase 2. Resolve via
    // a signed URL for now; Phase 4 will decide the public retrieval path.
    String? thumbnailUrl,
    String? coverImageUrl,
    required List<String> tags,
    required String status,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Product;

  const Product._();

  factory Product.fromRow(Map<String, dynamic> json) => Product(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
    description: json['description'] as String?,
    categoryId: json['category_id'] as String?,
    manufacturer: json['manufacturer'] as String?,
    modelNumber: json['model_number'] as String?,
    serialNumber: json['serial_number'] as String?,
    version: json['version'] as String?,
    thumbnailUrl: json['thumbnail_url'] as String?,
    coverImageUrl: json['cover_image_url'] as String?,
    tags: (json['tags'] as List? ?? const []).cast<String>(),
    status: json['status'] as String,
    isDeleted: json['is_deleted'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  bool get isPublished => status == 'published';
}
