// Responsibility: Shows the entries list with pull-to-refresh and load-more.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api_client.dart';
import '../auth/auth_viewmodel.dart';
import 'entry.dart';
import 'entries_viewmodel.dart';

class EntriesListScreen extends ConsumerWidget {
  const EntriesListScreen({super.key});

  Future<void> _loadMore(BuildContext context, WidgetRef ref) async {
    final error = await ref.read(entriesViewmodelProvider.notifier).loadMore();
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    final error = await ref.read(entriesViewmodelProvider.notifier).refresh();
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Entry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final error = await ref
        .read(entriesViewmodelProvider.notifier)
        .delete(entry.id);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEntries = ref.watch(entriesViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/entries/new'),
        icon: const Icon(Icons.add),
        label: const Text('New entry'),
      ),
      body: asyncEntries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _LoadError(
          message: describeApiError(error),
          onRetry: () => ref.read(entriesViewmodelProvider.notifier).refresh(),
        ),
        data: (state) => _EntriesBody(
          state: state,
          onLoadMore: () => _loadMore(context, ref),
          onRefresh: () => _refresh(context, ref),
          onOpen: (entry) => context.push('/entries/edit', extra: entry),
          onDelete: (entry) => _confirmDelete(context, ref, entry),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EntriesBody extends StatelessWidget {
  const _EntriesBody({
    required this.state,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onOpen,
    required this.onDelete,
  });

  final EntriesState state;
  final Future<void> Function() onLoadMore;
  final Future<void> Function() onRefresh;
  final ValueChanged<Entry> onOpen;
  final ValueChanged<Entry> onDelete;

  @override
  Widget build(BuildContext context) {
    if (state.items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Icon(Icons.menu_book_outlined, size: 56),
            SizedBox(height: 16),
            Text('No entries yet', textAlign: TextAlign.center),
            SizedBox(height: 4),
            Text(
              'Tap "New entry" to write your first one.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: state.loadingMore
                  ? const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : TextButton(
                      onPressed: onLoadMore,
                      child: const Text('Load more'),
                    ),
            );
          }
          return _EntryTile(
            entry: state.items[index],
            onOpen: () => onOpen(state.items[index]),
            onDelete: () => onDelete(state.items[index]),
          );
        },
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.entry,
    required this.onOpen,
    required this.onDelete,
  });

  final Entry entry;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = entry.createdAt.toLocal();
    final date = MaterialLocalizations.of(context).formatMediumDate(local);
    final time = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(local));

    return ListTile(
      title: Text(
        entry.title ?? 'Untitled',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            [
              if (entry.mood != null) moodLabel(entry.mood!),
              date,
              time,
            ].join(' · '),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        tooltip: 'Delete entry',
        icon: Icon(Icons.delete_outline, color: theme.colorScheme.outline),
        onPressed: onDelete,
      ),
      onTap: onOpen,
    );
  }
}
