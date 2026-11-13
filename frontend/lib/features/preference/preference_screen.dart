// Responsibility: Renders the Preference screen as a clean, single-screen
// layout with grouped appearance settings. No scrolling required on standard
// phones. Based on OpenPencil preference page features, reworked for better
// visual hierarchy and accessibility.
// No status bar per user instruction.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import 'preference_app_bar.dart';
import 'preference_section_card.dart';
import 'theme_group.dart';
import 'accent_group.dart';
import 'paper_group.dart';
import 'reset_appearance_button.dart';

class PreferenceScreen extends ConsumerWidget {
  const PreferenceScreen({super.key});

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
            const PreferenceAppBar(),
            const SizedBox(height: 16),

            // Group 1: THEME — mode picker + colors together
            const SectionCard(
              title: 'THEME',
              subtitle: 'Light / dark mode and paper tone.',
              child: ThemeGroup(),
            ),
            const SizedBox(height: 16),

            // Group 2: ACCENT COLOR
            const SectionCard(
              title: 'ACCENT COLOR',
              subtitle: 'Buttons, nav, highlights, badges.',
              child: AccentGroup(),
            ),
            const SizedBox(height: 16),

            // Group 3: EDITOR APPEARANCE (journal paper)
            const SectionCard(
              title: 'EDITOR APPEARANCE',
              subtitle: 'Writing paper in the journal editor.',
              child: PaperGroup(),
            ),
            const SizedBox(height: 20),

            // Reset appearance — full width at bottom
            const ResetAppearanceButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class PreferenceAppBar extends ConsumerWidget {
  const PreferenceAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppBarWidget();
  }
}
