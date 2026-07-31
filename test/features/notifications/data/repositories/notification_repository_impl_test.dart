import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  late MockSupabaseClient client;
  late NotificationRepositoryImpl repository;

  setUp(() {
    client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);
    when(() => client.from(any())).thenThrow(Exception('network down'));
    repository = NotificationRepositoryImpl(client);
  });

  test('create maps a thrown exception to ServerFailure', () async {
    final result = await repository.create(type: 'new_model', title: 'New model uploaded');
    expect(result.isLeft(), isTrue);
    result.match((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('expected Left'));
  });

  test('markAsRead maps a thrown exception to ServerFailure', () async {
    final result = await repository.markAsRead('notif-1');
    expect(result.isLeft(), isTrue);
  });
}
