import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/analytics_overview_repository_impl.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../../domain/entities/analytics_overview.dart';
import '../../domain/repositories/analytics_overview_repository.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/repositories/scan_repository.dart';

final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  return ScanRepositoryImpl(ref.watch(supabaseClientProvider));
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl(ref.watch(supabaseClientProvider));
});

final analyticsOverviewRepositoryProvider = Provider<AnalyticsOverviewRepository>((ref) {
  return AnalyticsOverviewRepositoryImpl(ref.watch(supabaseClientProvider));
});

final analyticsOverviewProvider = FutureProvider<AnalyticsOverview>((ref) async {
  final result = await ref.watch(analyticsOverviewRepositoryProvider).getOverview();
  return result.match((failure) => throw failure, (overview) => overview);
});
