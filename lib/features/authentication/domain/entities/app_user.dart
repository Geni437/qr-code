import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';

part 'app_user.freezed.dart';

/// An authenticated administrator, resolved from Supabase auth + the
/// `profiles`/`roles` tables. Public (unauthenticated) users never get one
/// of these.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    required String role,
    String? displayName,
  }) = _AppUser;

  const AppUser._();

  bool get isSuperAdmin => role == AppRoles.superAdmin;
}
