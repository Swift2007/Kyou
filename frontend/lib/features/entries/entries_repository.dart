// Responsibility: Talks to the entries API and returns typed Entry objects.
// ignore_for_file: use_null_aware_elements
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import 'entry.dart';

class EntriesPage {
  const EntriesPage({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  final List<Entry> items;
  final int total;
  final int limit;
  final int offset;

  bool get hasMore => offset + items.length < total;
  int get nextOffset => offset + items.length;
}

class EntriesRepository {
  EntriesRepository(this._dio);

  final Dio _dio;

  Future<EntriesPage> fetchPage({int offset = 0, int limit = 20}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/entries',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = res.data ?? const <String, dynamic>{};
      final rawItems = data['items'] as List<dynamic>? ?? const [];
      final items = rawItems
          .map((json) => Entry.fromJson(json as Map<String, dynamic>))
          .toList(growable: false);
      return EntriesPage(
        items: items,
        total: (data['total'] as num?)?.toInt() ?? items.length,
        limit: (data['limit'] as num?)?.toInt() ?? limit,
        offset: (data['offset'] as num?)?.toInt() ?? offset,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Entry> getEntry(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/entries/$id');
      return Entry.fromJson(res.data ?? const <String, dynamic>{});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Entry> create({
    String? title,
    required String body,
    String? mood,
    String? parentEntryId,
  }) async {
    try {
      final trimmedTitle = title?.trim();
      final payload = <String, dynamic>{
        'body': body,
        if (trimmedTitle != null && trimmedTitle.isNotEmpty)
          'title': trimmedTitle,
        if (mood != null && mood.isNotEmpty) 'mood': mood,
        if (parentEntryId != null && parentEntryId.isNotEmpty)
          'parent_entry_id': parentEntryId,
      };
      final res = await _dio.post<Map<String, dynamic>>(
        '/entries',
        data: payload,
      );
      return Entry.fromJson(res.data ?? const <String, dynamic>{});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Entry> updateEntry(
    String id, {
    String? title,
    String? body,
    String? mood,
  }) async {
    try {
      final payload = <String, dynamic>{
        if (title != null) 'title': title.trim().isEmpty ? null : title.trim(),
        if (body != null) 'body': body,
        if (mood != null) 'mood': mood,
      };
      final res = await _dio.patch<Map<String, dynamic>>(
        '/entries/$id',
        data: payload,
      );
      return Entry.fromJson(res.data ?? const <String, dynamic>{});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete<void>('/entries/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final entriesRepositoryProvider = Provider<EntriesRepository>(
  (ref) => EntriesRepository(ref.watch(dioProvider)),
);
