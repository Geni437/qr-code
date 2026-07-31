import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.watch(supabaseClientProvider));
});

/// Dashboard stats are read-only (no user-triggered mutation), so a plain
/// `FutureProvider` is enough — no need for the extra AsyncNotifier ceremony
/// used by the list controllers.
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final result = await ref.watch(dashboardRepositoryProvider).getStats();
  return result.match((failure) => throw failure, (stats) => stats);
});
