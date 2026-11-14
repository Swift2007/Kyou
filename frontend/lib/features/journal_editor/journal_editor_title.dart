// Responsibility: Title field — "Give today a name" placeholder.
// 185×38 per OpenPencil frame tree.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class JournalEditorTitle extends StatelessWidget {
  const JournalEditorTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185,
      height: 38,
      decoration: BoxDecoration(color: Colors.transparent),
      child: const TextField(
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          height: 1,
        ),
        decoration: InputDecoration(
          hintText: 'Give today a name',
          hintStyle: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: AppColors.muted,
            height: 1,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        maxLines: 1,
        cursorColor: AppColors.ink,
      ),
    );
  }
}
