import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';
import '../entities/app_user.dart';

/// Admin authentication contract. The data layer implements this against
/// Supabase; presentation only ever depends on this abstraction.
abstract class AuthRepository {
  /// The currently signed-in admin, or `null` if signed out. Synchronous
  /// snapshot of Supabase's in-memory session.
  AppUser? get currentUser;

  /// Emits whenever the admin's session changes (sign in, sign out, token
  /// refresh), resolving the full [AppUser] (including role) each time.
  Stream<AppUser?> authStateChanges();

  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Result<Unit>> signOut();

  Future<Result<Unit>> sendPasswordResetEmail({required String email});
}
