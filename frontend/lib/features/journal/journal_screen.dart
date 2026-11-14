// Responsibility: Journal screen — lists journals/entries. Uses shared bottom dock.
// No status bar, no home indicator pill.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_bottom_dock.dart';

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
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _JournalAppBar(),
              SizedBox(height: 18),
              _JournalSearchField(),
              SizedBox(height: 24),
              Text(
                'YOUR JOURNALS',
                style: TextStyle(
                  fontFamily: 'IBM Plex Mono',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                  letterSpacing: 0.5,
                  height: 18 / 14,
                ),
              ),
              SizedBox(height: 12),
              _JournalRows(),
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'JOURNAL',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: 0.5,
        ),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, size: 20, color: AppColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search your journal…',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
                height: 19 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalRows extends StatelessWidget {
  const _JournalRows();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _JournalRow(title: null, date: null, body: null),
        SizedBox(height: 8),
        _JournalRow(title: null, date: null, body: null),
        SizedBox(height: 8),
        _JournalRow(
          title: 'Monday Musings',
          date: 'Oct 13 · 2:14 PM',
          body: 'Work week reflections and thoughts.',
        ),
        SizedBox(height: 8),
        _JournalRow(
          title: 'Gratitude List',
          date: 'Oct 12 · 9:00 AM',
          body: 'Today I am grateful for the little things.',
        ),
        SizedBox(height: 8),
        _JournalRow(
          title: 'Travel Notes',
          date: 'Oct 10 · 3:30 PM',
          body: 'Mountain cabin weekend, fresh air.',
        ),
      ],
    );
  }
}

class _JournalRow extends StatelessWidget {
  final String? title;
  final String? date;
  final String? body;

  const _JournalRow({this.title, this.date, this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 69),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  height: 21 / 17,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date ?? '',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted,
                  height: 14 / 12,
                ),
              ),
              const SizedBox(height: 4),
              if (body != null)
                Text(
                  body!,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                    height: 17 / 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
