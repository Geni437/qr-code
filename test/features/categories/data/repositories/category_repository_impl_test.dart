import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/categories/data/repositories/category_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  late MockSupabaseClient client;
  late CategoryRepositoryImpl repository;

  setUp(() {
    client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);
    // `.from()` itself throws for every test here, exercising the
    // try/catch -> Failure mapping shared by every method below. Testing
    // the success path would require mocking Postgrest's full builder
    // chain (select/eq/order/range, each returning another builder) —
    // disproportionate effort for what Category.fromRow's own unit test
    // (see category_test.dart) already covers for the data-mapping half.
    when(() => client.from(any())).thenThrow(Exception('network down'));
    repository = CategoryRepositoryImpl(client);
  });

  test('list() maps a thrown exception to ServerFailure', () async {
    final result = await repository.list();
    expect(result.isLeft(), isTrue);
    result.match((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('expected Left'));
  });

  test('create() maps a thrown exception to ServerFailure', () async {
    final result = await repository.create(
      name: 'Engineering',
      slug: 'engineering',
      status: 'published',
    );
    expect(result.isLeft(), isTrue);
  });

  test('softDelete() maps a thrown exception to ServerFailure', () async {
    final result = await repository.softDelete('cat-1');
    expect(result.isLeft(), isTrue);
  });
}
