// Responsibility: App info card — app mark, name, tagline, version.
// 342×108 per OpenPencil frame tree.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class AboutAppInfoCard extends StatelessWidget {
  const AboutAppInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 108,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ink,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // App mark
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.ink, width: 3),
              ),
              child: const Center(
                child: Text(
                  'K',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Kyou',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A calm, neo-brutalist space for your journal.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                      height: 17 / 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
