// Responsibility: Speed Dial scrim — full-screen overlay when speed dial is open.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class JournalEditorSpeedDialScrim extends StatelessWidget {
  const JournalEditorSpeedDialScrim({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 390,
        height: 748,
        color: AppColors.ink.withValues(alpha: 0.25),
      ),
    );
  }
}

// Responsibility: Speed Dial overlay — fans out from tool toggle.
// 6 buttons: Attach (2), Voice, Mood: Good, Tag, Predict ✓, Reply.
// Each button 48×48 with label below.
// Dark/Night Paper variant uses warm dark background handled by theme.
class JournalEditorSpeedDial extends StatelessWidget {
  final bool open;
  final VoidCallback onClosed;

  const JournalEditorSpeedDial({
    super.key,
    required this.open,
    required this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    if (!open) return const SizedBox.shrink();

    return Positioned(
      right: 24,
      bottom: 116,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          _SpeedDialItem(label: 'Attach (2)', icon: '📎'),
          _SpeedDialItem(label: 'Voice', icon: '🎙'),
          _SpeedDialItem(label: 'Mood: Good', icon: '😊'),
          _SpeedDialItem(label: 'Tag', icon: '🏷'),
          _SpeedDialItem(label: 'Predict ✓', icon: '✨'),
          _SpeedDialItem(label: 'Reply', icon: '↩'),
        ],
      ),
    );
  }
}

class _SpeedDialItem extends StatelessWidget {
  final String label;
  final String icon;

  const _SpeedDialItem({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.ink, width: 3),
            boxShadow: const [
              BoxShadow(
                color: AppColors.ink,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
