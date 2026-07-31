import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._client);

  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  @override
  Future<Result<List<AppNotification>>> list() async {
    try {
      final rows = await _client
          .from(SupabaseTables.notifications)
          .select()
          .eq('is_deleted', false)
          .order('created_at', ascending: false)
          .limit(100);
      return Right(
        (rows as List)
            .map((row) => AppNotification.fromRow(row as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> markAsRead(String id) async {
    try {
      await _client
          .from(SupabaseTables.notifications)
          .update({'is_read': true, 'updated_by': _userId})
          .eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> markAllAsRead() async {
    try {
      await _client
          .from(SupabaseTables.notifications)
          .update({'is_read': true, 'updated_by': _userId})
          .eq('is_read', false);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> create({
    required String type,
    required String title,
    String? message,
  }) async {
    try {
      await _client.from(SupabaseTables.notifications).insert({
        'type': type,
        'title': title,
        'message': message,
        'created_by': _userId,
        'updated_by': _userId,
      });
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> hasRecentUnread({required String type, required Duration since}) async {
    try {
      final cutoff = DateTime.now().subtract(since);
      final rows = await _client
          .from(SupabaseTables.notifications)
          .select('id')
          .eq('type', type)
          .eq('is_read', false)
          .gte('created_at', cutoff.toIso8601String())
          .limit(1);
      return Right((rows as List).isNotEmpty);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
