// Responsibility: PaperSheet — ruled journal paper background 366×714.
// Horizontal lines (334×1 each), left margin line (1×534).
// Bottom 96px padding keeps text clear of the tool toggle.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class JournalEditorPaper extends StatelessWidget {
  const JournalEditorPaper({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 366,
        height: 714,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.ink, width: 3),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Left margin line — 1×534
            const Positioned(
              left: 12,
              top: 20,
              child: SizedBox(width: 1, height: 534),
            ),
            // Horizontal ruled lines — 334×1 each, spaced ~26px apart
            ...List.generate(20, (index) {
              final top = 20 + index * 26;
              return Positioned(
                left: 16,
                top: top.toDouble(),
                child: Container(width: 334, height: 1, color: AppColors.ink),
              );
            }),
          ],
        ),
      ),
    );
  }
}
