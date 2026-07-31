import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';

/// Records viewer/interaction analytics events (distinct from a QR
/// [ScanRepository] scan event). Most of these events actually originate
/// from plain JS in the hotspot popover (see
/// `lib/features/viewer/data/analytics_tracking_js_builder.dart`), which
/// posts directly to Supabase's REST endpoint rather than calling through
/// here — this repository covers the two events that originate in Dart:
/// `viewer_open` and `screenshot`.
abstract class AnalyticsRepository {
  Future<Result<Unit>> recordEvent({
    required String productId,
    required String eventType,
    Map<String, dynamic> metadata = const {},
  });
}
