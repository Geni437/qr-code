import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  late MockSupabaseClient client;
  late MockGoTrueClient auth;
  late AuthRepositoryImpl repository;

  setUp(() {
    client = MockSupabaseClient();
    auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    repository = AuthRepositoryImpl(client);
  });

  group('signIn', () {
    test('returns a fallback AppUser when the profile lookup fails', () async {
      final user = MockUser();
      when(() => user.id).thenReturn('user-1');
      when(() => user.email).thenReturn('admin@example.com');

      final response = MockAuthResponse();
      when(() => response.user).thenReturn(user);

      when(
        () => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => response);

      // `client.from(...)` is never stubbed, so the profile lookup inside
      // the repository throws and is swallowed, falling back to a bare
      // session-derived AppUser — this is the behavior under test.
      final result = await repository.signIn(
        email: 'admin@example.com',
        password: 'password123',
      );

      expect(result.isRight(), isTrue);
      result.match((_) => fail('expected Right'), (appUser) {
        expect(appUser.id, 'user-1');
        expect(appUser.email, 'admin@example.com');
      });
    });

    test('returns AuthFailure when Supabase throws AuthException', () async {
      when(
        () => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthException('Invalid login credentials'));

      final result = await repository.signIn(
        email: 'admin@example.com',
        password: 'wrong-password',
      );

      expect(result.isLeft(), isTrue);
      result.match(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns AuthFailure when no user is returned', () async {
      final response = MockAuthResponse();
      when(() => response.user).thenReturn(null);

      when(
        () => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => response);

      final result = await repository.signIn(
        email: 'admin@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('signOut', () {
    test('returns Right(unit) on success', () async {
      when(() => auth.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result.isRight(), isTrue);
    });

    test('returns AuthFailure when Supabase throws', () async {
      when(
        () => auth.signOut(),
      ).thenThrow(const AuthException('Network error'));

      final result = await repository.signOut();

      expect(result.isLeft(), isTrue);
    });
  });
}
