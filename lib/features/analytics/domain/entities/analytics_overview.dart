import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_overview.freezed.dart';

@freezed
abstract class ProductViewCount with _$ProductViewCount {
  const factory ProductViewCount({required String productId, required String productName, required int count}) =
      _ProductViewCount;
}

@freezed
abstract class AnalyticsOverview with _$AnalyticsOverview {
  const factory AnalyticsOverview({
    /// Scan counts for the last 30 days, oldest first (index 29 = today).
    required List<int> scansLast30Days,
    required List<ProductViewCount> mostViewedProducts,
    required Map<String, int> eventTypeCounts,
    required Map<String, int> deviceTypeCounts,
  }) = _AnalyticsOverview;
}
