import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  AppUser? get currentUser => _fallbackUser(_client.auth.currentUser);

  @override
  Stream<AppUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.asyncMap((data) async {
      final user = data.session?.user;
      if (user == null) return null;
      return await _fetchProfile(user.id) ?? _fallbackUser(user);
    });
  }

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Invalid email or password.'));
      }
      final appUser = await _fetchProfile(user.id) ?? _fallbackUser(user)!;
      return Right(appUser);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> sendPasswordResetEmail({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Looks up the admin's role via the `profiles` -> `roles` relationship.
  /// Returns `null` (rather than throwing) if the profile row doesn't exist
  /// yet or the query fails, so callers can fall back to a bare-session user.
  Future<AppUser?> _fetchProfile(String userId) async {
    try {
      final row = await _client
          .from(SupabaseTables.profiles)
          .select('id, email, display_name, roles(name)')
          .eq('id', userId)
          .maybeSingle();
      if (row == null) return null;

      final roleData = row['roles'];
      final roleName = roleData is Map<String, dynamic>
          ? roleData['name'] as String?
          : null;

      return AppUser(
        id: row['id'] as String,
        email: row['email'] as String? ?? '',
        role: roleName ?? AppRoles.administrator,
        displayName: row['display_name'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  AppUser? _fallbackUser(User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      role: AppRoles.administrator,
    );
  }
}
