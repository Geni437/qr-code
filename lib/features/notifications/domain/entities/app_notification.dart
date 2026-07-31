import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    String? recipientId,
    required String type,
    required String title,
    String? message,
    required bool isRead,
    required String status,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppNotification;

  const AppNotification._();

  factory AppNotification.fromRow(Map<String, dynamic> json) => AppNotification(
    id: json['id'] as String,
    recipientId: json['recipient_id'] as String?,
    type: json['type'] as String,
    title: json['title'] as String,
    message: json['message'] as String?,
    isRead: json['is_read'] as bool,
    status: json['status'] as String,
    isDeleted: json['is_deleted'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}
