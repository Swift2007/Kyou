// Responsibility: Handles signup, login, and logout with Supabase Auth.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/env.dart';

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
    await GoogleSignIn().signOut();
    _completedOnboardingThisSession = false;
  }

  Future<void> signInWithGoogle() async {
    _completedOnboardingThisSession = false;
    final webClientId = Env.googleWebClientId;
    if (webClientId.isEmpty) {
      throw const AuthException('GOOGLE_WEB_CLIENT_ID is not configured.');
    }

    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        scopes: const ['email', 'profile'],
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw const AuthException(
          'Google sign-in failed: missing ID token. Check GOOGLE_WEB_CLIENT_ID '
          'and Android OAuth SHA-1/package (com.journal.journal_app) configuration.',
        );
      }

      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
    } on PlatformException catch (e) {
      final details = [
        e.code,
        if (e.message != null && e.message!.isNotEmpty) e.message!,
        if (e.details != null) '${e.details}',
      ].join(': ');
      if (e.code == 'sign_in_failed') {
        throw AuthException(
          'Google sign-in failed ($details). Usually an Android OAuth client '
          'mismatch: in Google Cloud Console create an Android OAuth client for '
          'package com.journal.journal_app with this app\'s SHA-1 (debug: run '
          'gradlew signingReport in frontend/android), and set the Web client '
          'ID/secret in Supabase Google provider.',
        );
      }
      throw AuthException('Google sign-in error ($details).');
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);
