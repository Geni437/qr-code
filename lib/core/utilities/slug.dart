/// Turns a display name into a URL-safe slug, e.g. "Heavy Duty Pump #3"
/// -> "heavy-duty-pump-3". Used for both product and category `slug`
/// columns; the DB's unique constraint is still the source of truth if two
/// names collide (callers should surface that error, not pre-check it here).
String slugify(String input) {
  final lower = input.trim().toLowerCase();
  final withDashes = lower.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  return withDashes.replaceAll(RegExp(r'^-+|-+$'), '');
}
