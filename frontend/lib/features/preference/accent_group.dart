// Responsibility: ACCENT COLOR group — accent color swatches.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class AccentGroup extends StatelessWidget {
  const AccentGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        AccentSwatch(label: 'Original', color: AppColors.background, isSelected: false),
        AccentSwatch(label: 'Electric', color: AppColors.accent, isSelected: true),
        AccentSwatch(label: 'Vibrant', color: AppColors.accent),
        AccentSwatch(label: 'Cherry', color: AppColors.accent),
        AccentSwatch(label: 'Lime', color: AppColors.accent),
        AccentSwatch(label: 'Hot', color: AppColors.accent),
        AccentSwatch(label: 'Golden', color: AppColors.accent),
        AccentSwatch(label: 'Teal', color: AppColors.accent),
      ],
    );
  }
}

class AccentSwatch extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;

  const AccentSwatch({
    super.key,
    required this.label,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.ink, width: 3),
            boxShadow: const [
              BoxShadow(
                color: AppColors.ink,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: isSelected
              ? const Center(
                  child: Text(
                    '✓',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}
