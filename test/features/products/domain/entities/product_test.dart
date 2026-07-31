import 'package:flutter_test/flutter_test.dart';
import 'package:qr_ar_platform/features/products/domain/entities/product.dart';

void main() {
  test('Product.fromRow maps a Postgrest row correctly, including tags', () {
    final row = {
      'id': 'prod-1',
      'name': 'Heavy Duty Pump',
      'slug': 'heavy-duty-pump',
      'description': 'A pump',
      'category_id': 'cat-1',
      'manufacturer': 'Acme',
      'model_number': 'HD-100',
      'serial_number': 'SN-42',
      'version': '1.0',
      'thumbnail_url': null,
      'cover_image_url': null,
      'tags': ['industrial', 'pump'],
      'status': 'draft',
      'is_deleted': false,
      'created_at': '2026-01-01T00:00:00.000Z',
      'updated_at': '2026-01-02T00:00:00.000Z',
    };

    final product = Product.fromRow(row);

    expect(product.id, 'prod-1');
    expect(product.name, 'Heavy Duty Pump');
    expect(product.tags, ['industrial', 'pump']);
    expect(product.isPublished, isFalse);
  });

  test('Product.fromRow defaults tags to an empty list when null', () {
    final row = {
      'id': 'prod-2',
      'name': 'Widget',
      'slug': 'widget',
      'description': null,
      'category_id': null,
      'manufacturer': null,
      'model_number': null,
      'serial_number': null,
      'version': null,
      'thumbnail_url': null,
      'cover_image_url': null,
      'tags': null,
      'status': 'published',
      'is_deleted': false,
      'created_at': '2026-01-01T00:00:00.000Z',
      'updated_at': '2026-01-02T00:00:00.000Z',
    };

    final product = Product.fromRow(row);

    expect(product.tags, isEmpty);
    expect(product.isPublished, isTrue);
  });
}
