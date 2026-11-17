// Responsibility: Multiline journal body editor — Newsreader 17 w400.
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class JournalEditorBody extends StatelessWidget {
  final TextEditingController controller;

  const JournalEditorBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.newsreader(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
      height: 27 / 17,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 240),
      child: TextField(
        controller: controller,
        style: base,
        cursorColor: AppColors.ink,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        minLines: 8,
        decoration: InputDecoration(
          hintText: 'Dear me…',
          hintStyle: base.copyWith(
            color: AppColors.muted.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
