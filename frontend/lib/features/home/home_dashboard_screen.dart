// Responsibility: Home screen — progress hub (OpenPencil Home UI base)
// with key insights surfaced: stats, weekly activity, and recent insight.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_bottom_dock.dart';
import '../insights/widgets/insight_row.dart';
import '../insights/widgets/insights_stats_row.dart';
import '../insights/widgets/weekly_chart.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_calendar_card.dart';
import 'widgets/home_recent_entries.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomDock(activeTab: AppTab.home),
      body: const SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeAppBar(),
              SizedBox(height: 16),
              HomeCalendarCard(),
              SizedBox(height: 24),
              _SectionLabel('YOUR PROGRESS'),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      value: '12',
                      label: 'STREAK',
                      sublabel: 'days',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      value: '42',
                      label: 'ENTRIES',
                      sublabel: 'total',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _SectionLabel('THIS WEEK'),
              SizedBox(height: 12),
              WeeklyChart(),
              SizedBox(height: 24),
              _SectionLabel('RECENT INSIGHT'),
              SizedBox(height: 12),
              InsightRow(),
              SizedBox(height: 24),
              HomeRecentEntries(),
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
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
        letterSpacing: 1,
      ),
    );
  }
}
