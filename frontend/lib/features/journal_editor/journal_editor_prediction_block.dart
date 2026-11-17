// Responsibility: Prediction contextual block for the journal editor.
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

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
              Expanded(
                child: Text(
                  'I PREDICT…',
                  style: GoogleFonts.ibmPlexMono(
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
            style: GoogleFonts.newsreader(
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
            children: [
              _InfoChip(label: dueLabel, selected: false),
              for (final option in confidenceOptions)
                GestureDetector(
                  onTap: () => onConfidenceChanged(option),
                  child: _InfoChip(
                    label: option == confidence
                        ? 'Confidence: $option'
                        : option,
                    selected: option == confidence,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _InfoChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.accent : AppColors.surface;
    final fg = selected ? AppColors.surface : AppColors.ink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Text(
        label,
        style: GoogleFonts.ibmPlexMono(
          fontSize: 10,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: fg,
        ),
      ),
    );
  }
}
