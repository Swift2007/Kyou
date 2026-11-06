// Responsibility: Provides a configured Dio client with auth and readable API errors.
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'env.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token =
            Supabase.instance.client.auth.currentSession?.accessToken;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );

  return dio;
});

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;

  factory ApiException.fromDio(DioException error) {
    return ApiException(
      describeApiError(error),
      statusCode: error.response?.statusCode,
    );
  }
}

String describeApiError(Object error) {
  if (error is ApiException) return error.message;
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['detail'] is String) {
      final detail = (data['detail'] as String).trim();
      if (detail.isNotEmpty) return detail;
    }
    if (data is Map && data['detail'] is List) {
      return 'Please check the information you entered and try again.';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return "Couldn't reach the server. Check your connection and try again.";
      case DioExceptionType.badCertificate:
        return "Couldn't establish a secure connection.";
      case DioExceptionType.cancel:
        return 'The request was cancelled.';
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 401) return 'Your session has expired. Please sign in again.';
        if (status == 403) return "You don't have access to do that.";
        if (status == 404) return 'The requested item could not be found.';
        if (status != null && status >= 500) {
          return 'The server had a problem. Please try again.';
        }
        return 'Something went wrong. Please try again.';
      case DioExceptionType.unknown:
        return "Couldn't reach the server. Check your connection and try again.";
      // ignore: deprecated_member_use
      default:
        return 'Something went wrong. Please try again.';
    }
  }
  return 'Something went wrong. Please try again.';
}



