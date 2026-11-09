// Responsibility: Reads API and Supabase config from --dart-define-from-file.
class Env {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
  // Web OAuth client ID used by native Google Sign-In on Android/iOS.
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );

  static bool get isConfigured => missingKeys.isEmpty;

  static List<String> get missingKeys => [
    if (apiBaseUrl.isEmpty) 'API_BASE_URL',
    if (supabaseUrl.isEmpty) 'SUPABASE_URL',
    if (supabasePublishableKey.isEmpty) 'SUPABASE_PUBLISHABLE_KEY',
  ];
}
