import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(supabaseClientProvider));
});

final notificationsListProvider = FutureProvider<List<AppNotification>>((ref) async {
  final result = await ref.watch(notificationRepositoryProvider).list();
  return result.match((failure) => throw failure, (list) => list);
});

/// Live unread count for the `AdminShell` bell badge: an initial fetch,
/// then kept current via a Supabase Realtime subscription on the
/// `notifications` table — genuinely live, not polled.
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final controller = StreamController<int>();

  Future<void> refresh() async {
    try {
      final rows = await client
          .from(SupabaseTables.notifications)
          .select('id')
          .eq('is_read', false)
          .eq('is_deleted', false);
      if (!controller.isClosed) controller.add((rows as List).length);
    } catch (_) {
      if (!controller.isClosed) controller.add(0);
    }
  }

  refresh();

  final channel = client
      .channel('notifications-badge')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: SupabaseTables.notifications,
        callback: (payload) => refresh(),
      )
      .subscribe();

  ref.onDispose(() {
    client.removeChannel(channel);
    controller.close();
  });

  return controller.stream;
});
