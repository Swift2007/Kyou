// Responsibility: Tags row for journal editor — #tag chips (add via speed dial).
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorTags extends StatelessWidget {
  final List<String> tags;
  final ValueChanged<String>? onRemoveTag;

  const JournalEditorTags({super.key, required this.tags, this.onRemoveTag});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final tag in tags)
          _TagChip(
            label: '#$tag',
            onTap: onRemoveTag == null ? null : () => onRemoveTag!(tag),
          ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _TagChip({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.ink, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'IBM Plex Mono',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}
