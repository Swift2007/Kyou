// Responsibility: Journal entry card — icon/color block, content, chevron.
// Configurable for user-chosen icon/color; OpenPencil-aligned typography.
// Supports compact mode (smaller height, no intro) for Home recent entries.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme.dart';

class JournalEntryCard extends StatelessWidget {
  final String title;
  final String date;
  final String mood;
  final String trait;
  final String intro;
  final IconData icon;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;
  final bool showIntro;
  final bool compact;

  const JournalEntryCard({
    super.key,
    required this.title,
    required this.date,
    required this.mood,
    required this.trait,
    this.intro = '',
    this.icon = Icons.eco_outlined,
    this.iconBackgroundColor = const Color(0xFFDDE7C7),
    this.onTap,
    this.showIntro = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        ThemeData.estimateBrightnessForColor(iconBackgroundColor) ==
                Brightness.dark
            ? AppColors.surface
            : AppColors.ink;
    final stripWidth = compact ? 44.0 : 56.0;
    final iconSize = compact ? 20.0 : 24.0;
    final contentPadding = compact
        ? const EdgeInsets.fromLTRB(10, 8, 6, 8)
        : const EdgeInsets.fromLTRB(12, 12, 8, 12);
    final titleSize = compact ? 15.0 : 16.0;
    final dateSize = compact ? 9.0 : 10.0;
    final metaGap = compact ? 4.0 : 6.0;
    final chevronSize = compact ? 20.0 : 22.0;
    final radius = 20.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: stripWidth,
                    color: iconBackgroundColor,
                    alignment: Alignment.center,
                    child: Icon(icon, size: iconSize, color: iconColor),
                  ),
                  Expanded(
                    child: Padding(
                      padding: contentPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Mono',
                                    fontSize: dateSize,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: metaGap),
                          Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _MetaLabel(text: mood, emphasized: true),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  color: AppColors.muted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              _MetaLabel(text: trait, emphasized: false),
                            ],
                          ),
                          if (showIntro && intro.isNotEmpty) ...[
                            SizedBox(height: metaGap),
                            Text(
                              intro,
                              style: GoogleFonts.caveat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.muted,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Center(
                      child: Icon(
                        Icons.chevron_right,
                        size: chevronSize,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaLabel extends StatelessWidget {
  final String text;
  final bool emphasized;

  const _MetaLabel({required this.text, required this.emphasized});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'IBM Plex Mono',
        fontSize: 11,
        fontWeight: emphasized ? FontWeight.w500 : FontWeight.w400,
        color: emphasized ? AppColors.ink : AppColors.muted,
        height: 1.2,
      ),
    );
  }
}
