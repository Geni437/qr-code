import 'package:flutter_test/flutter_test.dart';
import 'package:qr_ar_platform/features/categories/domain/entities/category.dart';

void main() {
  test('Category.fromRow maps a Postgrest row correctly', () {
    final row = {
      'id': 'cat-1',
      'name': 'Engineering',
      'slug': 'engineering',
      'description': null,
      'parent_id': null,
      'status': 'published',
      'is_deleted': false,
      'created_at': '2026-01-01T00:00:00.000Z',
      'updated_at': '2026-01-02T00:00:00.000Z',
    };

    final category = Category.fromRow(row);

    expect(category.id, 'cat-1');
    expect(category.name, 'Engineering');
    expect(category.slug, 'engineering');
    expect(category.description, isNull);
    expect(category.parentId, isNull);
    expect(category.isPublished, isTrue);
    expect(category.isDeleted, isFalse);
  });
}
