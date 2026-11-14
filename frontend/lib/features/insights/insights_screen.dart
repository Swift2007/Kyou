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

import '../../core/theme.dart';
import '../../core/widgets/journal_kit.dart';
import 'widgets/insight_row.dart';
import 'widgets/insights_app_bar.dart';
import 'widgets/insights_bottom_nav.dart';
import 'widgets/insights_stats_row.dart';
import 'widgets/home_indicator.dart';
import 'widgets/weekly_chart.dart';

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
                const InsightsAppBar(),
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
                  child: InsightsStatsRow(),
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
                  child: WeeklyChart(),
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
                  child: InsightRow(),
                ),
                const Spacer(),
                // Bottom navigation — Insights active (OpenPencil 0:1158)
                const InsightsBottomNav(),
                // Home safe area — iOS home indicator (OpenPencil 0:1175/0:1176)
                Container(
                  height: 38,
                  color: AppColors.background,
                  child: const Center(child: HomeIndicator()),
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
