import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? parentId,
    required String status,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;

  const Category._();

  factory Category.fromRow(Map<String, dynamic> json) => Category(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
    description: json['description'] as String?,
    parentId: json['parent_id'] as String?,
    status: json['status'] as String,
    isDeleted: json['is_deleted'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  bool get isPublished => status == 'published';
}
