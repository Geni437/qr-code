import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/supabase_service.dart';
import '../../hotspots/domain/entities/hotspot.dart';
import '../../media/presentation/controllers/media_providers.dart';
import 'hotspot_html_builder.dart';

String _bucketForType(String type) => switch (type) {
  'image' => AppConstants.imagesBucket,
  'video' => AppConstants.videosBucket,
  'audio' => AppConstants.audioBucket,
  _ => AppConstants.documentsBucket,
};

/// Resolves each hotspot's attached media (if any) to a short-lived signed
/// URL, keyed by hotspot id, for baking into the hotspot detail popover
/// HTML (see `buildHotspotHtml`). Best-effort: a hotspot whose media can't
/// be resolved just renders without it rather than failing the whole page.
Future<Map<String, ResolvedMedia>> resolveHotspotMedia(
  WidgetRef ref,
  String productId,
  List<Hotspot> hotspots,
) async {
  final mediaIds = hotspots.map((h) => h.mediaId).whereType<String>().toSet();
  if (mediaIds.isEmpty) return {};

  final mediaListResult = await ref.read(mediaRepositoryProvider).listForProduct(productId);
  final mediaList = mediaListResult.match((_) => const [], (list) => list);
  final mediaById = {for (final media in mediaList) media.id: media};

  final result = <String, ResolvedMedia>{};
  final client = ref.read(supabaseClientProvider);

  for (final hotspot in hotspots) {
    final mediaId = hotspot.mediaId;
    if (mediaId == null) continue;
    final media = mediaById[mediaId];
    if (media == null) continue;

    try {
      final url = await client.storage
          .from(_bucketForType(media.type))
          .createSignedUrl(media.filePath, 60 * 10);
      result[hotspot.id] = (type: media.type, url: url);
    } catch (_) {
      // Skip — the popover still renders without the media.
    }
  }

  return result;
}
