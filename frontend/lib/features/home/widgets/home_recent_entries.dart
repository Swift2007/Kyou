// Responsibility: "RECENT ENTRIES" section and entry rows for Home screen.
// Flat avatars, left-aligned content, subtle dividers per OpenPencil.
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
          initial: 'A',
          title: 'Monday, Oct 13',
          subtitle: 'This week was heavy. Wrote it anyway.',
          time: '2h ago',
        ),
        _EntryDivider(),
        _EntryRow(
          initial: 'B',
          title: 'Tuesday, Oct 14',
          subtitle: 'Some days just need a quieter list.',
          time: '1d ago',
        ),
        _EntryDivider(),
        _EntryRow(
          initial: 'C',
          title: 'Wednesday, Oct 15',
          subtitle: 'The center holds.',
          time: '2d ago',
        ),
      ],
    );
  }
}

class _EntryRow extends StatelessWidget {
  final String initial;
  final String title;
  final String subtitle;
  final String time;

  const _EntryRow({
    required this.initial,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: const TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(width: 12),
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
        const SizedBox(width: 8),
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
