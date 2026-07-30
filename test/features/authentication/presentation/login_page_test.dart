import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/core/utilities/result.dart';
import 'package:qr_ar_platform/features/authentication/domain/entities/app_user.dart';
import 'package:qr_ar_platform/features/authentication/domain/repositories/auth_repository.dart';
import 'package:qr_ar_platform/features/authentication/presentation/controllers/auth_providers.dart';
import 'package:qr_ar_platform/features/authentication/presentation/pages/login_page.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  AppUser? get currentUser => null;

  @override
  Stream<AppUser?> authStateChanges() => const Stream.empty();

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    return const Left(AuthFailure('not used in this test'));
  }

  @override
  Future<Result<Unit>> signOut() async => const Right(unit);

  @override
  Future<Result<Unit>> sendPasswordResetEmail({required String email}) async {
    return const Right(unit);
  }
}

void main() {
  Widget buildSubject() {
    return ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(FakeAuthRepository())],
      child: const MaterialApp(home: LoginPage()),
    );
  }

  testWidgets('renders the sign-in form', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Administrator Sign In'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('shows validation errors on empty submit', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}
