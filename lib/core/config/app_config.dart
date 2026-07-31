import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// General app-level config (non-Supabase). See [SupabaseConfig] for the
/// same compile-time-vs-runtime-config pattern and why it exists.
class AppConfig {
  const AppConfig._();

  static const _placeholderBaseUrl = 'https://your-domain.example.com';
  static const _defineBaseUrl = String.fromEnvironment('PUBLIC_BASE_URL');

  /// The base URL encoded into generated QR codes, e.g.
  /// `$publicBaseUrl/view/{productId}`. Prefers a `--dart-define` value
  /// (baked in at build time) over `.env` for the same reason as
  /// [SupabaseConfig] — production web builds should pass
  /// `--dart-define=PUBLIC_BASE_URL=...` rather than rely on `.env` being
  /// fetchable at runtime.
  static String get publicBaseUrl {
    if (_defineBaseUrl.isNotEmpty) return _defineBaseUrl;

    final value = dotenv.env['PUBLIC_BASE_URL'];
    if (value == null || value.isEmpty) {
      debugPrint(
        'PUBLIC_BASE_URL is not set — using a placeholder. '
        'Set it in .env to the real deployed URL before printing QR codes.',
      );
      return _placeholderBaseUrl;
    }
    return value;
  }
}
