// Responsibility: Editorial "writing line" input matching the Home UI auth prototype:
// page-white box with a 2px ink stroke, mono label, Caveat handwriting value,
// and a thin rule under the text. Extracted from journal_kit.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'journal_colors.dart';

/// Editorial "writing line" input matching the Home UI auth prototype:
/// page-white box with a 2px ink stroke, mono label, Caveat handwriting value,
/// and a thin rule under the text.
class JournalTextField extends StatelessWidget {
  const JournalTextField({
    super.key,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autocorrect = true,
    this.validator,
    this.onSaved,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autocorrect;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final inputStyle = GoogleFonts.caveat(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: JournalColors.ink,
      height: 24 / 22,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 6),
      decoration: BoxDecoration(
        color: JournalColors.page,
        border: Border.all(color: JournalColors.ink, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: JournalColors.muted,
              letterSpacing: 0.8,
              height: 11 / 9,
            ),
          ),
          const SizedBox(height: 1),
          TextFormField(
            style: inputStyle,
            cursorColor: JournalColors.ink,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autocorrect: autocorrect,
            validator: validator,
            onSaved: onSaved,
            onChanged: onChanged,
            decoration: InputDecoration(
              isCollapsed: true,
              isDense: true,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hint,
              hintStyle: inputStyle.copyWith(color: JournalColors.muted),
              errorStyle: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.red.shade700,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 1, color: JournalColors.rule),
        ],
      ),
    );
  }
}
