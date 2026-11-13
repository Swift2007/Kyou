// Responsibility: Floating editor tool toggle — + when closed, × when open.
// 48×48 per OpenPencil frame tree.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class JournalEditorToolToggle extends StatelessWidget {
  final bool open;
  final VoidCallback onToggled;

  const JournalEditorToolToggle({
    super.key,
    required this.open,
    required this.onToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggled,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.accent,
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
          child: Text(
            open ? '×' : '+',
            style: TextStyle(
              fontSize: open ? 17 : 27,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
