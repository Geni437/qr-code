import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../products/domain/entities/product.dart';

part 'dashboard_stats.freezed.dart';

@freezed
abstract class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int totalProducts,
    required int activeProducts,
    required int totalCategories,
    required int totalModels,
    // Proxy for "Total QR Codes": each published product gets one QR code,
    // but QR generation itself is Phase 3, so this is the closest real
    // number available today.
    required int totalQrCodes,
    required int totalScans,
    required int storageUsageBytes,
    required List<Product> recentUploads,
    /// Scan counts for the last 7 days, oldest first (index 6 = today).
    required List<int> scansLast7Days,
    required bool isHealthy,
  }) = _DashboardStats;
}
