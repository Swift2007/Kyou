// Responsibility: Talks to the backend auth API and returns typed AppUser objects.
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import 'user.dart';

class UserRepository {
  UserRepository(this._dio);

  final Dio _dio;

  Future<AppUser?> getMe() async {
    try {
      final res = await _dio.get('/auth/me');
      return AppUser.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      // Unreachable backend, auth failure, or unexpected response shape.
      return null;
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(dioProvider)),
);
