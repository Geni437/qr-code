import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/report_type.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._client);

  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  @override
  Future<Result<Unit>> recordGenerated({
    required ReportType type,
    required ReportFormat format,
    Map<String, dynamic> parameters = const {},
  }) async {
    try {
      await _client.from(SupabaseTables.reports).insert({
        'type': type.dbValue,
        'format': format.name,
        'parameters': parameters,
        'status': 'completed',
        'created_by': _userId,
        'updated_by': _userId,
      });
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
