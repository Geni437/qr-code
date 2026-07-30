import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/controllers/auth_providers.dart';

/// Placeholder landing spot after admin login. Real dashboard widgets
/// (stat tiles, charts, recent uploads) land in a later phase.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Center(
        child: Text(
          user == null
              ? 'Signed in'
              : 'Signed in as ${user.email} (${user.role})',
        ),
      ),
    );
  }
}
