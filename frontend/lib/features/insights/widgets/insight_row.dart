// Responsibility: Insight row card — "You write most on Wednesdays. Keep the momentum going.",
// matching the OpenPencil Home UI prototype. Extracted from insights_screen.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme.dart';

class InsightRow extends StatelessWidget {
  const InsightRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You write most on Wednesdays.',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                height: 20 / 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Keep the momentum going.',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
                height: 17 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
