// Responsibility: Journal title field — Caveat 30 w700, placeholder vs filled.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorTitle extends StatelessWidget {
  final TextEditingController controller;

  const JournalEditorTitle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(fontFamily: 'Caveat', fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      height: 1.1,
    );
    return TextField(
      controller: controller,
      style: base,
      cursorColor: AppColors.ink,
      decoration: InputDecoration(
        hintText: 'Give today a name',
        hintStyle: base.copyWith(
          color: AppColors.muted.withValues(alpha: 0.55),
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      textInputAction: TextInputAction.next,
      maxLines: 1,
    );
  }
}
