import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'report_data_fetcher.dart';

String _csvField(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

Uint8List toCsvBytes(ReportData data) {
  final buffer = StringBuffer()
    ..writeln(data.headers.map(_csvField).join(','));
  for (final row in data.rows) {
    buffer.writeln(row.map(_csvField).join(','));
  }
  return Uint8List.fromList(utf8.encode(buffer.toString()));
}

Uint8List toExcelBytes(ReportData data) {
  final excel = Excel.createExcel();
  final sheetName = excel.getDefaultSheet()!;
  final sheet = excel[sheetName];

  sheet.appendRow(data.headers.map((h) => TextCellValue(h)).toList());
  for (final row in data.rows) {
    sheet.appendRow(row.map((cell) => TextCellValue(cell)).toList());
  }

  final bytes = excel.save();
  return Uint8List.fromList(bytes ?? []);
}

Future<Uint8List> toPdfBytes({required String title, required ReportData data}) async {
  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      header: (context) => pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      build: (context) => [
        pw.TableHelper.fromTextArray(
          headers: data.headers,
          data: data.rows,
          cellStyle: const pw.TextStyle(fontSize: 8),
          headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ],
    ),
  );
  return doc.save();
}
