import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Initializes the Supabase SDK once at app startup. Call from `main()`
/// before `runApp`.
Future<void> initSupabase() async {
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );
}

/// Exposes the singleton Supabase client to the rest of the app so features
/// depend on this provider instead of reaching for `Supabase.instance` ad hoc.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
