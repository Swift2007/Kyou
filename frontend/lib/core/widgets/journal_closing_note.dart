// Responsibility: Footer strip of the prototype screens: mono note on the left,
// edition mark on the right, under a 1px ink rule ("LESS SCROLLING. MORE FEELING." / "VOL. YOU").
// Extracted from journal_kit.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'journal_colors.dart';

/// Footer strip of the prototype screens: mono note on the left, edition mark
/// on the right, under a 1px ink rule ("LESS SCROLLING. MORE FEELING." / "VOL. YOU").
class JournalClosingNote extends StatelessWidget {
  const JournalClosingNote({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;
    return Container(
      height: compact ? 40 : 48,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: JournalColors.ink, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'LESS SCROLLING. MORE FEELING.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: JournalColors.muted,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'VOL. YOU',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: JournalColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
