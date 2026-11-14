// Responsibility: Mood chips row — Great, Good, Okay, Low, Rough, + (add custom).
// Each chip 28×28 per OpenPencil frame tree.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class JournalEditorMood extends StatelessWidget {
  const JournalEditorMood({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 8),
        _MoodChip(label: 'Great'),
        const SizedBox(width: 6),
        _MoodChip(label: 'Good'),
        const SizedBox(width: 6),
        _MoodChip(label: 'Okay'),
        const SizedBox(width: 6),
        _MoodChip(label: 'Low'),
        const SizedBox(width: 6),
        _MoodChip(label: 'Rough'),
        const SizedBox(width: 6),
        _AddChip(),
      ],
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String label;

  const _MoodChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _chipWidth(label),
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.ink, width: 3),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }

  double _chipWidth(String label) {
    switch (label) {
      case 'Great':
        return 53;
      case 'Good':
        return 52;
      case 'Okay':
        return 50;
      case 'Low':
        return 44;
      case 'Rough':
        return 58;
      default:
        return 50;
    }
  }
}

class _AddChip extends StatelessWidget {
  const _AddChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 29,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.ink, width: 3),
      ),
      child: const Center(
        child: Text(
          '+',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}
