import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qr_ar_platform/core/utilities/result.dart';
import 'package:qr_ar_platform/features/notifications/domain/entities/app_notification.dart';
import 'package:qr_ar_platform/features/notifications/domain/repositories/notification_repository.dart';
import 'package:qr_ar_platform/features/notifications/presentation/controllers/notification_providers.dart';
import 'package:qr_ar_platform/features/notifications/presentation/pages/notifications_page.dart';

class FakeEmptyNotificationRepository implements NotificationRepository {
  @override
  Future<Result<List<AppNotification>>> list() async => const Right([]);

  @override
  Future<Result<Unit>> markAsRead(String id) async => throw UnimplementedError();

  @override
  Future<Result<Unit>> markAllAsRead() async => throw UnimplementedError();

  @override
  Future<Result<Unit>> create({
    required String type,
    required String title,
    String? message,
  }) async => throw UnimplementedError();

  @override
  Future<Result<bool>> hasRecentUnread({required String type, required Duration since}) async {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('NotificationsPage shows an empty state with no notifications', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(FakeEmptyNotificationRepository()),
        ],
        child: const MaterialApp(home: NotificationsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No notifications yet'), findsOneWidget);
  });
}
