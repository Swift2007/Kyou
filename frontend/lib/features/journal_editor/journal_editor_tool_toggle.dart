// Responsibility: Floating editor tool toggle with badge and long-press hint hook.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorToolToggle extends StatefulWidget {
  final bool open;
  final VoidCallback onToggled;
  final VoidCallback? onLongPress;
  final int badgeCount;

  const JournalEditorToolToggle({
    super.key,
    required this.open,
    required this.onToggled,
    this.onLongPress,
    this.badgeCount = 0,
  });

  @override
  State<JournalEditorToolToggle> createState() => _JournalEditorToolToggleState();
}

class _JournalEditorToolToggleState extends State<JournalEditorToolToggle> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final scale = _pressed && !widget.open ? 0.94 : 1.0;
    return GestureDetector(
      onTap: widget.onToggled,
      onLongPressStart: (_) => _setPressed(true),
      onLongPressEnd: (_) => _setPressed(false),
      onLongPressCancel: () => _setPressed(false),
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.ink, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 140),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: Text(
                    widget.open ? '×' : '+',
                    key: ValueKey<bool>(widget.open),
                    style: TextStyle(fontFamily: 'Inter', fontSize: widget.open ? 22 : 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.surface,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
            if (!widget.open && widget.badgeCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 18, minHeight: 18),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.surface, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.badgeCount}',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.surface,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
