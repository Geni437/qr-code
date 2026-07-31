/// Matches the `type` check constraint on `public.reports`.
enum ReportType {
  products,
  categories,
  models,
  scans,
  analytics,
  storage;

  String get label => switch (this) {
    ReportType.products => 'Products',
    ReportType.categories => 'Categories',
    ReportType.models => 'Models',
    ReportType.scans => 'Scans',
    ReportType.analytics => 'Analytics',
    ReportType.storage => 'Storage Usage',
  };

  /// Value stored in `reports.type`. `storage` maps to `'storage'`, which
  /// is in the table's check constraint from `0001_init_schema.sql`.
  String get dbValue => name;
}

enum ReportFormat {
  csv,
  excel,
  pdf;

  String get label => switch (this) {
    ReportFormat.csv => 'CSV',
    ReportFormat.excel => 'Excel',
    ReportFormat.pdf => 'PDF',
  };

  String get fileExtension => switch (this) {
    ReportFormat.csv => 'csv',
    ReportFormat.excel => 'xlsx',
    ReportFormat.pdf => 'pdf',
  };
}
