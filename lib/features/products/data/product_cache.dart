import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/product.dart';

/// Lightweight stale-while-revalidate cache for the public product page:
/// caches the last-viewed product's fields locally so revisiting the same
/// product shows something instantly instead of a blank spinner, while a
/// fresh fetch still runs underneath. This is a scoped "offline cache" —
/// not a full offline mode (that would need a much larger local-database +
/// sync design), just this one real, measurable improvement.
class ProductCache {
  const ProductCache._();

  static String _key(String productId) => 'product_cache_$productId';

  static Future<Product?> read(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key(productId));
      if (raw == null) return null;
      return Product.fromRow(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> write(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = {
        'id': product.id,
        'name': product.name,
        'slug': product.slug,
        'description': product.description,
        'category_id': product.categoryId,
        'manufacturer': product.manufacturer,
        'model_number': product.modelNumber,
        'serial_number': product.serialNumber,
        'version': product.version,
        'thumbnail_url': product.thumbnailUrl,
        'cover_image_url': product.coverImageUrl,
        'tags': product.tags,
        'status': product.status,
        'is_deleted': product.isDeleted,
        'created_at': product.createdAt.toIso8601String(),
        'updated_at': product.updatedAt.toIso8601String(),
      };
      await prefs.setString(_key(product.id), jsonEncode(map));
    } catch (_) {
      // Best-effort — caching failures shouldn't break the page.
    }
  }
}
