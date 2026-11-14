// Responsibility: Insights stats — 4 cards (STREAK, ENTRIES, WORDS, DAYS)
// in a responsive 2x2 grid. Flat cards per OpenPencil (2px border, r20, no shadow).
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class InsightsStatsRow extends StatelessWidget {
  const InsightsStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          children: [
            Expanded(
              child: StatCard(value: '12', label: 'STREAK', sublabel: 'days'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(value: '42', label: 'ENTRIES', sublabel: 'total'),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(value: '1.2K', label: 'WORDS', sublabel: 'written'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(value: '14', label: 'DAYS', sublabel: 'active'),
            ),
          ],
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String sublabel;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Anton',
              fontSize: 30,
              fontWeight: FontWeight.w400,
              color: AppColors.ink,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.muted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: const TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.muted,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
