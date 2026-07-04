/// Compile-time app configuration, provided via --dart-define at build/run time.
///
/// Nothing here requires real values to run the app — every service that
/// reads these checks `isConfigured` first and degrades gracefully (an
/// in-app banner explaining what's missing) rather than crashing. This is
/// what lets the whole app run against mock/local data today and switch to
/// real Supabase + backend endpoints later just by passing --dart-define
/// flags, with no code changes.
///
/// Example:
/// flutter run \
///   --dart-define=API_BASE_URL=https://your-backend.example.com \
///   --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJ...
class AppConfig {
  AppConfig._();

  /// Chekkam backend base URL (the Next.js API in ../chekkam-backend).
  /// Defaults to the Android emulator's alias for the host machine's
  /// localhost; override for iOS simulator (use http://localhost:3000) or a
  /// physical device (use your machine's LAN IP).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
