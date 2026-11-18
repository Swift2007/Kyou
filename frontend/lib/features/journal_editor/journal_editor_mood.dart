// Responsibility: Mood model/constants + inline "How are you feeling?" quick-pick row
// (OpenPencil-style text chips) for the journal editor paper.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

enum JournalMoodLevel {
  veryUnpleasant,
  unpleasant,
  neutral,
  pleasant,
  veryPleasant,
}

extension JournalMoodLevelX on JournalMoodLevel {
  String get inlineLabel {
    switch (this) {
      case JournalMoodLevel.veryUnpleasant:
        return 'Rough';
      case JournalMoodLevel.unpleasant:
        return 'Low';
      case JournalMoodLevel.neutral:
        return 'Okay';
      case JournalMoodLevel.pleasant:
        return 'Good';
      case JournalMoodLevel.veryPleasant:
        return 'Great';
    }
  }

  String get sheetLabel {
    switch (this) {
      case JournalMoodLevel.veryUnpleasant:
        return 'Very Unpleasant';
      case JournalMoodLevel.unpleasant:
        return 'Unpleasant';
      case JournalMoodLevel.neutral:
        return 'Neutral';
      case JournalMoodLevel.pleasant:
        return 'Pleasant';
      case JournalMoodLevel.veryPleasant:
        return 'Very Pleasant';
    }
  }

  IconData get icon {
    switch (this) {
      case JournalMoodLevel.veryUnpleasant:
        return Icons.sentiment_very_dissatisfied_outlined;
      case JournalMoodLevel.unpleasant:
        return Icons.sentiment_dissatisfied_outlined;
      case JournalMoodLevel.neutral:
        return Icons.sentiment_neutral_outlined;
      case JournalMoodLevel.pleasant:
        return Icons.sentiment_satisfied_outlined;
      case JournalMoodLevel.veryPleasant:
        return Icons.sentiment_very_satisfied_outlined;
    }
  }

  static JournalMoodLevel? fromInlineLabel(String? label) {
    for (final level in JournalMoodLevel.values) {
      if (level.inlineLabel == label) return level;
    }
    return null;
  }
}

class JournalEditorMoodRow extends StatelessWidget {
  final JournalMoodLevel? selectedMood;
  final ValueChanged<JournalMoodLevel?> onSelected;

  const JournalEditorMoodRow({
    super.key,
    required this.selectedMood,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // OpenPencil inline quick-pick order (as shown in editor states)
    const moods = <JournalMoodLevel>[
      JournalMoodLevel.veryPleasant, // Great
      JournalMoodLevel.pleasant, // Good
      JournalMoodLevel.neutral, // Okay
      JournalMoodLevel.unpleasant, // Low
      JournalMoodLevel.veryUnpleasant, // Rough
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final mood in moods)
              _InlineMoodChip(
                label: mood.inlineLabel,
                selected: mood == selectedMood,
                onTap: () => onSelected(mood == selectedMood ? null : mood),
              ),
          ],
        ),
      ],
    );
  }
}

class _InlineMoodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _InlineMoodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.accent : AppColors.surface;
    final fg = selected ? AppColors.surface : AppColors.ink;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
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
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }
}
