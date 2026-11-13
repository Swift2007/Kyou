// Responsibility: Body text area — "Dear me…" placeholder.
// Overlays the paper below mood chips, spans full paper width.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class JournalEditorBody extends StatelessWidget {
  const JournalEditorBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: const TextField(
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: AppColors.ink,
          height: 1.4,
        ),
        decoration: InputDecoration(
          hintText: 'Dear me…',
          hintStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors.muted,
            height: 1.4,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        maxLines: null,
        expands: false,
        cursorColor: AppColors.ink,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
      ),
    );
  }
}
