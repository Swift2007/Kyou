// Responsibility: TopBar — close × | date chip | status dot + Draft/Saved |
// lock | Done button. 390×96 per OpenPencil frame tree.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class JournalEditorAppBar extends StatelessWidget {
  const JournalEditorAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Close button — ×
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.ink, width: 3),
                ),
                child: const Center(
                  child: Text(
                    '×',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Date chip — "Thu, 5 Nov"
            Container(
              width: 122,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.ink, width: 3),
              ),
              child: const Center(
                child: Text(
                  'Thu, 5 Nov',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Status dot + Draft/Saved text
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Draft',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Lock button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.ink, width: 3),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: 6,
                      height: 8,
                      decoration: BoxDecoration(color: AppColors.ink),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Done button — 46×30
            Container(
              width: 46,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.ink, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
