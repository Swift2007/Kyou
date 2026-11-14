// Responsibility: Home screen (OpenPencil Home UI, frame 0:1052).
// Clean, flat layout: app bar, calendar, recent entries, bottom dock.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_bottom_dock.dart';
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
              HomeRecentEntries(),
            ],
          ),
        ),
      ),
    );
  }
}
