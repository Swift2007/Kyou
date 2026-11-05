# Architecture

- Screen: shows state and calls ViewModel methods. It never uses the API client or a repository directly.
- ViewModel: holds state and logic, calls the repository, and never imports widgets.
- Repository: talks to the API or Supabase and returns typed models, never raw JSON maps.
- Model: a plain Dart class with fromJson/toJson.

## Folder layout

lib/
  main.dart          # entry point (Supabase init, ProviderScope, runApp)
  app.dart           # root MaterialApp with router and theme
  core/
    env.dart         # config from env.json via --dart-define-from-file
    api_client.dart  # configured Dio client with auth bearer token
    router.dart      # go_router routes and auth-state redirects
    theme.dart       # Material 3 color scheme and text theme
  features/
    auth/
      auth_repository.dart   # signup, login, logout with Supabase Auth
      auth_viewmodel.dart    # auth session, loading, error state
      login_screen.dart      # login form
      signup_screen.dart     # signup form
    entries/
      entry.dart             # journal entry model (fromJson/toJson)
      entries_repository.dart# entries API, typed Entry objects
      entries_viewmodel.dart # entries state, load/create/update/delete
      entries_list_screen.dart # entries list, pull-to-refresh, load-more
      entry_editor_screen.dart # create/edit entry form
    profile/
      profile.dart               # user profile model
      profile_repository.dart    # profile API, typed profile objects
      profile_viewmodel.dart     # profile state, load/update
      profile_screen.dart        # current user profile and edit options
      edit_profile_screen.dart   # edit profile form
      preferences_screen.dart    # app preferences and settings
      language_screen.dart       # app language picker
      privacy_security_screen.dart # privacy and security settings

## Config

env.json.example holds empty placeholder keys; env.json (gitignored) holds real values at runtime. Never hardcode keys or URLs in source.
