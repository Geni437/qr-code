import 'package:flutter/foundation.dart';

/// Best-effort anonymous client context, shared by every anonymous-event
/// repository (`ScanRepositoryImpl`, `AnalyticsRepositoryImpl`).
///
/// Browser and country/city are deliberately left out: browser detection
/// needs user-agent parsing and country/city needs IP geolocation (a
/// Supabase Edge Function) — both are real work for a small accuracy gain,
/// not something this client-side helper should grow to do.
class ClientContext {
  const ClientContext._();

  static String get deviceType {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return 'mobile';
      default:
        return 'desktop';
    }
  }

  static String get os {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name;
  }

  static String get language => PlatformDispatcher.instance.locale.toLanguageTag();
}
