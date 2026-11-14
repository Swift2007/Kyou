// Responsibility: Two-line Anton headline with an accent-colored closing word,
// plus the editorial note row (28x3 accent rule + mono label). Extracted from journal_kit.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'journal_colors.dart';

/// Two-line Anton headline with an accent-colored closing word, plus the
/// editorial note row (28x3 accent rule + mono label).
class JournalAccentHeadline extends StatelessWidget {
  const JournalAccentHeadline({
    super.key,
    required this.firstLine,
    required this.accentText,
    required this.note,
  });

  final String firstLine;
  final String accentText;
  final String note;

  @override
  Widget build(BuildContext context) {
    // Match the prototype's Anton headline scale; FittedBox.scaleDown keeps it
    // unscrollable/fitting on narrow or short screens (e.g. 360dp phones).
    // Uses screen width (not LayoutBuilder) to stay compatible with IntrinsicHeight.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final fontSize = ((screenWidth - 48) * 0.22).clamp(44.0, 76.0);
    final lineHeight = fontSize * (72 / 76);
    final text = Text.rich(
      TextSpan(
        style: GoogleFonts.anton(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: JournalColors.ink,
          height: lineHeight / fontSize,
          letterSpacing: -1.5 * (fontSize / 76),
        ),
        children: [
          TextSpan(text: firstLine),
          TextSpan(
            text: accentText,
            style: const TextStyle(color: JournalColors.accent),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: text,
        ),
        SizedBox(height: (10 * (fontSize / 76)).clamp(6.0, 18.0)),
        Row(
          children: [
            Container(width: 24, height: 3, color: JournalColors.accent),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: JournalColors.ink,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
