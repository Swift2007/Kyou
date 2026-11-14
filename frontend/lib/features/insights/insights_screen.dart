// Responsibility: Renders the Insights screen matching the OpenPencil
// Home UI prototype exactly (frame 0:1142, 402x874).
// No status bar per user instruction.
//
// Structure from OpenPencil:
// - App bar: "INSIGHTS" title (Anton)
// - New entry FAB: 56x56 rounded rect with "+"
// - Bottom nav: Home / Insights(active) / Journal / Profile
// - Home indicator: 134x5 pill
//
// Content:
// - "Analysis" section header
// - 4 stat cards: STREAK(12 days), ENTRIES(42 total), WORDS(1.2K written), DAYS(14 active)
// - "THIS WEEK" section header
// - Weekly bar chart: 7 bars MON-SUN with varying heights
// - "RECENT INSIGHT" section header
// - Insight row: "You write most on Wednesdays. Keep the momentum going."
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../core/widgets/journal_kit.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                // App bar — "INSIGHTS" title matching OpenPencil 0:1152/0:1155
                const _InsightsAppBar(),
                const SizedBox(height: 18),
                // Masthead
                const JournalMasthead(),
                const SizedBox(height: 24),
                // Analysis section header (OpenPencil 0:1177)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Analysis',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                      letterSpacing: 0.5,
                      height: 18 / 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Stats row — 4 cards matching OpenPencil (STREAK, ENTRIES, WORDS, DAYS)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _InsightsStatsRow(),
                ),
                const SizedBox(height: 24),
                // THIS WEEK section header (OpenPencil 0:1194)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'THIS WEEK',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                      letterSpacing: 0.5,
                      height: 18 / 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Weekly bar chart — 7 bars MON-SUN with varying heights (OpenPencil 0:1195)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _WeeklyChart(),
                ),
                const SizedBox(height: 24),
                // RECENT INSIGHT section header (OpenPencil 0:1210)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'RECENT INSIGHT',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                      letterSpacing: 0.5,
                      height: 18 / 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Insight row card — "You write most on Wednesdays. Keep the momentum going." (OpenPencil 0:1211)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _InsightRow(),
                ),
                const Spacer(),
                // Bottom navigation — Insights active (OpenPencil 0:1158)
                const _InsightsBottomNav(),
                // Home safe area — iOS home indicator (OpenPencil 0:1175/0:1176)
                Container(
                  height: 38,
                  color: AppColors.background,
                  child: const Center(child: _HomeIndicator()),
                ),
              ],
            ),
            // New entry FAB — 56x56 rounded rect with "+" (OpenPencil 0:1156/0:1157)
            Positioned(
              right: 16,
              bottom: 76,
              child: GestureDetector(
                onTap: () => context.go('/entries/new'),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.ink, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.ink,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightsAppBar extends ConsumerWidget {
  const _InsightsAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          // "INSIGHTS" title in Anton matching OpenPencil 0:1155
          Expanded(
            child: Text(
              'INSIGHTS',
              style: TextStyle(
                fontFamily: 'Anton',
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -1,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsStatsRow extends StatelessWidget {
  const _InsightsStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '12',
            label: 'STREAK',
            sublabel: 'days',
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '42',
            label: 'ENTRIES',
            sublabel: 'total',
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '1.2K',
            label: 'WORDS',
            sublabel: 'written',
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
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

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String sublabel;
  final Color accent;

  const _StatCard({
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

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart();

  // Bar heights matching OpenPencil (0:1196-0:1209):
  // MON: 40, TUE: 65, WED: 30, THU: 80, FRI: 55, SAT: 70, SUN: 45
  static const List<_BarData> _bars = [
    _BarData('MON', 40.0),
    _BarData('TUE', 65.0),
    _BarData('WED', 30.0),
    _BarData('THU', 80.0),
    _BarData('FRI', 55.0),
    _BarData('SAT', 70.0),
    _BarData('SUN', 45.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 132,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        children: [
          // Bars row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _bars.map((bar) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: bar.height,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.ink, width: 2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bar.label,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.muted,
                        height: 16 / 13,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String label;
  final double height;

  const _BarData(this.label, this.height);
}

class _InsightRow extends StatelessWidget {
  const _InsightRow();

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

class _InsightsBottomNav extends StatelessWidget {
  const _InsightsBottomNav();

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
            child: _NavItem(
              label: 'Home',
              active: false,
              icon: Icons.home_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/insights'),
            child: _NavItem(
              label: 'Insights',
              active: true,
              icon: Icons.bar_chart_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/entries'),
            child: _NavItem(
              label: 'Journal',
              active: false,
              icon: Icons.book_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/entries'),
            child: _NavItem(
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

class _NavItem extends StatelessWidget {
  final String label;
  final bool active;
  final IconData icon;

  const _NavItem({
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

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 134,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}
