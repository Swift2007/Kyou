// Responsibility: Masthead strip: brand note on the right above a 2px ink rule
// (Home UI prototype). Extracted from journal_kit.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'journal_colors.dart';

/// Masthead strip: brand note on the right above a 2px ink rule (Home UI prototype).
/// The provisional `[ UNTITLED ]` wordmark is intentionally omitted.
class JournalMasthead extends StatelessWidget {
  const JournalMasthead({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;
    return Container(
      height: compact ? 40 : 48,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: JournalColors.ink, width: 2)),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'WORKING TITLE.\nYOUR JOURNAL.',
          textAlign: TextAlign.right,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: JournalColors.muted,
            height: 12 / 10,
          ),
        ),
      ),
    );
  }
}
