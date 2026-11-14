// Responsibility: "RECENT ENTRIES" section for Home screen.
// Uses minimalized JournalEntryCard style (no intro, smaller height).
import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../journal/widgets/journal_entry_card.dart';

class HomeRecentEntries extends StatelessWidget {
  const HomeRecentEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Text(
          'RECENT ENTRIES',
          style: TextStyle(
            fontFamily: 'IBM Plex Mono',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.muted,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 12),
        JournalEntryCard(
          title: 'Monday, Oct 13',
          date: '2h ago',
          mood: 'Heavy',
          trait: 'Personal',
          icon: Icons.edit_note_outlined,
          iconBackgroundColor: Color(0xFFDDE7C7),
          showIntro: false,
          compact: true,
        ),
        SizedBox(height: 8),
        JournalEntryCard(
          title: 'Tuesday, Oct 14',
          date: '1d ago',
          mood: 'Quiet',
          trait: 'Reflection',
          icon: Icons.nights_stay_outlined,
          iconBackgroundColor: Color(0xFFF6E3A1),
          showIntro: false,
          compact: true,
        ),
        SizedBox(height: 8),
        JournalEntryCard(
          title: 'Wednesday, Oct 15',
          date: '2d ago',
          mood: 'Centered',
          trait: 'Mindfulness',
          icon: Icons.self_improvement_outlined,
          iconBackgroundColor: Color(0xFFD7E6F5),
          showIntro: false,
          compact: true,
        ),
      ],
    );
  }
}
