// Responsibility: Renders the create/edit entry form with title, body, and mood selector.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'entry.dart';
import 'entries_viewmodel.dart';

class EntryEditorScreen extends ConsumerStatefulWidget {
  const EntryEditorScreen({super.key, this.entry});

  final Entry? entry;

  @override
  ConsumerState<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

class _EntryEditorScreenState extends ConsumerState<EntryEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  String? _mood;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _bodyController = TextEditingController(text: widget.entry?.body ?? '');
    _mood = widget.entry?.mood;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final viewmodel = ref.read(entriesViewmodelProvider.notifier);
    final body = _bodyController.text;
    final title = _titleController.text;
    final mood = _mood;

    final error = widget.entry == null
        ? await viewmodel.create(title: title, body: body, mood: mood)
        : await viewmodel.updateEntry(
            widget.entry!,
            title: title,
            body: body,
            mood: mood,
          );

    if (!mounted) return;
    setState(() => _saving = false);

    if (error == null) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.entry != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit entry' : 'New entry'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Title (optional)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bodyController,
              minLines: 8,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Write your entry',
                alignLabelWithHint: true,
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Write something first'
                  : null,
            ),
            const SizedBox(height: 20),
            Text('How do you feel?', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final mood in entryMoods)
                  ChoiceChip(
                    label: Text(moodLabel(mood)),
                    selected: _mood == mood,
                    onSelected: (_) =>
                        setState(() => _mood = _mood == mood ? null : mood),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
