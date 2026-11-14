// Responsibility: Insights screen (kept accessible by route, no navbar tab).
// Key insights content has been surfaced on Home; this screen remains available.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_bottom_dock.dart';
import 'widgets/insight_row.dart';
import 'widgets/insights_app_bar.dart';
import 'widgets/insights_stats_row.dart';
import 'widgets/weekly_chart.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomDock(activeTab: null),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              InsightsAppBar(),
              SizedBox(height: 24),
              _SectionLabel('Analysis'),
              SizedBox(height: 12),
              InsightsStatsRow(),
              SizedBox(height: 24),
              _SectionLabel('THIS WEEK'),
              SizedBox(height: 12),
              WeeklyChart(),
              SizedBox(height: 24),
              _SectionLabel('RECENT INSIGHT'),
              SizedBox(height: 12),
              InsightRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'IBM Plex Mono',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
        letterSpacing: 0.5,
      ),
    );
  }
}
