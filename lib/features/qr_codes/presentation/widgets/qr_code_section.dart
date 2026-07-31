import 'dart:convert';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/config/app_config.dart';
import '../../data/qr_svg_generator.dart';

/// QR code tab embedded in the product edit form. The QR is generated fresh
/// from the product id on every render (nothing is persisted), so there's
/// no "regenerate" action — there's nothing stale to refresh.
class QrCodeSection extends StatelessWidget {
  const QrCodeSection({super.key, required this.productId, required this.productName});

  final String productId;
  final String productName;

  String get _url => '${AppConfig.publicBaseUrl}/view/$productId';

  Future<Uint8List> _pngBytes() async {
    final painter = QrPainter(
      data: _url,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
    );
    final byteData = await painter.toImageData(1024, format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _downloadPng(BuildContext context) async {
    final bytes = await _pngBytes();
    await FilePicker.saveFile(
      fileName: '$productName-qr.png',
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: const ['png'],
    );
  }

  Future<void> _downloadSvg(BuildContext context) async {
    final svg = generateQrSvg(_url);
    await FilePicker.saveFile(
      fileName: '$productName-qr.svg',
      bytes: Uint8List.fromList(utf8.encode(svg)),
      type: FileType.custom,
      allowedExtensions: const ['svg'],
    );
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied')));
  }

  Future<void> _share(BuildContext context) async {
    final bytes = await _pngBytes();
    await SharePlus.instance.share(
      ShareParams(
        text: _url,
        files: [XFile.fromData(bytes, name: '$productName-qr.png', mimeType: 'image/png')],
      ),
    );
  }

  Future<void> _print(BuildContext context) async {
    final bytes = await _pngBytes();
    final image = pw.MemoryImage(bytes);
    await Printing.layoutPdf(
      onLayout: (format) async {
        final doc = pw.Document();
        doc.addPage(
          pw.Page(
            pageFormat: format,
            build: (pdfContext) => pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(image, width: 240, height: 240),
                  pw.SizedBox(height: 16),
                  pw.Text(productName),
                ],
              ),
            ),
          ),
        );
        return doc.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('QR Code', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SelectableText(_url, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(data: _url, size: 220),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () => _downloadPng(context),
                icon: const Icon(Icons.download),
                label: const Text('Download PNG'),
              ),
              OutlinedButton.icon(
                onPressed: () => _downloadSvg(context),
                icon: const Icon(Icons.download),
                label: const Text('Download SVG'),
              ),
              OutlinedButton.icon(
                onPressed: () => _copyLink(context),
                icon: const Icon(Icons.link),
                label: const Text('Copy Link'),
              ),
              OutlinedButton.icon(
                onPressed: () => _share(context),
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
              OutlinedButton.icon(
                onPressed: () => _print(context),
                icon: const Icon(Icons.print),
                label: const Text('Print'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
