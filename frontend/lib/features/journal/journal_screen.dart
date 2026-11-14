// Responsibility: Journal screen — lists journals/entries. Uses shared bottom dock.
// New journal cards: icon/color block, title/date, mood/trait, intro, chevron.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_bottom_dock.dart';
import 'widgets/journal_entry_card.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomDock(activeTab: AppTab.journal),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _JournalAppBar(),
              SizedBox(height: 16),
              _JournalSearchField(),
              SizedBox(height: 24),
              Text(
                'YOUR JOURNALS',
                style: TextStyle(
                  fontFamily: 'IBM Plex Mono',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 12),
              _JournalCards(),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalAppBar extends StatelessWidget {
  const _JournalAppBar();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'JOURNAL',
      style: TextStyle(
        fontFamily: 'IBM Plex Mono',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    );
  }
}

class _JournalSearchField extends StatelessWidget {
  const _JournalSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.search, size: 20, color: AppColors.muted),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search your journal…',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalCards extends StatelessWidget {
  const _JournalCards();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        JournalEntryCard(
          title: 'Monday Musings',
          date: 'October 13, 2026',
          mood: 'Reflective',
          trait: 'Personal',
          intro: 'Work week reflections and thoughts to start the day.',
          icon: Icons.eco_outlined,
          iconBackgroundColor: Color(0xFFDDE7C7),
        ),
        SizedBox(height: 12),
        JournalEntryCard(
          title: 'Gratitude List',
          date: 'October 12, 2026',
          mood: 'Grateful',
          trait: 'Mindfulness',
          intro: 'Today I am grateful for the little things around me.',
          icon: Icons.wb_sunny_outlined,
          iconBackgroundColor: Color(0xFFF6E3A1),
        ),
        SizedBox(height: 12),
        JournalEntryCard(
          title: 'Travel Notes',
          date: 'October 10, 2026',
          mood: 'Calm',
          trait: 'Adventure',
          intro: 'Mountain cabin weekend, fresh air and quiet moments.',
          icon: Icons.terrain_outlined,
          iconBackgroundColor: Color(0xFFD7E6F5),
        ),
      ],
    );
  }
}
