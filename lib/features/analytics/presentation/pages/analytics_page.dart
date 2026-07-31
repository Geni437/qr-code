import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/analytics_overview.dart';
import '../controllers/scan_providers.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(analyticsOverviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(analyticsOverviewProvider),
          ),
        ],
      ),
      body: overviewAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(analyticsOverviewProvider),
        ),
        data: (overview) => _AnalyticsBody(overview: overview),
      ),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  const _AnalyticsBody({required this.overview});

  final AnalyticsOverview overview;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scans (last 30 days)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: _DayCountChart(counts: overview.scansLast30Days)),
          const SizedBox(height: 32),
          Text('Events', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Hotspot clicks, downloads, and video plays are recorded directly from the '
            'viewer in the browser/app, not through the admin backend.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final type in const [
                'viewer_open',
                'ar_launch',
                'download',
                'video_play',
                'hotspot_click',
                'screenshot',
              ])
                _StatChip(label: type, value: overview.eventTypeCounts[type] ?? 0),
            ],
          ),
          const SizedBox(height: 32),
          Text('By device', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final entry in overview.deviceTypeCounts.entries)
                _StatChip(label: entry.key, value: entry.value),
            ],
          ),
          const SizedBox(height: 32),
          Text('Most viewed products', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          if (overview.mostViewedProducts.isEmpty)
            const Text('No scans in the last 30 days')
          else
            ...overview.mostViewedProducts.map(
              (product) => Card(
                child: ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(product.productName),
                  trailing: Text('${product.count} scans'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$value', style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _DayCountChart extends StatelessWidget {
  const _DayCountChart({required this.counts});

  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    final maxCount = counts.isEmpty ? 0 : counts.reduce((a, b) => a > b ? a : b);
    final maxY = maxCount == 0 ? 5.0 : (maxCount * 1.2);
    final today = DateTime.now();
    final dayCount = counts.length;

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
              interval: (dayCount / 6).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                final dayOffset = (dayCount - 1) - value.toInt();
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
                  width: 6,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
