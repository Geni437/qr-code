import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';
import '../entities/app_notification.dart';

abstract class NotificationRepository {
  Future<Result<List<AppNotification>>> list();

  Future<Result<Unit>> markAsRead(String id);

  Future<Result<Unit>> markAllAsRead();

  Future<Result<Unit>> create({
    required String type,
    required String title,
    String? message,
  });

  /// Whether an unread notification of [type] already exists, created
  /// within [since] — used to avoid spamming the same warning (e.g.
  /// `storage_limit`, `system_error`) on every dashboard load.
  Future<Result<bool>> hasRecentUnread({required String type, required Duration since});
}
