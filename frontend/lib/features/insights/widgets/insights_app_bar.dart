// Responsibility: Insights screen app bar — "INSIGHTS" title in Anton font,
// matching the OpenPencil Home UI prototype. Extracted from insights_screen.dart.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';

class InsightsAppBar extends ConsumerWidget {
  const InsightsAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          // "INSIGHTS" title in Anton matching OpenPencil 0:1155
          Expanded(
            child: Text(
              'INSIGHTS',
              style: TextStyle(
                fontFamily: 'Anton',
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -1,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
