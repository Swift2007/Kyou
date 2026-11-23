// Responsibility: Mood model/constants for the journal editor.
// Mood is selected via the FAB/mood picker sheet (no inline "How are you feeling?" row).
import 'package:material_ui/material_ui.dart';

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
