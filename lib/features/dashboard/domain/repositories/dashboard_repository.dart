import '../../../../core/utilities/result.dart';
import '../entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<Result<DashboardStats>> getStats();
}
