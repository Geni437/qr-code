import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../../domain/repositories/scan_repository.dart';

final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  return ScanRepositoryImpl(ref.watch(supabaseClientProvider));
});
