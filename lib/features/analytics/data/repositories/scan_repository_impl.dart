import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  ScanRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<Unit>> recordScan({required String productId}) async {
    try {
      await _client.from(SupabaseTables.scans).insert({
        'product_id': productId,
        'device_type': _deviceType,
        'os': _os,
        'language': _language,
      });
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Browser and country/city are deliberately left unset here: browser
  // detection needs user-agent parsing (js interop on web) and
  // country/city needs IP geolocation (an Edge Function) — both are Phase 6
  // (Analytics) work, not this phase's scan-recording seam.

  String get _deviceType {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return 'mobile';
      default:
        return 'desktop';
    }
  }

  String get _os {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name;
  }

  String get _language => PlatformDispatcher.instance.locale.toLanguageTag();
}
