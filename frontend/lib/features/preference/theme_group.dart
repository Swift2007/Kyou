// Responsibility: THEME group — theme mode chips + paper tone color swatches.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class ThemeGroup extends StatelessWidget {
  const ThemeGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Theme mode — horizontal segmented row
        const ThemeModeRow(),
        const SizedBox(height: 14),
        // Theme colors — label + swatch grid
        Row(children: [Text('Paper tone', style: AppTextStyles.caption())]),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ColorSwatch(
              label: 'Warm',
              color: AppColors.background,
              isSelected: true,
            ),
            ColorSwatch(label: 'Butter', color: AppColors.surface),
            ColorSwatch(label: 'Soft', color: AppColors.surface),
            ColorSwatch(label: 'Sage', color: AppColors.background),
            ColorSwatch(label: 'Sky', color: AppColors.background),
            ColorSwatch(label: 'Peach', color: AppColors.background),
            ColorSwatch(label: 'Rose', color: AppColors.background),
            ColorSwatch(label: 'Terracotta', color: AppColors.background),
            ColorSwatch(label: 'Mint', color: AppColors.background),
            ColorSwatch(label: 'Cobalt', color: AppColors.background),
          ],
        ),
      ],
    );
  }
}

class ThemeModeRow extends StatelessWidget {
  const ThemeModeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ThemeModeChip(
            label: 'Light',
            icon: '☀',
            isSelected: true,
            previewColor: AppColors.background,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ThemeModeChip(
            label: 'Dark',
            icon: '🌙',
            isSelected: false,
            previewColor: AppColors.ink,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ThemeModeChip(
            label: 'System',
            icon: '📱',
            isSelected: false,
            previewColor: AppColors.surface,
          ),
        ),
      ],
    );
  }
}

class ThemeModeChip extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final Color previewColor;

  const ThemeModeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.previewColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.ink, width: 2),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ]
              : const [],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: previewColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.ink, width: 2),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.ink, width: 2),
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? const Center(
                        child: Text(
                          '✓',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorSwatch extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;

  const ColorSwatch({
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
