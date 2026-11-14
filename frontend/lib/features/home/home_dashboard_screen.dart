// Responsibility: Home screen (OpenPencil Home UI, frame 0:1052).
// Clean, flat layout: app bar, calendar, recent entries, shared FAB + nav.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_new_entry_fab.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_calendar_card.dart';
import 'widgets/home_recent_entries.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(activeTab: AppTab.home),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeAppBar(
                    onEdit: () => context.push('/edit-profile'),
                  ),
                  const SizedBox(height: 16),
                  const HomeCalendarCard(),
                  const SizedBox(height: 24),
                  const HomeRecentEntries(),
                ],
              ),
            ),
            const Positioned(
              right: 16,
              bottom: 16,
              child: AppNewEntryFab(),
            ),
          ],
        ),
      ),
    );
  }
}
