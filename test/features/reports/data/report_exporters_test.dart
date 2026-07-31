import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_ar_platform/features/reports/data/report_exporters.dart';

void main() {
  const data = (
    headers: ['Name', 'Status'],
    rows: [
      ['Widget A', 'published'],
      ['Widget, B', 'draft'],
    ],
  );

  test('toCsvBytes produces one header line plus one line per row, with quoting', () {
    final bytes = toCsvBytes(data);
    final text = utf8.decode(bytes);
    final lines = text.trim().split('\n');

    expect(lines.length, 3);
    expect(lines[0], 'Name,Status');
    expect(lines[2], contains('"Widget, B"'));
  });

  test('toExcelBytes produces a sheet with header + data rows', () {
    final bytes = toExcelBytes(data);
    expect(bytes, isNotEmpty);

    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables[excel.tables.keys.first]!;
    expect(sheet.maxRows, 3); // header + 2 data rows
  });
}
