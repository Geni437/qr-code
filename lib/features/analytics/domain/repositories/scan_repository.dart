import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';

/// Records anonymous QR-scan events. Intentionally minimal — Phase 6
/// (Analytics) extends this same repository with richer event types rather
/// than replacing it.
abstract class ScanRepository {
  Future<Result<Unit>> recordScan({required String productId});
}
