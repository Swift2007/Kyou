// Responsibility: Two-part helper row between actions: muted question on the left,
// bold ink action link on the right. Extracted from journal_kit.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'journal_colors.dart';

/// Two-part helper row between actions: muted question on the left, bold ink
/// action link on the right.
class JournalSecondaryRow extends StatelessWidget {
  const JournalSecondaryRow({
    super.key,
    required this.question,
    required this.action,
    required this.onAction,
  });

  final String question;
  final String action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            question,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: JournalColors.muted,
              height: 21 / 14,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: JournalColors.ink,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(44, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            action,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: JournalColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
