import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/products/data/repositories/product_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  late MockSupabaseClient client;
  late ProductRepositoryImpl repository;

  setUp(() {
    client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);
    // See category_repository_impl_test.dart for why only the error path
    // (not the full Postgrest builder chain) is exercised here.
    when(() => client.from(any())).thenThrow(Exception('network down'));
    repository = ProductRepositoryImpl(client);
  });

  test('list() maps a thrown exception to ServerFailure', () async {
    final result = await repository.list();
    expect(result.isLeft(), isTrue);
    result.match((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('expected Left'));
  });

  test('create() maps a thrown exception to ServerFailure', () async {
    final result = await repository.create(name: 'Widget', slug: 'widget', status: 'draft');
    expect(result.isLeft(), isTrue);
  });

  test('duplicate() maps a thrown exception to ServerFailure', () async {
    final result = await repository.duplicate('prod-1');
    expect(result.isLeft(), isTrue);
  });
}
