// Responsibility: Past-self reply contextual card for the journal editor.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorReplyCard extends StatelessWidget {
  final String sourceLabel;
  final String quote;
  final VoidCallback? onRemove;

  const JournalEditorReplyCard({
    super.key,
    required this.sourceLabel,
    required this.quote,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: AppColors.accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            sourceLabel,
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        if (onRemove != null)
                          GestureDetector(
                            onTap: onRemove,
                            behavior: HitTestBehavior.opaque,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quote,
                      style: const TextStyle(
                        fontFamily: 'Newsreader',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted,
                        height: 18 / 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
