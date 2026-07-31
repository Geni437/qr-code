import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/reports/data/repositories/report_repository_impl.dart';
import 'package:qr_ar_platform/features/reports/domain/report_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  test('recordGenerated maps a thrown exception to ServerFailure', () async {
    final client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);
    when(() => client.from(any())).thenThrow(Exception('network down'));
    final repository = ReportRepositoryImpl(client);

    final result = await repository.recordGenerated(
      type: ReportType.products,
      format: ReportFormat.csv,
    );

    expect(result.isLeft(), isTrue);
    result.match((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('expected Left'));
  });
}
