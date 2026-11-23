// Responsibility: Prediction contextual block for the journal editor.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorPredictionBlock extends StatelessWidget {
  final String predictionText;
  final String dueLabel;
  final String confidence;
  final List<String> confidenceOptions;
  final ValueChanged<String> onConfidenceChanged;
  final VoidCallback? onRemove;

  const JournalEditorPredictionBlock({
    super.key,
    required this.predictionText,
    required this.dueLabel,
    required this.confidence,
    required this.confidenceOptions,
    required this.onConfidenceChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'I PREDICT…',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              if (onRemove != null)
                GestureDetector(
                  onTap: onRemove,
                  behavior: HitTestBehavior.opaque,
                  child: const Icon(Icons.close, size: 16, color: AppColors.muted),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            predictionText,
            style: const TextStyle(
              fontFamily: 'Newsreader',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.ink,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _InfoChip(label: dueLabel, selected: false, kind: _ChipKind.neutral),
              for (final option in confidenceOptions)
                GestureDetector(
                  onTap: () => onConfidenceChanged(option),
                  child: _InfoChip(
                    label: option == confidence ? 'Confidence: $option' : option,
                    selected: option == confidence,
                    kind: _ChipKind.confidence,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _ChipKind { neutral, confidence }

class _InfoChip extends StatelessWidget {
  final String label;
  final bool selected;
  final _ChipKind kind;

  const _InfoChip({
    required this.label,
    required this.selected,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
    final isConfidenceSelected = kind == _ChipKind.confidence && selected;
    final bg = isConfidenceSelected ? AppColors.accent : AppColors.surface;
    final fg = isConfidenceSelected ? AppColors.surface : AppColors.ink;
    final fontWeight = isConfidenceSelected
        ? FontWeight.w700
        : (kind == _ChipKind.neutral ? FontWeight.w600 : FontWeight.w500);
    final fontFamily = kind == _ChipKind.neutral ? 'Inter' : 'Inter';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: fontWeight,
          color: fg,
        ),
      ),
    );
  }
}
