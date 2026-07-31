import '../../../../core/utilities/result.dart';
import '../entities/analytics_overview.dart';

abstract class AnalyticsOverviewRepository {
  Future<Result<AnalyticsOverview>> getOverview();
}
