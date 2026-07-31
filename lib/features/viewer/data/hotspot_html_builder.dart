import '../../hotspots/domain/entities/hotspot.dart';

/// A resolved (short-lived signed) URL plus the media `type` it came from,
/// used to decide how to embed it (`<img>`/`<video>`/`<audio>`/link).
typedef ResolvedMedia = ({String type, String url});

String _escapeHtml(String input) => input
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

String _escapeAttr(String input) => _escapeHtml(input).replaceAll("'", '&#39;');

String _mediaHtml(ResolvedMedia media) {
  final url = _escapeAttr(media.url);
  return switch (media.type) {
    'image' => '<img src="$url" style="max-width:100%;border-radius:8px;margin-top:8px;">',
    'video' =>
      '<video src="$url" controls style="max-width:100%;border-radius:8px;margin-top:8px;"></video>',
    'audio' => '<audio src="$url" controls style="width:100%;margin-top:8px;"></audio>',
    _ =>
      '<a href="$url" target="_blank" rel="noopener" style="display:block;margin-top:8px;">Open attachment</a>',
  };
}

/// Builds the `innerModelViewerHtml`/`relatedJs`/`relatedCss` for a set of
/// hotspots: one anchored marker button per hotspot (via model-viewer's
/// `slot="hotspot-*"` + `data-position` mechanism) plus a self-contained
/// detail popover, all driven by plain JS running inside the same page —
/// no Dart/JS bridge involved, so this works identically on every platform
/// `model_viewer_plus` itself supports (Android/iOS/Web), unlike the
/// placement-mode bridge calls which are mobile-only.
({String innerHtml, String relatedJs, String relatedCss}) buildHotspotHtml(
  List<Hotspot> hotspots, {
  Map<String, ResolvedMedia> mediaByHotspotId = const {},
}) {
  final markers = StringBuffer();
  final panels = StringBuffer();

  for (final hotspot in hotspots) {
    final id = hotspot.id;
    markers.writeln(
      '<button slot="hotspot-$id" data-position="${hotspot.positionX} ${hotspot.positionY} ${hotspot.positionZ}" '
      'data-normal="0 1 0" class="app-hotspot-marker" onclick="appShowHotspot(\'$id\')"></button>',
    );

    final media = mediaByHotspotId[id];
    final description = hotspot.description;
    final linkUrl = hotspot.linkUrl;
    final animationName = hotspot.animationName;

    panels.writeln('''
<div id="app-hotspot-panel-$id" class="app-hotspot-panel" style="display:none;">
  <button class="app-hotspot-close" onclick="appHideHotspot('$id')">&times;</button>
  <h3>${_escapeHtml(hotspot.title)}</h3>
  ${description != null ? '<p>${_escapeHtml(description)}</p>' : ''}
  ${media != null ? _mediaHtml(media) : ''}
  ${linkUrl != null ? '<a href="${_escapeAttr(linkUrl)}" target="_blank" rel="noopener" style="display:block;margin-top:8px;">Learn more</a>' : ''}
  ${animationName != null ? '<button class="app-hotspot-play" onclick="appPlayAnimation(\'${_escapeAttr(animationName)}\')">Play animation</button>' : ''}
</div>
''');
  }

  const relatedJs = '''
function appShowHotspot(id) {
  document.querySelectorAll('.app-hotspot-panel').forEach(function (el) { el.style.display = 'none'; });
  var el = document.getElementById('app-hotspot-panel-' + id);
  if (el) el.style.display = 'block';
}
function appHideHotspot(id) {
  var el = document.getElementById('app-hotspot-panel-' + id);
  if (el) el.style.display = 'none';
}
function appPlayAnimation(name) {
  var mv = document.querySelector('model-viewer');
  if (!mv) return;
  mv.animationName = name;
  mv.play();
}
''';

  const relatedCss = '''
.app-hotspot-marker {
  width: 20px; height: 20px; border-radius: 50%;
  background: #2f6fed; border: 2px solid white;
  box-shadow: 0 0 6px rgba(0,0,0,0.4);
  cursor: pointer; padding: 0;
}
.app-hotspot-panel {
  position: absolute; right: 16px; bottom: 16px; max-width: 280px;
  background: white; color: #111; border-radius: 12px; padding: 16px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.3); font-family: sans-serif;
}
.app-hotspot-panel h3 { margin: 0 0 8px 0; font-size: 16px; }
.app-hotspot-panel p { margin: 0; font-size: 14px; }
.app-hotspot-close {
  position: absolute; top: 8px; right: 8px; border: none; background: none;
  font-size: 18px; cursor: pointer; line-height: 1;
}
.app-hotspot-play {
  margin-top: 8px; padding: 8px 12px; border-radius: 8px; border: none;
  background: #2f6fed; color: white; cursor: pointer;
}
''';

  return (innerHtml: '$markers$panels', relatedJs: relatedJs, relatedCss: relatedCss);
}
