// Responsibility: Holds auth session, loading, and error state for the auth screens.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';

class AuthViewModel extends Notifier<AsyncValue<Session?>> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AsyncValue<Session?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signUp(email, password);
      state = AsyncValue.data(_repo.session);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signIn(email, password);
      state = AsyncValue.data(_repo.session);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signOut();
      state = const AsyncValue.data(null);
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
    NotifierProvider<AuthViewModel, AsyncValue<Session?>>(AuthViewModel.new);
