// Responsibility: Renders the Create journal screen matching the OpenPencil
// Home UI prototype exactly (frame 0:1014, 402x874).
// No status bar per user instruction.
//
// Structure from OpenPencil:
// - Masthead: "WORKING TITLE.\nYOUR JOURNAL."
// - Headline: "CREATE A NEW\nJOURNAL." + accent rule + "PAGES WAITING."
// - Create journal form: JOURNAL TITLE field, COVER row, Auto note
// - Create journal actions: "Create journal" + forward arrow
// - Closing note: "LESS SCROLLING. MORE FEELING." / "VOL. YOU"
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../core/widgets/journal_kit.dart';

class CreateJournalScreen extends ConsumerWidget {
  const CreateJournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // Masthead
            const JournalMasthead(),
            const SizedBox(height: 24),
            // Headline section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CREATE A NEW\nJOURNAL.',
                    style: AppTextStyles.headline(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(width: 24, height: 3, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Text('PAGES WAITING.', style: AppTextStyles.caption()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Create journal form
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _CreateJournalForm(),
            ),
            const SizedBox(height: 32),
            // Actions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _CreateJournalActions(),
            ),
            const Spacer(),
            // Closing note
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: JournalClosingNote(),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _CreateJournalForm extends StatelessWidget {
  const _CreateJournalForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Journal title field
        JournalTextField(label: 'JOURNAL TITLE', hint: 'Untitled journal'),
        const SizedBox(height: 16),
        // Cover row
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.accent,
                border: Border.all(color: AppColors.ink, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text('COVER', style: AppTextStyles.caption()),
          ],
        ),
        const SizedBox(height: 8),
        // Auto note
        Text(
          'Journals save as you write. No publish button.',
          style: AppTextStyles.caption(),
        ),
      ],
    );
  }
}

class _CreateJournalActions extends StatelessWidget {
  const _CreateJournalActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JournalPrimaryButton(label: 'Create journal', onPressed: () {}),
        const SizedBox(height: 32),
        const Spacer(),
      ],
    );
  }
}
