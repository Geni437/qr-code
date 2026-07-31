/// Builds the JS that lets the hotspot popover (and the model-viewer
/// element itself) record analytics events directly, without a Dart/JS
/// bridge. The `analytics` table already has an `insert` policy open to
/// everyone (`analytics_public_insert`, from `0001_init_schema.sql`), so a
/// plain `fetch()` POST using the anon key — safe to embed, it's already
/// public in `.env`, constrained by RLS rather than secrecy — works
/// identically on every platform `model_viewer_plus` supports, unlike the
/// placement bridge which is mobile-only.
///
/// Defines `window.appTrackEvent(eventType, metadata)`, and (when
/// [includeArStatusListener] is set) wires `<model-viewer>`'s own
/// `ar-status` DOM event so a real "AR session started" fires `ar_launch`
/// — not just "the AR button rendered".
String buildAnalyticsTrackingJs({
  required String supabaseUrl,
  required String supabaseAnonKey,
  required String productId,
  bool includeArStatusListener = false,
}) {
  final trackFunction =
      '''
function appTrackEvent(eventType, metadata) {
  try {
    fetch('$supabaseUrl/rest/v1/analytics', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': '$supabaseAnonKey',
        'Authorization': 'Bearer $supabaseAnonKey',
        'Prefer': 'return=minimal'
      },
      body: JSON.stringify({
        product_id: '$productId',
        event_type: eventType,
        metadata: metadata || {},
        language: navigator.language
      })
    }).catch(function () {});
  } catch (e) {}
}
''';

  final arListener = includeArStatusListener
      ? '''
(function () {
  var mv = document.querySelector('model-viewer');
  if (!mv) return;
  mv.addEventListener('ar-status', function (event) {
    if (event.detail && event.detail.status === 'session-started') {
      appTrackEvent('ar_launch', {});
    }
  });
})();
'''
      : '';

  return '$trackFunction$arListener';
}
