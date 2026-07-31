import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// General app-level config (non-Supabase). See [SupabaseConfig] for the
/// same pattern applied to Supabase credentials.
class AppConfig {
  const AppConfig._();

  static const _placeholderBaseUrl = 'https://your-domain.example.com';

  /// The base URL encoded into generated QR codes, e.g.
  /// `$publicBaseUrl/view/{productId}`. There's no deployed web build yet,
  /// so this defaults to an obvious placeholder rather than guessing at
  /// `Uri.base` (which would bake `localhost` into a QR meant for print).
  static String get publicBaseUrl {
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
