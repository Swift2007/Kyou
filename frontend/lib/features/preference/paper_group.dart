// Responsibility: EDITOR APPEARANCE group — journal paper swatches (lines/dots).
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class PaperGroup extends StatelessWidget {
  const PaperGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        PaperSwatch(
          label: 'Cream',
          color: AppColors.background,
          isSelected: true,
          hasLines: false,
          hasDots: false,
        ),
        PaperSwatch(
          label: 'Warm',
          color: AppColors.surface,
          isSelected: false,
          hasLines: false,
          hasDots: false,
        ),
        PaperSwatch(
          label: 'Ivory',
          color: AppColors.surface,
          isSelected: false,
          hasLines: true,
          hasDots: false,
        ),
        PaperSwatch(
          label: 'Dot',
          color: AppColors.surface,
          isSelected: false,
          hasLines: false,
          hasDots: true,
        ),
        PaperSwatch(
          label: 'Sepia',
          color: AppColors.background,
          isSelected: false,
          hasLines: false,
          hasDots: false,
        ),
        PaperSwatch(
          label: 'Night',
          color: AppColors.ink,
          isSelected: false,
          hasLines: false,
          hasDots: false,
        ),
      ],
    );
  }
}

class PaperSwatch extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final bool hasLines;
  final bool hasDots;

  const PaperSwatch({
    super.key,
    required this.label,
    required this.color,
    this.isSelected = false,
    this.hasLines = false,
    this.hasDots = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
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
          child: Stack(
            children: [
              if (hasLines) ...[
                Positioned(
                  top: 8,
                  left: 5,
                  right: 5,
                  child: Container(width: 38, height: 1, color: AppColors.ink),
                ),
                Positioned(
                  top: 16,
                  left: 5,
                  right: 5,
                  child: Container(width: 38, height: 1, color: AppColors.ink),
                ),
                Positioned(
                  top: 24,
                  left: 5,
                  right: 5,
                  child: Container(width: 38, height: 1, color: AppColors.ink),
                ),
                Positioned(
                  top: 32,
                  left: 5,
                  right: 5,
                  child: Container(width: 38, height: 1, color: AppColors.ink),
                ),
              ],
              if (hasDots) ...[
                Positioned(top: 6, left: 6, child: _dot()),
                Positioned(top: 14, left: 6, child: _dot()),
                Positioned(top: 22, left: 6, child: _dot()),
                Positioned(top: 30, left: 6, child: _dot()),
                Positioned(top: 38, left: 6, child: _dot()),
                Positioned(top: 46, left: 6, child: _dot()),
              ],
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.ink, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '✓',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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

  Widget _dot() {
    return Container(width: 3, height: 3, color: AppColors.ink);
  }
}
