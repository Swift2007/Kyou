// Responsibility: Stats row — word count + similar entries chip.
// Bottom of paper area.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class JournalEditorStats extends StatelessWidget {
  const JournalEditorStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Similar entries chip — 176×26
        Container(
          width: 176,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.ink, width: 3),
          ),
          child: const Center(
            child: Text(
              '2 similar past entries  ›',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
        const Spacer(),
        // Word count — "0 words · 0 min"
        const Text(
          '0 words · 0 min',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}
