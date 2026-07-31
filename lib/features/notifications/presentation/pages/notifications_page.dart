import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../controllers/notification_providers.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () async {
              await ref.read(notificationRepositoryProvider).markAllAsRead();
              ref.invalidate(notificationsListProvider);
            },
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(notificationsListProvider),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications yet'));
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                leading: Icon(
                  _iconForType(notification.type),
                  color: notification.isRead ? null : Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: notification.message != null ? Text(notification.message!) : null,
                trailing: notification.isRead
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.check),
                        tooltip: 'Mark as read',
                        onPressed: () async {
                          await ref
                              .read(notificationRepositoryProvider)
                              .markAsRead(notification.id);
                          ref.invalidate(notificationsListProvider);
                        },
                      ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconForType(String type) => switch (type) {
    'failed_upload' => Icons.error_outline,
    'storage_limit' => Icons.storage_outlined,
    'new_model' => Icons.view_in_ar_outlined,
    'system_error' => Icons.warning_amber_outlined,
    'security_alert' => Icons.security_outlined,
    _ => Icons.notifications_outlined,
  };
}
