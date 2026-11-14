// Responsibility: Bottom navigation bar item (InsightsNavItem) and container (InsightsBottomNav)
// used in the insights screen bottom nav. Extracted from insights_screen.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';

class InsightsBottomNav extends StatelessWidget {
  const InsightsBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.ink, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => context.go('/home'),
            child: InsightsNavItem(
              label: 'Home',
              active: false,
              icon: Icons.home_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/insights'),
            child: InsightsNavItem(
              label: 'Insights',
              active: true,
              icon: Icons.bar_chart_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/entries'),
            child: InsightsNavItem(
              label: 'Journal',
              active: false,
              icon: Icons.book_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/entries'),
            child: InsightsNavItem(
              label: 'Profile',
              active: false,
              icon: Icons.person_outline,
            ),
          ),
        ],
      ),
    );
  }
}

class InsightsNavItem extends StatelessWidget {
  final String label;
  final bool active;
  final IconData icon;

  const InsightsNavItem({
    super.key,
    required this.label,
    required this.active,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (active)
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          )
        else
          const SizedBox(height: 8),
        Icon(icon, size: 22, color: active ? AppColors.ink : AppColors.muted),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: active ? AppColors.ink : AppColors.muted,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
