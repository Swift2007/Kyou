// Responsibility: Holds auth session, loading, error state, and new-user flag for the auth screens.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';
import 'user_repository.dart';

class AuthViewModel extends AsyncNotifier<Session?> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  UserRepository get _userRepo => ref.read(userRepositoryProvider);

  bool _isNewUser = false;

  /// True when the current session belongs to a user who just signed up
  /// (email or Google) and has not yet completed onboarding.
  bool get isNewUser => _isNewUser;

  @override
  Future<Session?> build() async {
    final session = _repo.session;
    if (session != null) {
      await _checkNewUser(session.user.id, session.user.email ?? '');
    }
    return session;
  }

  Future<void> _checkNewUser(String userId, String email) async {
    try {
      final user = await _userRepo.getMe();
      if (user != null) {
        _isNewUser = user.isNewUser;
      }
    } catch (_) {
      // Backend unreachable; treat as existing user to avoid blocking sign-in.
      _isNewUser = false;
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signUp(email, password);
      state = AsyncValue.data(_repo.session);
      if (_repo.session != null) {
        await _checkNewUser(_repo.session!.user.id, _repo.session!.user.email ?? '');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signIn(email, password);
      state = AsyncValue.data(_repo.session);
      if (_repo.session != null) {
        await _checkNewUser(_repo.session!.user.id, _repo.session!.user.email ?? '');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signOut();
      _isNewUser = false;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signInWithGoogle();
      state = AsyncValue.data(_repo.session);
      if (_repo.session != null) {
        await _checkNewUser(_repo.session!.user.id, _repo.session!.user.email ?? '');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  String? get error {
    if (state is AsyncError) {
      return state.error.toString();
    }
    return null;
  }

  bool get isLoading => state is AsyncLoading;
}

final authViewModelProvider =
    AsyncNotifierProvider<AuthViewModel, Session?>(AuthViewModel.new);
