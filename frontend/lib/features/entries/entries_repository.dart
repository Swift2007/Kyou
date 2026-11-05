// Responsibility: Talks to the entries API and returns typed Entry objects.
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import 'entry.dart';

class EntriesPage {
  const EntriesPage({
    required this.items,
    required this.hasMore,
    required this.nextOffset,
  });

  final List<Entry> items;

  final bool hasMore;

  final int nextOffset;
}

class EntriesRepository {
  EntriesRepository(this._dio);

  final Dio _dio;

  Future<EntriesPage> fetchPage({int offset = 0, int limit = 20}) async {
    try {
      final res = await _dio.get(
        '/entries/',
        queryParameters: {'limit': limit + 1, 'offset': offset},
      );
      final raw = res.data as List<dynamic>;
      final items = raw
          .map((json) => Entry.fromJson(json as Map<String, dynamic>))
          .toList();
      return EntriesPage(
        items: items,
        hasMore: items.length > limit,
        nextOffset: offset + items.length,
      );
    } on DioException catch (e) {
      throw EntriesException(describeApiError(e));
    }
  }

  Future<Entry> create({
    required String title,
    required String body,
    String? mood,
  }) async {
    try {
      final res = await _dio.post(
        '/entries/',
        data: {'title': title, 'body': body, 'mood': mood},
      );
      return Entry.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw EntriesException(describeApiError(e));
    }
  }

  Future<Entry> updateEntry(
    String id, {
    required String title,
    required String body,
    String? mood,
  }) async {
    try {
      final res = await _dio.put(
        '/entries/$id',
        data: {'title': title, 'body': body, 'mood': mood},
      );
      return Entry.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw EntriesException(describeApiError(e));
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete('/entries/$id');
    } on DioException catch (e) {
      throw EntriesException(describeApiError(e));
    }
  }
}

class EntriesException implements Exception {
  EntriesException(this.message);
  final String message;
}

final entriesRepositoryProvider = Provider<EntriesRepository>(
  (ref) => EntriesRepository(ref.watch(dioProvider)),
);
