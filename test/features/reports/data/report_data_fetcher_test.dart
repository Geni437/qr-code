import 'package:flutter_test/flutter_test.dart';
import 'package:qr_ar_platform/features/reports/data/report_data_fetcher.dart';

void main() {
  test('shapeProductRows builds headers and one row per input, stringifying nulls to empty', () {
    final data = shapeProductRows([
      {
        'name': 'Widget A',
        'slug': 'widget-a',
        'manufacturer': 'Acme',
        'model_number': null,
        'status': 'published',
        'created_at': '2026-01-01T00:00:00.000Z',
      },
    ]);

    expect(data.headers, ['Name', 'Slug', 'Manufacturer', 'Model Number', 'Status', 'Created At']);
    expect(data.rows, [
      ['Widget A', 'widget-a', 'Acme', '', 'published', '2026-01-01T00:00:00.000Z'],
    ]);
  });

  test('shapeStorageRows merges models and media into one table, tagging each by kind', () {
    final data = shapeStorageRows(
      modelRows: [
        {'product_id': 'prod-1', 'file_path': 'prod-1/model.glb', 'file_size_bytes': 1024},
      ],
      mediaRows: [
        {
          'product_id': 'prod-1',
          'file_path': 'prod-1/photo.jpg',
          'file_size_bytes': 512,
          'type': 'image',
        },
      ],
    );

    expect(data.rows.length, 2);
    expect(data.rows[0][0], 'model');
    expect(data.rows[1][0], 'image');
  });
}
