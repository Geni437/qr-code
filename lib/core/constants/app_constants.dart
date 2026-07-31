/// App-wide constant values that aren't environment-specific.
class AppConstants {
  const AppConstants._();

  static const String appName = 'QR AR Platform';

  // Storage bucket names (must match buckets created in Supabase Storage).
  static const String modelsBucket = 'models';
  static const String imagesBucket = 'images';
  static const String videosBucket = 'videos';
  static const String documentsBucket = 'documents';
  static const String audioBucket = 'audio';
  static const String thumbnailsBucket = 'thumbnails';
  static const String qrCodesBucket = 'qr_codes';

  /// Placeholder warning threshold for the `storage_limit` notification —
  /// Supabase's free tier is ~1GB; adjust to your actual plan's limit.
  static const int storageWarningThresholdBytes = 800 * 1024 * 1024;
}

/// Table names, kept in one place so repositories never hardcode strings.
class SupabaseTables {
  const SupabaseTables._();

  static const String profiles = 'profiles';
  static const String roles = 'roles';
  static const String products = 'products';
  static const String categories = 'categories';
  static const String models = 'models';
  static const String hotspots = 'hotspots';
  static const String media = 'media';
  static const String analytics = 'analytics';
  static const String scans = 'scans';
  static const String reports = 'reports';
  static const String settings = 'settings';
  static const String logs = 'logs';
  static const String notifications = 'notifications';
}

/// Role slugs as stored in the `roles` table.
class AppRoles {
  const AppRoles._();

  static const String superAdmin = 'super_admin';
  static const String administrator = 'administrator';
}
