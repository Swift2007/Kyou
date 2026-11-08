// Responsibility: Handles signup, login, and logout with Supabase Auth.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository([SupabaseClient? client]) : _client = client ?? Supabase.instance.client {
    if (client == null) {
      _client.auth.onAuthStateChange.listen((_) {
        _authStateNotifier.value = !_authStateNotifier.value;
      });
    }
  }

  final SupabaseClient _client;

  final _authStateNotifier = ValueNotifier<bool>(false);

  ValueNotifier<bool> get authStateNotifier => _authStateNotifier;

  Session? get session => _client.auth.currentSession;

  Future<void> signUp(String email, String password) async {
    await _client.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(OAuthProvider.google);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());
