// Responsibility: "RECENT ENTRIES" section and entry rows for Home screen.
// Flat, clean rows per OpenPencil direction (no avatars), subtle dividers.
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

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
        _EntryRow(
          title: 'Monday, Oct 13',
          subtitle: 'This week was heavy. Wrote it anyway.',
          time: '2h ago',
        ),
        _EntryDivider(),
        _EntryRow(
          title: 'Tuesday, Oct 14',
          subtitle: 'Some days just need a quieter list.',
          time: '1d ago',
        ),
        _EntryDivider(),
        _EntryRow(
          title: 'Wednesday, Oct 15',
          subtitle: 'The center holds.',
          time: '2d ago',
        ),
      ],
    );
  }
}

class _EntryRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const _EntryRow({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            time,
            style: const TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}

class _EntryDivider extends StatelessWidget {
  const _EntryDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 1,
        color: AppColors.ink.withValues(alpha: 0.1),
      ),
    );
  }
}
