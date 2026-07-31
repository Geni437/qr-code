import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._client);

  final SupabaseClient _client;

  Future<int> _count(String table, {bool onlyPublished = false}) async {
    var query = _client.from(table).select('id').eq('is_deleted', false);
    if (onlyPublished) query = query.eq('status', 'published');
    final response = await query.count(CountOption.exact);
    return response.count;
  }

  Future<int> _sumFileSizeBytes(String table) async {
    final rows = await _client.from(table).select('file_size_bytes').eq('is_deleted', false);
    return (rows as List).fold<int>(
      0,
      (sum, row) => sum + ((row as Map<String, dynamic>)['file_size_bytes'] as int? ?? 0),
    );
  }

  Future<List<int>> _scansLast7Days() async {
    final since = DateTime.now().subtract(const Duration(days: 6));
    final sinceMidnight = DateTime(since.year, since.month, since.day);
    final rows = await _client
        .from(SupabaseTables.scans)
        .select('scanned_at')
        .gte('scanned_at', sinceMidnight.toIso8601String());

    final counts = List<int>.filled(7, 0);
    final today = DateTime.now();
    for (final row in rows as List) {
      final scannedAt = DateTime.parse((row as Map<String, dynamic>)['scanned_at'] as String);
      final dayOffset = DateTime(today.year, today.month, today.day)
          .difference(DateTime(scannedAt.year, scannedAt.month, scannedAt.day))
          .inDays;
      final index = 6 - dayOffset;
      if (index >= 0 && index < 7) counts[index]++;
    }
    return counts;
  }

  Future<List<Product>> _recentUploads() async {
    final rows = await _client
        .from(SupabaseTables.products)
        .select()
        .eq('is_deleted', false)
        .order('created_at', ascending: false)
        .limit(5);
    return (rows as List)
        .map((row) => Product.fromRow(row as Map<String, dynamic>))
        .toList();
  }

  Future<bool> _checkHealth() async {
    try {
      await _client.from(SupabaseTables.settings).select('id').limit(1);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Result<DashboardStats>> getStats() async {
    try {
      final results = await Future.wait([
        _count(SupabaseTables.products),
        _count(SupabaseTables.products, onlyPublished: true),
        _count(SupabaseTables.categories),
        _count(SupabaseTables.models),
        _count(SupabaseTables.scans),
        _sumFileSizeBytes(SupabaseTables.models),
        _sumFileSizeBytes(SupabaseTables.media),
      ]);

      final scansLast7Days = await _scansLast7Days();
      final recentUploads = await _recentUploads();
      final isHealthy = await _checkHealth();

      final totalProducts = results[0];
      final activeProducts = results[1];
      final totalCategories = results[2];
      final totalModels = results[3];
      final totalScans = results[4];
      final storageUsageBytes = results[5] + results[6];

      return Right(
        DashboardStats(
          totalProducts: totalProducts,
          activeProducts: activeProducts,
          totalCategories: totalCategories,
          totalModels: totalModels,
          totalQrCodes: activeProducts,
          totalScans: totalScans,
          storageUsageBytes: storageUsageBytes,
          recentUploads: recentUploads,
          scansLast7Days: scansLast7Days,
          isHealthy: isHealthy,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
