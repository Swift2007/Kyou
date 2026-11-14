// Responsibility: Compact daily activity grid (GitHub contribution-style)
// for Home progress section. Date-continuous window ending today.
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class HomeActivityGrid extends StatelessWidget {
  final DateTime? today;
  const HomeActivityGrid({super.key, this.today});

  // 7 rows: Mon (top) -> Sun (bottom)
  static const List<String> _dayLabels = ['M', '', 'W', '', 'F', '', 'S'];

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  // Monday-start of week for [d].
  DateTime _startOfWeek(DateTime d) {
    final date = _dateOnly(d);
    return date.subtract(Duration(days: date.weekday - DateTime.monday));
  }

  // Deterministic sample activity for past days (placeholder until real data).
  int _sampleLevel(DateTime day) {
    final n = day.year * 10000 + day.month * 100 + day.day;
    final v = (n * 1103515245 + 12345) & 0x7fffffff;
    final mod = v % 10;
    if (mod <= 3) return 0;
    if (mod <= 6) return 1;
    if (mod <= 8) return 2;
    return 3;
  }

  Color _colorFor(int level, {required bool isFuture}) {
    if (isFuture) return AppColors.ink.withValues(alpha: 0.03);
    switch (level) {
      case 1:
        return AppColors.rule;
      case 2:
        return AppColors.muted.withValues(alpha: 0.55);
      case 3:
        return AppColors.accent;
      default:
        return AppColors.ink.withValues(alpha: 0.06);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = _dateOnly(today ?? DateTime.now());
    const weekCount = 14;
    final endWeekStart = _startOfWeek(now);
    final start = endWeekStart.subtract(const Duration(days: 7 * (weekCount - 1)));

    // weeks[c][r] -> DateTime for column c (oldest->newest), row r (Mon->Sun)
    final weeks = List.generate(weekCount, (c) {
      final weekStart = start.add(Duration(days: 7 * c));
      return List.generate(7, (r) => weekStart.add(Duration(days: r)));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: List.generate(7, (i) {
                return Container(
                  width: 14,
                  height: 10,
                  margin: const EdgeInsets.only(bottom: 3),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _dayLabels[i],
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                      height: 1,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cols = weeks.length;
                  const gap = 3.0;
                  final cell = ((constraints.maxWidth - gap * (cols - 1)) / cols)
                      .clamp(6.0, 12.0);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(cols, (c) {
                      return Padding(
                        padding: EdgeInsets.only(right: c == cols - 1 ? 0 : gap),
                        child: Column(
                          children: List.generate(7, (r) {
                            final day = weeks[c][r];
                            final isFuture = day.isAfter(now);
                            final level = isFuture ? 0 : _sampleLevel(day);
                            return Container(
                              width: cell,
                              height: 10,
                              margin: const EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                color: _colorFor(level, isFuture: isFuture),
                                borderRadius: BorderRadius.circular(2),
                                border: (level == 0)
                                    ? Border.all(
                                        color: AppColors.ink.withValues(
                                          alpha: isFuture ? 0.04 : 0.08,
                                        ),
                                        width: 1,
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const SizedBox(width: 20),
            const Text(
              'Less',
              style: TextStyle(
                fontFamily: 'IBM Plex Mono',
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(width: 4),
            for (final level in [0, 1, 2, 3]) ...[
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: _colorFor(level, isFuture: false),
                  borderRadius: BorderRadius.circular(2),
                  border: level == 0
                      ? Border.all(
                          color: AppColors.ink.withValues(alpha: 0.08),
                          width: 1,
                        )
                      : null,
                ),
              ),
            ],
            const SizedBox(width: 4),
            const Text(
              'More',
              style: TextStyle(
                fontFamily: 'IBM Plex Mono',
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
