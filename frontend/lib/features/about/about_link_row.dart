// Responsibility: Link row — label + description + chevron.
// 342×56 per OpenPencil frame tree.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class AboutLinkRow extends StatelessWidget {
  final String label;
  final String desc;

  const AboutLinkRow({
    super.key,
    required this.label,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                      height: 16 / 11,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              '›',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
