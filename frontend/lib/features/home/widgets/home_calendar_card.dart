// Responsibility: Home calendar card — weekdays, dates, today highlight, arrows.
// Flat style per OpenPencil (2px stroke, r24, no shadow), static for now.
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class HomeCalendarCard extends StatelessWidget {
  const HomeCalendarCard({super.key});

  static const _weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  static const _dates = ['15', '16', '17', '18', '19', '20', '21'];
  static const _todayIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const _NavArrow(label: '<'),
              Expanded(
                child: Row(
                  children: _weekdays
                      .map(
                        (d) => Expanded(
                          child: Text(
                            d,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const _NavArrow(label: '>'),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(_dates.length, (i) {
                final isToday = i == _todayIndex;
                return Expanded(
                  child: Center(
                    child: isToday
                        ? Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _dates[i],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          )
                        : Text(
                            _dates[i],
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.muted,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final String label;
  const _NavArrow({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
        ),
      ),
    );
  }
}
