import 'package:flutter_test/flutter_test.dart';
import 'package:qr/qr.dart';
import 'package:qr_ar_platform/features/qr_codes/data/qr_svg_generator.dart';

void main() {
  test('generateQrSvg emits one <rect> per dark module plus the background', () {
    const data = 'https://example.com/view/abc123';
    final svg = generateQrSvg(data);

    // Independently recompute the expected dark-module count using the
    // same underlying `qr` package, rather than hardcoding a magic number.
    final qrCode = QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M);
    final qrImage = QrImage(qrCode);
    var expectedDarkModules = 0;
    for (var row = 0; row < qrImage.moduleCount; row++) {
      for (var col = 0; col < qrImage.moduleCount; col++) {
        if (qrImage.isDark(row, col)) expectedDarkModules++;
      }
    }

    final rectCount = RegExp('<rect').allMatches(svg).length;
    // +1 for the white background rect.
    expect(rectCount, expectedDarkModules + 1);
    expect(svg, contains('<svg'));
    expect(svg, contains('</svg>'));
  });
}
