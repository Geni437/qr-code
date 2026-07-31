import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Downscales an image to a max of [maxEdge] on its longest side and
/// re-encodes as JPEG at [quality], before the bytes ever reach Supabase
/// Storage. Images already within [maxEdge] are returned unchanged — no
/// point re-encoding (and potentially losing PNG transparency) for
/// something that's already small.
///
/// Returns the original bytes unchanged if decoding fails (unsupported
/// format, corrupt file) — compression is a nice-to-have, not something
/// that should block an otherwise-valid upload.
Uint8List compressImageIfNeeded(Uint8List bytes, {int maxEdge = 1600, int quality = 85}) {
  final image = img.decodeImage(bytes);
  if (image == null) return bytes;

  final longestEdge = image.width > image.height ? image.width : image.height;
  if (longestEdge <= maxEdge) return bytes;

  final resized = image.width > image.height
      ? img.copyResize(image, width: maxEdge)
      : img.copyResize(image, height: maxEdge);

  return img.encodeJpg(resized, quality: quality);
}
