import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../authentication/presentation/controllers/auth_providers.dart';
import '../domain/entities/dashboard_stats.dart';
import 'controllers/dashboard_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final user = ref.watch(authControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(dashboardStatsProvider),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(dashboardStatsProvider),
        ),
        data: (stats) => _DashboardBody(stats: stats, welcomeEmail: user?.email),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.stats, this.welcomeEmail});

  final DashboardStats stats;
  final String? welcomeEmail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (welcomeEmail != null)
                Expanded(
                  child: Text(
                    'Welcome back, $welcomeEmail',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              _HealthBadge(isHealthy: stats.isHealthy),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 600
                  ? 3
                  : 2;
              final tiles = [
                _StatTile(label: 'Total Products', value: '${stats.totalProducts}'),
                _StatTile(label: 'Active Products', value: '${stats.activeProducts}'),
                _StatTile(label: 'Total Categories', value: '${stats.totalCategories}'),
                _StatTile(label: 'Total Models', value: '${stats.totalModels}'),
                _StatTile(label: 'Total QR Codes', value: '${stats.totalQrCodes}'),
                _StatTile(label: 'Total Scans', value: '${stats.totalScans}'),
                _StatTile(
                  label: 'Storage Used',
                  value: _formatBytes(stats.storageUsageBytes),
                ),
              ];
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.8,
                children: tiles,
              );
            },
          ),
          const SizedBox(height: 32),
          Text('Scans (last 7 days)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: _ScansChart(counts: stats.scansLast7Days)),
          const SizedBox(height: 32),
          Text('Recent Uploads', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          if (stats.recentUploads.isEmpty)
            const Text('No products yet')
          else
            ...stats.recentUploads.map(
              (product) => Card(
                child: ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(product.name),
                  subtitle: Text(product.status),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _HealthBadge extends StatelessWidget {
  const _HealthBadge({required this.isHealthy});

  final bool isHealthy;

  @override
  Widget build(BuildContext context) {
    final color = isHealthy ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 6),
          Text(isHealthy ? 'Operational' : 'Degraded', style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class _ScansChart extends StatelessWidget {
  const _ScansChart({required this.counts});

  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    final maxCount = counts.isEmpty ? 0 : counts.reduce((a, b) => a > b ? a : b);
    final maxY = maxCount == 0 ? 5.0 : (maxCount * 1.2);
    final today = DateTime.now();

    return BarChart(
      BarChartData(
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final dayOffset = 6 - value.toInt();
                final date = today.subtract(Duration(days: dayOffset));
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('${date.month}/${date.day}', style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < counts.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: counts[i].toDouble(),
                  color: Theme.of(context).colorScheme.primary,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
