// Responsibility: Editor footer — similar entries affordance and word/min stats.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorStats extends StatelessWidget {
  final String bodyText;
  final bool hasContent;

  const JournalEditorStats({
    super.key,
    required this.bodyText,
    this.hasContent = false,
  });

  int get _wordCount {
    final trimmed = bodyText.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  int get _minuteCount {
    if (_wordCount == 0) return 0;
    final minutes = (_wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  @override
  Widget build(BuildContext context) {
    final metaStyle = TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 10,
      fontWeight: FontWeight.w400,
      color: AppColors.muted,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: hasContent ? AppColors.background : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasContent ? AppColors.ink : AppColors.rule,
              width: hasContent ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasContent) ...[
                const Icon(Icons.history, size: 12, color: AppColors.muted),
                const SizedBox(width: 6),
              ],
              Text('2 similar past entries ›', style: metaStyle),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Text('$_wordCount words · $_minuteCount min', style: metaStyle),
        ),
      ],
    );
  }
}
