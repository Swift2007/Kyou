// Responsibility: Handles signup, login, and logout with Supabase Auth.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client {
    if (client == null) {
      _client.auth.onAuthStateChange.listen((event) {
        if (event.event == AuthChangeEvent.signedOut) {
          _completedOnboardingThisSession = false;
        }
        _authStateNotifier.value = !_authStateNotifier.value;
      });
    }
  }

  final SupabaseClient _client;

  final _authStateNotifier = ValueNotifier<bool>(false);

  /// Onboarding completion for the current session. Set as soon as the user
  /// finishes onboarding so routing can proceed before the network write.
  bool _completedOnboardingThisSession = false;

  ValueNotifier<bool> get authStateNotifier => _authStateNotifier;

  /// Notify listeners (e.g. router) that auth-related state changed.
  void notifyAuthChanged() {
    _authStateNotifier.value = !_authStateNotifier.value;
  }

  Session? get session => _client.auth.currentSession;

  /// Whether the signed-in user has finished onboarding, either in this
  /// session or in a previous one (persisted in Supabase user metadata).
  ///
  /// Reading this is synchronous, so the router never depends on an async
  /// backend round-trip or a freshly initialized ViewModel.
  bool get hasCompletedOnboarding {
    if (_completedOnboardingThisSession) return true;
    final metadata = _client.auth.currentUser?.userMetadata;
    return metadata?['onboarding_completed'] == true;
  }

  Future<void> completeOnboarding() async {
    // Flip the local flag first: the router must be able to leave onboarding
    // immediately, even if the metadata write is slow or fails.
    _completedOnboardingThisSession = true;
    notifyAuthChanged();
    // Merge with existing metadata: the update endpoint replaces the data
    // object, which would otherwise drop OAuth profile fields.
    final metadata = _client.auth.currentUser?.userMetadata ?? const {};
    await _client.auth.updateUser(
      UserAttributes(data: {...metadata, 'onboarding_completed': true}),
    );
  }

  Future<void> signUp(String email, String password) async {
    _completedOnboardingThisSession = false;
    await _client.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    _completedOnboardingThisSession = false;
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    _completedOnboardingThisSession = false;
  }

  Future<void> signInWithGoogle() async {
    _completedOnboardingThisSession = false;
    await _client.auth.signInWithOAuth(OAuthProvider.google);
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);
