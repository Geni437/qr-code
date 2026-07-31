import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/report_data_fetcher.dart';
import '../../data/report_exporters.dart';
import '../../domain/report_type.dart';
import '../controllers/report_providers.dart';

const _analyticsEventTypes = [
  'viewer_open',
  'ar_launch',
  'download',
  'video_play',
  'hotspot_click',
  'screenshot',
];

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  ReportType _type = ReportType.products;
  ReportFormat _format = ReportFormat.csv;
  String? _eventTypeFilter;
  bool _generating = false;

  Future<void> _generate() async {
    setState(() => _generating = true);
    try {
      final client = ref.read(supabaseClientProvider);
      final data = await fetchReportData(client, _type, eventTypeFilter: _eventTypeFilter);

      final bytes = switch (_format) {
        ReportFormat.csv => toCsvBytes(data),
        ReportFormat.excel => toExcelBytes(data),
        ReportFormat.pdf => await toPdfBytes(title: _type.label, data: data),
      };

      await FilePicker.saveFile(
        fileName: '${_type.dbValue}-report.${_format.fileExtension}',
        bytes: bytes,
        type: FileType.custom,
        allowedExtensions: [_format.fileExtension],
      );

      await ref
          .read(reportRepositoryProvider)
          .recordGenerated(
            type: _type,
            format: _format,
            parameters: _eventTypeFilter != null ? {'event_type': _eventTypeFilter} : const {},
          );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Report generated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<ReportType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Report'),
                  items: ReportType.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _type = value!;
                    if (_type != ReportType.analytics) _eventTypeFilter = null;
                  }),
                ),
                const SizedBox(height: 16),
                if (_type == ReportType.analytics)
                  DropdownButtonFormField<String?>(
                    initialValue: _eventTypeFilter,
                    decoration: const InputDecoration(
                      labelText: 'Event type filter (covers Downloads / AR Usage)',
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All events')),
                      ..._analyticsEventTypes.map(
                        (e) => DropdownMenuItem(value: e, child: Text(e)),
                      ),
                    ],
                    onChanged: (value) => setState(() => _eventTypeFilter = value),
                  ),
                if (_type == ReportType.analytics) const SizedBox(height: 16),
                DropdownButtonFormField<ReportFormat>(
                  initialValue: _format,
                  decoration: const InputDecoration(labelText: 'Format'),
                  items: ReportFormat.values
                      .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                      .toList(),
                  onChanged: (value) => setState(() => _format = value!),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _generating ? null : _generate,
                  icon: _generating
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: const Text('Generate & Download'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
