import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/hotspot_repository_impl.dart';
import '../../domain/repositories/hotspot_repository.dart';

final hotspotRepositoryProvider = Provider<HotspotRepository>((ref) {
  return HotspotRepositoryImpl(ref.watch(supabaseClientProvider));
});
