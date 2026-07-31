import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';
import '../report_type.dart';

abstract class ReportRepository {
  /// Records that a report was generated (audit trail) — the file itself
  /// isn't persisted to storage; it's generated fresh and downloaded
  /// immediately, same philosophy as the Phase 3 QR code downloads.
  Future<Result<Unit>> recordGenerated({
    required ReportType type,
    required ReportFormat format,
    Map<String, dynamic> parameters = const {},
  });
}
