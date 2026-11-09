// Responsibility: Holds entries state and exposes load/create/update/delete methods.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import 'entries_repository.dart';
import 'entry.dart';

class EntriesState {
  const EntriesState({
    this.items = const [],
    this.hasMore = false,
    this.nextOffset = 0,
    this.loadingMore = false,
  });

  final List<Entry> items;
  final bool hasMore;
  final int nextOffset;
  final bool loadingMore;

  EntriesState copyWith({
    List<Entry>? items,
    bool? hasMore,
    int? nextOffset,
    bool? loadingMore,
  }) => EntriesState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    nextOffset: nextOffset ?? this.nextOffset,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}

class EntriesViewmodel extends AsyncNotifier<EntriesState> {
  EntriesRepository get _repo => ref.read(entriesRepositoryProvider);

  @override
  Future<EntriesState> build() async {
    final page = await _repo.fetchPage();
    return EntriesState(
      items: page.items,
      hasMore: page.hasMore,
      nextOffset: page.nextOffset,
    );
  }

  Future<String?> refresh() async {
    try {
      final page = await _repo.fetchPage();
      state = AsyncData(
        EntriesState(
          items: page.items,
          hasMore: page.hasMore,
          nextOffset: page.nextOffset,
        ),
      );
      return null;
    } catch (e) {
      return describeApiError(e);
    }
  }

  Future<String?> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) {
      return null;
    }

    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final page = await _repo.fetchPage(offset: current.nextOffset);
      state = AsyncData(
        EntriesState(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          nextOffset: page.nextOffset,
        ),
      );
      return null;
    } catch (e) {
      state = AsyncData(current.copyWith(loadingMore: false));
      return describeApiError(e);
    }
  }

  Future<String?> create({
    required String title,
    required String body,
    String? mood,
  }) async {
    try {
      final entry = await _repo.create(title: title, body: body, mood: mood);
      final current = state.value;
      if (current == null) {
        await refresh();
      } else {
        state = AsyncData(current.copyWith(items: [entry, ...current.items]));
      }
      return null;
    } catch (e) {
      return describeApiError(e);
    }
  }

  Future<String?> updateEntry(
    Entry entry, {
    required String title,
    required String body,
    String? mood,
  }) async {
    try {
      final updated = await _repo.updateEntry(
        entry.id,
        title: title,
        body: body,
        mood: mood,
      );
      final current = state.value;
      if (current != null) {
        state = AsyncData(
          current.copyWith(
            items: [
              for (final e in current.items) e.id == updated.id ? updated : e,
            ],
          ),
        );
      }
      return null;
    } catch (e) {
      return describeApiError(e);
    }
  }

  Future<String?> delete(String id) async {
    try {
      await _repo.delete(id);
      final current = state.value;
      if (current != null) {
        state = AsyncData(
          current.copyWith(
            items: current.items.where((e) => e.id != id).toList(),
          ),
        );
      }
      return null;
    } catch (e) {
      return describeApiError(e);
    }
  }
}

final entriesViewmodelProvider =
    AsyncNotifierProvider<EntriesViewmodel, EntriesState>(EntriesViewmodel.new);
