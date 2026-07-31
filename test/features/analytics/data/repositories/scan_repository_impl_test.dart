import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/analytics/data/repositories/scan_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  test('recordScan maps a thrown exception to ServerFailure', () async {
    final client = MockSupabaseClient();
    when(() => client.from(any())).thenThrow(Exception('network down'));
    final repository = ScanRepositoryImpl(client);

    final result = await repository.recordScan(productId: 'prod-1');

    expect(result.isLeft(), isTrue);
    result.match((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('expected Left'));
  });
}
