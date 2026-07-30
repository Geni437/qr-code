import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads Supabase connection details from the loaded `.env` file.
///
/// `.env` is git-ignored; copy `.env.example` to `.env` and fill in the
/// values from your Supabase project's API settings before running the app.
/// Until then, placeholder values are used so the app still launches and the
/// UI shell is inspectable — Supabase calls will simply fail at runtime.
class SupabaseConfig {
  const SupabaseConfig._();

  static const _placeholderUrl = 'https://placeholder.supabase.co';
  static const _placeholderAnonKey = 'placeholder-anon-key';

  static String get url {
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
