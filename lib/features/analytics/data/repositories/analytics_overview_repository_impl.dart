import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/entities/analytics_overview.dart';
import '../../domain/repositories/analytics_overview_repository.dart';

/// Aggregates client-side over a capped 30-day window of raw rows. That's
/// a real, working approach at the scale this app operates at — it is
/// *not* how you'd do it at high scan volume, where a Postgres view/RPC
/// doing the aggregation server-side would be the right move. Worth
/// stating plainly rather than silently shipping something that degrades
/// badly if traffic grows a lot.
class AnalyticsOverviewRepositoryImpl implements AnalyticsOverviewRepository {
  AnalyticsOverviewRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _windowDays = 30;
  static const _rowCap = 5000;

  @override
  Future<Result<AnalyticsOverview>> getOverview() async {
    try {
      final since = DateTime.now().subtract(const Duration(days: _windowDays - 1));
      final sinceMidnight = DateTime(since.year, since.month, since.day);

      final scanRows =
          await _client
                  .from(SupabaseTables.scans)
                  .select('product_id, scanned_at, device_type')
                  .gte('scanned_at', sinceMidnight.toIso8601String())
                  .order('scanned_at', ascending: false)
              as List;
      final limitedScanRows = scanRows.take(_rowCap).cast<Map<String, dynamic>>().toList();

      final analyticsRows =
          await _client
                  .from(SupabaseTables.analytics)
                  .select('event_type')
                  .gte('occurred_at', sinceMidnight.toIso8601String())
                  .order('occurred_at', ascending: false)
              as List;
      final limitedAnalyticsRows = analyticsRows
          .take(_rowCap)
          .cast<Map<String, dynamic>>()
          .toList();

      final scansLast30Days = _bucketByDay(limitedScanRows);
      final deviceTypeCounts = _countBy(limitedScanRows, 'device_type');
      final eventTypeCounts = _countBy(limitedAnalyticsRows, 'event_type');
      final mostViewedProducts = await _mostViewedProducts(limitedScanRows);

      return Right(
        AnalyticsOverview(
          scansLast30Days: scansLast30Days,
          mostViewedProducts: mostViewedProducts,
          eventTypeCounts: eventTypeCounts,
          deviceTypeCounts: deviceTypeCounts,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  List<int> _bucketByDay(List<Map<String, dynamic>> rows) {
    final counts = List<int>.filled(_windowDays, 0);
    final today = DateTime.now();
    for (final row in rows) {
      final scannedAt = DateTime.parse(row['scanned_at'] as String);
      final dayOffset = DateTime(
        today.year,
        today.month,
        today.day,
      ).difference(DateTime(scannedAt.year, scannedAt.month, scannedAt.day)).inDays;
      final index = (_windowDays - 1) - dayOffset;
      if (index >= 0 && index < _windowDays) counts[index]++;
    }
    return counts;
  }

  Map<String, int> _countBy(List<Map<String, dynamic>> rows, String key) {
    final counts = <String, int>{};
    for (final row in rows) {
      final value = row[key] as String?;
      if (value == null) continue;
      counts[value] = (counts[value] ?? 0) + 1;
    }
    return counts;
  }

  Future<List<ProductViewCount>> _mostViewedProducts(List<Map<String, dynamic>> scanRows) async {
    final counts = <String, int>{};
    for (final row in scanRows) {
      final productId = row['product_id'] as String?;
      if (productId == null) continue;
      counts[productId] = (counts[productId] ?? 0) + 1;
    }

    final topEntries = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top10 = topEntries.take(10).toList();
    if (top10.isEmpty) return [];

    final productRows = await _client
        .from(SupabaseTables.products)
        .select('id, name')
        .inFilter('id', top10.map((e) => e.key).toList());
    final namesById = {
      for (final row in productRows as List) (row as Map<String, dynamic>)['id'] as String: row['name'] as String,
    };

    return top10
        .map(
          (entry) => ProductViewCount(
            productId: entry.key,
            productName: namesById[entry.key] ?? 'Unknown product',
            count: entry.value,
          ),
        )
        .toList();
  }
}
