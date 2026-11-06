# Architecture

## Rules
- **Screen:** shows state and calls ViewModel methods. It never uses the API client or a repository directly.
- **ViewModel:** holds state and logic, calls the repository, and never imports widgets.
- **Repository:** talks to the API or Supabase and returns typed models, never raw JSON maps.
- **Model:** a plain Dart class with `fromJson` and `toJson`.
- **Widgets (placement):**
  - A widget used by two or more features goes in `core/widgets/`.
  - A widget used by only one feature goes in that feature's `widgets/` folder.
  - Screens stay at the top level of their feature folder, except the onboarding steps, which live in `onboarding/steps/`.
- **Features:** flat folders. A new feature gets its own folder under `lib/features/` only when it is built.

## Final `lib/` tree
```text
lib/
  main.dart
  app.dart
  core/
    env.dart
    api_client.dart
    router.dart
    theme.dart
    validators.dart
    widgets/
      app_button.dart
      app_text_field.dart
      app_chip.dart
      sticker_badge.dart
      app_toast.dart
      loading_view.dart
  features/
    auth/
      auth_repository.dart
      auth_viewmodel.dart
      login_screen.dart
      signup_screen.dart
    onboarding/
      onboarding_data.dart
      onboarding_repository.dart
      onboarding_viewmodel.dart
      onboarding_flow_screen.dart
      steps/
        welcome_step.dart
        name_step.dart
        birthday_step.dart
        location_step.dart
        goals_step.dart
        rhythm_step.dart
        topics_step.dart
        summary_step.dart
    entries/
      entry.dart
      entries_repository.dart
      entries_viewmodel.dart
      entries_list_screen.dart
      entry_editor_screen.dart
      widgets/
        entry_card.dart
        mood_selector.dart
        tool_dial.dart
        attachment_tray.dart
    profile/
      profile.dart
      profile_repository.dart
      profile_viewmodel.dart
      profile_screen.dart
      edit_profile_screen.dart
      preferences_screen.dart
      language_screen.dart
      privacy_security_screen.dart
      widgets/
        avatar_picker.dart
```
