import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/client_context.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<Unit>> recordEvent({
    required String productId,
    required String eventType,
    Map<String, dynamic> metadata = const {},
  }) async {
    try {
      await _client.from(SupabaseTables.analytics).insert({
        'product_id': productId,
        'event_type': eventType,
        'metadata': metadata,
        'device_type': ClientContext.deviceType,
        'language': ClientContext.language,
      });
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
