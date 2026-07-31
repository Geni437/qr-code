import 'package:flutter_test/flutter_test.dart';
import 'package:qr_ar_platform/features/hotspots/domain/entities/hotspot.dart';

void main() {
  test('Hotspot.fromRow maps a Postgrest row correctly', () {
    final row = {
      'id': 'hs-1',
      'product_id': 'prod-1',
      'model_id': 'model-1',
      'media_id': null,
      'title': 'Fuel cap',
      'description': 'Unscrew to refill',
      'position_x': 1,
      'position_y': 0.5,
      'position_z': -2,
      'link_url': null,
      'animation_name': 'open',
      'status': 'published',
      'is_deleted': false,
      'created_at': '2026-01-01T00:00:00.000Z',
      'updated_at': '2026-01-02T00:00:00.000Z',
    };

    final hotspot = Hotspot.fromRow(row);

    expect(hotspot.id, 'hs-1');
    expect(hotspot.title, 'Fuel cap');
    expect(hotspot.positionX, 1.0);
    expect(hotspot.positionY, 0.5);
    expect(hotspot.positionZ, -2.0);
    expect(hotspot.animationName, 'open');
    expect(hotspot.mediaId, isNull);
  });
}
