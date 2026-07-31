import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/hotspots/data/repositories/hotspot_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  late MockSupabaseClient client;
  late HotspotRepositoryImpl repository;

  setUp(() {
    client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);
    when(() => client.from(any())).thenThrow(Exception('network down'));
    repository = HotspotRepositoryImpl(client);
  });

  test('listForModel maps a thrown exception to ServerFailure', () async {
    final result = await repository.listForModel('model-1');
    expect(result.isLeft(), isTrue);
    result.match((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('expected Left'));
  });

  test('create maps a thrown exception to ServerFailure', () async {
    final result = await repository.create(
      productId: 'prod-1',
      modelId: 'model-1',
      title: 'Fuel cap',
      positionX: 0,
      positionY: 0,
      positionZ: 0,
    );
    expect(result.isLeft(), isTrue);
  });

  test('delete maps a thrown exception to ServerFailure', () async {
    final result = await repository.delete('hs-1');
    expect(result.isLeft(), isTrue);
  });
}
