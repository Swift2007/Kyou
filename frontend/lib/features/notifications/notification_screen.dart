// Responsibility: Renders the Notifications screen matching the OpenPencil
// Notifications page (page_id 0:4, frame 0:1798 light / 0:1852 dark, 390x844).
// No status bar per user instruction.
//
// Sections:
// - REMINDERS: Daily reflection (toggle On), Reminder time (nav)
// - ACTIVITY: Streaks & milestones (toggle On), Journal insights (toggle Off)
// - PRODUCT: Tips & features (toggle Off), Quiet hours (nav)
// - Info banner + footer note
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import 'notification_app_bar.dart';
import 'notification_section_card.dart';
import 'notification_setting_row.dart';
import 'notification_nav_row.dart';
import 'info_banner.dart';
import 'footer_note.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const NotificationAppBar(),
            const SizedBox(height: 16),

            // REMINDERS section
            NotificationSectionCard(
              title: 'REMINDERS',
              children: [
                NotificationSettingRow(
                  icon: '✦',
                  label: 'Daily reflection',
                  desc: 'A gentle nudge to write each day.',
                  toggleOn: true,
                ),
                const SizedBox(height: 10),
                NotificationNavRow(
                  label: 'Reminder time',
                  desc: '8:30 PM · every day',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ACTIVITY section
            NotificationSectionCard(
              title: 'ACTIVITY',
              children: [
                NotificationSettingRow(
                  icon: '★',
                  label: 'Streaks & milestones',
                  desc: 'Celebrate consistency and progress.',
                  toggleOn: true,
                ),
                const SizedBox(height: 10),
                NotificationSettingRow(
                  icon: '◔',
                  label: 'Journal insights',
                  desc: 'Weekly patterns and gentle summaries.',
                  toggleOn: false,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // PRODUCT section
            NotificationSectionCard(
              title: 'PRODUCT',
              children: [
                NotificationSettingRow(
                  icon: '◌',
                  label: 'Tips & features',
                  desc: 'Occasional updates from Kyou.',
                  toggleOn: false,
                ),
                const SizedBox(height: 10),
                NotificationNavRow(
                  label: 'Quiet hours',
                  desc: 'Off · allow notifications anytime',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Info banner
            const InfoBanner(
              text: 'System notifications are on. You can manage permissions in device settings.',
            ),
            const SizedBox(height: 24),

            // Footer note
            const FooterNote(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
