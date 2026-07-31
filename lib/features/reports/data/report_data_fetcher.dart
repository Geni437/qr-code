import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../domain/report_type.dart';

typedef ReportData = ({List<String> headers, List<List<String>> rows});

String _s(dynamic value) => value?.toString() ?? '';

// Row-shaping kept as pure functions (raw Postgrest rows in, ReportData
// out) separate from the fetch itself, so the shaping logic — the part
// most likely to have an off-by-one or a wrong column name — is testable
// with plain synthetic maps, without mocking Postgrest's builder chain.

ReportData shapeProductRows(List<Map<String, dynamic>> rows) => (
  headers: const ['Name', 'Slug', 'Manufacturer', 'Model Number', 'Status', 'Created At'],
  rows: rows
      .map(
        (r) => [
          _s(r['name']),
          _s(r['slug']),
          _s(r['manufacturer']),
          _s(r['model_number']),
          _s(r['status']),
          _s(r['created_at']),
        ],
      )
      .toList(),
);

ReportData shapeCategoryRows(List<Map<String, dynamic>> rows) => (
  headers: const ['Name', 'Slug', 'Status', 'Created At'],
  rows: rows
      .map((r) => [_s(r['name']), _s(r['slug']), _s(r['status']), _s(r['created_at'])])
      .toList(),
);

ReportData shapeModelRows(List<Map<String, dynamic>> rows) => (
  headers: const ['Product ID', 'Format', 'Version', 'Size (bytes)', 'Status', 'Created At'],
  rows: rows
      .map(
        (r) => [
          _s(r['product_id']),
          _s(r['format']),
          _s(r['version']),
          _s(r['file_size_bytes']),
          _s(r['status']),
          _s(r['created_at']),
        ],
      )
      .toList(),
);

ReportData shapeScanRows(List<Map<String, dynamic>> rows) => (
  headers: const ['Product ID', 'Device Type', 'OS', 'Language', 'Scanned At'],
  rows: rows
      .map(
        (r) => [
          _s(r['product_id']),
          _s(r['device_type']),
          _s(r['os']),
          _s(r['language']),
          _s(r['scanned_at']),
        ],
      )
      .toList(),
);

ReportData shapeAnalyticsRows(List<Map<String, dynamic>> rows) => (
  headers: const ['Product ID', 'Event Type', 'Device Type', 'Language', 'Occurred At'],
  rows: rows
      .map(
        (r) => [
          _s(r['product_id']),
          _s(r['event_type']),
          _s(r['device_type']),
          _s(r['language']),
          _s(r['occurred_at']),
        ],
      )
      .toList(),
);

ReportData shapeStorageRows({
  required List<Map<String, dynamic>> modelRows,
  required List<Map<String, dynamic>> mediaRows,
}) => (
  headers: const ['Kind', 'Product ID', 'File Path', 'Size (bytes)'],
  rows: [
    ...modelRows.map(
      (r) => ['model', _s(r['product_id']), _s(r['file_path']), _s(r['file_size_bytes'])],
    ),
    ...mediaRows.map(
      (r) => [_s(r['type']), _s(r['product_id']), _s(r['file_path']), _s(r['file_size_bytes'])],
    ),
  ],
);

/// One data-fetch per report type, feeding the same three generic
/// exporters (`report_exporters.dart`) — the spec's 8-report-types × 3-
/// formats matrix doesn't need 24 bespoke generators, just this fan-out
/// point plus format-agnostic (headers, rows) tables.
Future<ReportData> fetchReportData(
  SupabaseClient client,
  ReportType type, {
  String? eventTypeFilter,
}) async {
  switch (type) {
    case ReportType.products:
      final rows =
          await client
                  .from(SupabaseTables.products)
                  .select('name, slug, manufacturer, model_number, status, created_at')
                  .eq('is_deleted', false)
                  .order('created_at', ascending: false)
              as List;
      return shapeProductRows(rows.cast<Map<String, dynamic>>());

    case ReportType.categories:
      final rows =
          await client
                  .from(SupabaseTables.categories)
                  .select('name, slug, status, created_at')
                  .eq('is_deleted', false)
                  .order('created_at', ascending: false)
              as List;
      return shapeCategoryRows(rows.cast<Map<String, dynamic>>());

    case ReportType.models:
      final rows =
          await client
                  .from(SupabaseTables.models)
                  .select('product_id, format, version, file_size_bytes, status, created_at')
                  .eq('is_deleted', false)
                  .order('created_at', ascending: false)
              as List;
      return shapeModelRows(rows.cast<Map<String, dynamic>>());

    case ReportType.scans:
      final rows =
          await client
                  .from(SupabaseTables.scans)
                  .select('product_id, device_type, os, language, scanned_at')
                  .order('scanned_at', ascending: false)
                  .limit(5000)
              as List;
      return shapeScanRows(rows.cast<Map<String, dynamic>>());

    case ReportType.analytics:
      var query = client.from(SupabaseTables.analytics).select(
        'product_id, event_type, device_type, language, occurred_at',
      );
      if (eventTypeFilter != null) {
        query = query.eq('event_type', eventTypeFilter);
      }
      final rows = await query.order('occurred_at', ascending: false).limit(5000) as List;
      return shapeAnalyticsRows(rows.cast<Map<String, dynamic>>());

    case ReportType.storage:
      final modelRows =
          await client
                  .from(SupabaseTables.models)
                  .select('product_id, file_path, file_size_bytes')
                  .eq('is_deleted', false)
              as List;
      final mediaRows =
          await client
                  .from(SupabaseTables.media)
                  .select('product_id, file_path, file_size_bytes, type')
                  .eq('is_deleted', false)
              as List;
      return shapeStorageRows(
        modelRows: modelRows.cast<Map<String, dynamic>>(),
        mediaRows: mediaRows.cast<Map<String, dynamic>>(),
      );
  }
}
