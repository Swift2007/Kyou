// Responsibility: Journal entry card — icon/color block, content, chevron.
// Configurable for user-chosen icon/color; OpenPencil-aligned typography.
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

  const JournalEntryCard({
    super.key,
    required this.title,
    required this.date,
    required this.mood,
    required this.trait,
    required this.intro,
    this.icon = Icons.eco_outlined,
    this.iconBackgroundColor = const Color(0xFFDDE7C7),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        ThemeData.estimateBrightnessForColor(iconBackgroundColor) ==
                Brightness.dark
            ? AppColors.surface
            : AppColors.ink;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 56,
                    color: iconBackgroundColor,
                    alignment: Alignment.center,
                    child: Icon(icon, size: 24, color: iconColor),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
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
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
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
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                    fontFamily: 'IBM Plex Mono',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
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
                          const SizedBox(height: 6),
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
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Center(
                      child: Icon(
                        Icons.chevron_right,
                        size: 22,
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
