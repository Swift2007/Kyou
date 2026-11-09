// Responsibility: Holds the auth session and onboarding status for routing and screens.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';
import 'user_repository.dart';

class AuthViewModel extends AsyncNotifier<Session?> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  UserRepository get _userRepo => ref.read(userRepositoryProvider);

  bool _profileRequested = false;

  /// True when the signed-in user still needs to complete onboarding.
  bool get needsOnboarding => !_repo.hasCompletedOnboarding;

  @override
  Future<Session?> build() async {
    final session = _repo.session;
    if (session != null) {
      unawaited(_ensureBackendProfile());
    }
    return session;
  }

  /// Creates the backend profile row on first sign-in. Routing does not depend
  /// on this call, so a backend hiccup cannot strand the user.
  Future<void> _ensureBackendProfile() async {
    if (_profileRequested) return;
    _profileRequested = true;
    try {
      await _userRepo.getMe();
    } catch (_) {
      _profileRequested = false;
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signUp(email, password);
      final session = _repo.session;
      state = AsyncValue.data(session);
      _repo.notifyAuthChanged();
      if (session != null) unawaited(_ensureBackendProfile());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signIn(email, password);
      final session = _repo.session;
      state = AsyncValue.data(session);
      _repo.notifyAuthChanged();
      if (session != null) unawaited(_ensureBackendProfile());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signInWithGoogle();
      final session = _repo.session;
      state = AsyncValue.data(session);
      _repo.notifyAuthChanged();
      if (session != null) unawaited(_ensureBackendProfile());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signOut();
      _profileRequested = false;
      state = const AsyncValue.data(null);
      _repo.notifyAuthChanged();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Marks onboarding complete so the router can leave onboarding, then
  /// persists it to Supabase user metadata for future sessions.
  void completeOnboarding() {
    unawaited(
      _repo.completeOnboarding().catchError((Object _) {
        // Best effort: the session flag keeps this session moving. If saving
        // fails, a later session may show onboarding again.
      }),
    );
  }

  String? get error {
    if (state is AsyncError) {
      return state.error.toString();
    }
    return null;
  }

  bool get isLoading => state is AsyncLoading;
}

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, Session?>(
  AuthViewModel.new,
);
