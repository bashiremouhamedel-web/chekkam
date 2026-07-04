import 'package:supabase_flutter/supabase_flutter.dart';

import '../app/config.dart';

/// Wraps Supabase init so the rest of the app can call
/// [SupabaseService.clientOrNull] without caring whether real credentials
/// have been provided yet.
class SupabaseService {
  SupabaseService._();

  static bool _initialized = false;

  static Future<void> initIfConfigured() async {
    if (!AppConfig.isSupabaseConfigured || _initialized) return;
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseAnonKey,
    );
    _initialized = true;
  }

  static SupabaseClient? get clientOrNull =>
      _initialized ? Supabase.instance.client : null;
}
