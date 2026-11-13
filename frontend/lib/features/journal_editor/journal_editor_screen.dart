// Responsibility: Renders the Journal Editor screen matching the OpenPencil
// Journal Editor page (page_id 0:56, frames 0:1974 empty / 0:2041 mood /
// 0:2641 speed dial open / dark night variant, 390x844).
// No status bar per user instruction.
//
// States:
// - Draft (default): paper empty, title "Give today a name", body "Dear me…"
// - Saved: status dot says "Saved"
// - Speed dial open: overlay fans out from tool toggle
// Mood chips: Great, Good, Okay, Low, Rough, + (add custom)
// Speed dial buttons: Attach, Voice, Mood: Good, Tag, Predict ✓, Reply
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'journal_editor_app_bar.dart';
import 'journal_editor_paper.dart';
import 'journal_editor_title.dart';
import 'journal_editor_mood.dart';
import 'journal_editor_body.dart';
import 'journal_editor_stats.dart';
import 'journal_editor_tool_toggle.dart';
import 'journal_editor_speed_dial.dart';

class JournalEditorScreen extends StatefulWidget {
  const JournalEditorScreen({super.key});

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  bool _saved = false; // Draft -> Saved status
  bool _speedDialOpen = false;
  String? _selectedMood; // null = none selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TopBar — close × | date | status + Draft/Saved | lock | Done
                const JournalEditorAppBar(),
                const SizedBox(height: 12),
                // PaperSheet — ruled journal paper 366×714
                const JournalEditorPaper(),
                const SizedBox(height: 4),
              ],
            ),
            // Title field — overlays top of paper
            const Positioned(
              left: 24,
              top: 130,
              child: JournalEditorTitle(),
            ),
            // Mood chips row — below title
            const Positioned(
              left: 24,
              top: 190,
              child: JournalEditorMood(),
            ),
            // Body text area — below mood chips
            const Positioned(
              left: 24,
              top: 250,
              right: 24,
              child: JournalEditorBody(),
            ),
            // Stats row — bottom of paper
            const Positioned(
              left: 24,
              bottom: 110,
              right: 24,
              child: JournalEditorStats(),
            ),
            // Floating tool toggle — bottom right, above paper bottom
            Positioned(
              right: 24,
              bottom: 56,
              child: JournalEditorToolToggle(
                open: _speedDialOpen,
                onToggled: () => setState(() => _speedDialOpen = !_speedDialOpen),
              ),
            ),
            // Speed dial overlay — fans out when open
            if (_speedDialOpen) ...[
              const JournalEditorSpeedDialScrim(),
              JournalEditorSpeedDial(
                open: _speedDialOpen,
                onClosed: () => setState(() => _speedDialOpen = false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
