// Responsibility: Reads API and Supabase config from --dart-define-from-file.
class Env {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get isConfigured => missingKeys.isEmpty;

  static List<String> get missingKeys => [
        if (apiBaseUrl.isEmpty) 'API_BASE_URL',
        if (supabaseUrl.isEmpty) 'SUPABASE_URL',
        if (supabasePublishableKey.isEmpty) 'SUPABASE_PUBLISHABLE_KEY',
      ];
}

