import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads Supabase connection details, preferring compile-time `--dart-define`
/// values over the runtime-loaded `.env` file.
///
/// Why both: `.env` (via `flutter_dotenv`) is convenient for local dev —
/// edit the file, hot restart, no rebuild needed. But it's shipped as a
/// fetchable web asset (`assets/.env`, fetched over HTTP at runtime), and
/// plenty of production web hosts (confirmed on this project's own
/// itclingua.info deployment) block any request for a dotfile as a default
/// security measure — the request 403s and the app silently falls back to
/// the placeholder, unable to reach Supabase at all. `--dart-define` values
/// get compiled directly into the JS bundle at build time, so there's no
/// runtime file fetch to block. Production web builds should pass
/// `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
/// (see docs/DEPLOYMENT.md); local `flutter run` keeps using `.env`
/// unchanged.
class SupabaseConfig {
  const SupabaseConfig._();

  static const _placeholderUrl = 'https://placeholder.supabase.co';
  static const _placeholderAnonKey = 'placeholder-anon-key';

  static const _defineUrl = String.fromEnvironment('SUPABASE_URL');
  static const _defineAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Whether compile-time config was provided via `--dart-define` — used by
  /// `main.dart` to skip the `.env` HTTP fetch entirely when it isn't
  /// needed, rather than let it fail loudly (if the host blocks it) or
  /// silently (if `isOptional` swallows the error) for no reason.
  static bool get hasCompileTimeConfig => _defineUrl.isNotEmpty;

  static String get url {
    if (_defineUrl.isNotEmpty) return _defineUrl;

    final value = dotenv.env['SUPABASE_URL'];
    if (value == null || value.isEmpty) {
      debugPrint(
        'SUPABASE_URL is not set — using a placeholder. '
        'Copy .env.example to .env and fill it in to connect to Supabase.',
      );
      return _placeholderUrl;
    }
    return value;
  }

  static String get anonKey {
    if (_defineAnonKey.isNotEmpty) return _defineAnonKey;

    final value = dotenv.env['SUPABASE_ANON_KEY'];
    if (value == null || value.isEmpty) {
      debugPrint(
        'SUPABASE_ANON_KEY is not set — using a placeholder. '
        'Copy .env.example to .env and fill it in to connect to Supabase.',
      );
      return _placeholderAnonKey;
    }
    return value;
  }
}
