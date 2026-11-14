// Responsibility: Stats row with 4 stat cards (STREAK, ENTRIES, WORDS, DAYS)
// and the StatCard widget. Extracted from insights_screen.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme.dart';

class InsightsStatsRow extends StatelessWidget {
  const InsightsStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            value: '12',
            label: 'STREAK',
            sublabel: 'days',
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            value: '42',
            label: 'ENTRIES',
            sublabel: 'total',
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            value: '1.2K',
            label: 'WORDS',
            sublabel: 'written',
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            value: '14',
            label: 'DAYS',
            sublabel: 'active',
            accent: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String sublabel;
  final Color accent;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.sublabel,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 166,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: 0.5,
              height: 16 / 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.muted,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
