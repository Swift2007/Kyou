// Responsibility: Mood picker bottom sheet — Apple Journal–style icon moods
// with stepped intensity (5 steps), synced back to editor.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import 'journal_editor_mood.dart';

class MoodPickerResult {
  final JournalMoodLevel mood;
  final int intensity; // 1..5

  const MoodPickerResult({required this.mood, required this.intensity});
}

Future<MoodPickerResult?> showJournalMoodPickerSheet(
  BuildContext context, {
  JournalMoodLevel? initialMood,
  int initialIntensity = 3,
}) {
  return showModalBottomSheet<MoodPickerResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.ink.withValues(alpha: 0.18),
    builder: (context) => _MoodPickerSheet(
      initialMood: initialMood,
      initialIntensity: initialIntensity,
    ),
  );
}

class _MoodPickerSheet extends StatefulWidget {
  final JournalMoodLevel? initialMood;
  final int initialIntensity;

  const _MoodPickerSheet({
    required this.initialMood,
    required this.initialIntensity,
  });

  @override
  State<_MoodPickerSheet> createState() => _MoodPickerSheetState();
}

class _MoodPickerSheetState extends State<_MoodPickerSheet> {
  late JournalMoodLevel? _selectedMood;
  late int _intensity;

  static const List<JournalMoodLevel> _moods = <JournalMoodLevel>[
    JournalMoodLevel.veryUnpleasant,
    JournalMoodLevel.unpleasant,
    JournalMoodLevel.neutral,
    JournalMoodLevel.pleasant,
    JournalMoodLevel.veryPleasant,
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood;
    _intensity = widget.initialIntensity.clamp(1, 5);
  }

  void _save() {
    final mood = _selectedMood;
    if (mood == null) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop(
      MoodPickerResult(mood: mood, intensity: _intensity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: AppColors.ink, width: 2),
          boxShadow: const [
            BoxShadow(color: AppColors.ink, offset: Offset(0, -2), blurRadius: 0),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (final mood in _moods)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: _MoodIconOption(
                            mood: mood,
                            selected: mood == _selectedMood,
                            onTap: () => setState(() => _selectedMood = mood),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_selectedMood != null)
                  Center(
                    child: Text(
                      _selectedMood!.sheetLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Text(
                      'Select a mood',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Intensity',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (var step = 1; step <= 5; step++) ...[
                      Expanded(
                        child: _IntensityStep(
                          step: step,
                          selected: _intensity == step,
                          enabled: _selectedMood != null,
                          onTap: _selectedMood == null
                              ? null
                              : () => setState(() => _intensity = step),
                        ),
                      ),
                      if (step < 5) const SizedBox(width: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Low',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                    Text(
                      'High',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _save,
                    child: AnimatedOpacity(
                      opacity: _selectedMood == null ? 0.55 : 1,
                      duration: const Duration(milliseconds: 120),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(12),
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
                        child: const Text(
                          'Save mood',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodIconOption extends StatelessWidget {
  final JournalMoodLevel mood;
  final bool selected;
  final VoidCallback onTap;

  const _MoodIconOption({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.accent : AppColors.surface;
    final fg = selected ? AppColors.surface : AppColors.ink;
    final borderColor = selected ? AppColors.ink : AppColors.rule;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 2 : 1.5),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: AppColors.ink,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Icon(mood.icon, size: 28, color: fg),
        ),
      ),
    );
  }
}

class _IntensityStep extends StatelessWidget {
  final int step;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  const _IntensityStep({
    required this.step,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = !enabled
        ? AppColors.rule.withValues(alpha: 0.25)
        : (selected ? AppColors.accent : AppColors.surface);
    final fg = !enabled
        ? AppColors.muted
        : (selected ? AppColors.surface : AppColors.ink);
    final border = !enabled
        ? AppColors.rule
        : (selected ? AppColors.ink : AppColors.rule);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 36,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: selected ? 2 : 1.5),
          boxShadow: selected && enabled
              ? const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(1, 1),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$step',
          style: TextStyle(
            fontFamily: 'IBM Plex Mono',
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: fg,
          ),
        ),
      ),
    );
  }
}

