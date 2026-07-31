import 'package:qr/qr.dart';

/// Builds a standalone SVG string for [data] — one `<rect>` per dark
/// module. `qr_flutter` (used for the on-screen preview and PNG export)
/// has no SVG export of its own, so this reads the same underlying `qr`
/// package matrix directly.
String generateQrSvg(String data, {int moduleSize = 8}) {
  final qrCode = QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M);
  final qrImage = QrImage(qrCode);
  final size = qrImage.moduleCount * moduleSize;

  final rects = StringBuffer();
  for (var row = 0; row < qrImage.moduleCount; row++) {
    for (var col = 0; col < qrImage.moduleCount; col++) {
      if (qrImage.isDark(row, col)) {
        final x = col * moduleSize;
        final y = row * moduleSize;
        rects.writeln('<rect x="$x" y="$y" width="$moduleSize" height="$moduleSize" fill="black"/>');
      }
    }
  }

  return '''
<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" viewBox="0 0 $size $size">
<rect width="$size" height="$size" fill="white"/>
$rects</svg>
''';
}
