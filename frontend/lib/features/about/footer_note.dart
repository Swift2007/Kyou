// Responsibility: Footer note text at bottom of About screen.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class FooterNote extends StatelessWidget {
  const FooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Made with care for your daily reflections.',
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      textAlign: TextAlign.center,
    );
  }
}
