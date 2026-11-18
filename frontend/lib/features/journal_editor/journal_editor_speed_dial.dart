// Responsibility: Speed dial scrim and stacked action menu for the journal editor.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorSpeedDialScrim extends StatelessWidget {
  final VoidCallback onClose;

  const JournalEditorSpeedDialScrim({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          color: const Color(0xFFF7F1E3).withValues(alpha: 0.72),
        ),
      ),
    );
  }
}

class JournalEditorSpeedDial extends StatelessWidget {
  final bool open;
  final VoidCallback onClosed;
  final String? selectedMood;
  final int attachmentCount;
  final bool hasPrediction;
  final bool hasReply;
  final VoidCallback onAttach;
  final VoidCallback onVoice;
  final VoidCallback onMood;
  final VoidCallback onTag;
  final VoidCallback onPredict;
  final VoidCallback onReply;

  const JournalEditorSpeedDial({
    super.key,
    required this.open,
    required this.onClosed,
    required this.selectedMood,
    this.attachmentCount = 0,
    this.hasPrediction = false,
    this.hasReply = false,
    required this.onAttach,
    required this.onVoice,
    required this.onMood,
    required this.onTag,
    required this.onPredict,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final moodLabel = 'Mood: ${selectedMood ?? 'Select'}';
    final attachLabel = attachmentCount > 0 ? 'Attach ($attachmentCount)' : 'Attach';
    final predictLabel = hasPrediction ? 'Predict ✓' : 'Predict';

    final actions = <_SpeedDialActionData>[
      _SpeedDialActionData(
        label: attachLabel,
        icon: Icons.attach_file_outlined,
        onTap: onAttach,
      ),
      _SpeedDialActionData(
        label: 'Voice',
        icon: Icons.mic_none_outlined,
        onTap: onVoice,
      ),
      _SpeedDialActionData(
        label: moodLabel,
        icon: Icons.mood_outlined,
        onTap: onMood,
      ),
      _SpeedDialActionData(
        label: 'Tag',
        icon: Icons.sell_outlined,
        onTap: onTag,
      ),
      _SpeedDialActionData(
        label: predictLabel,
        icon: Icons.auto_awesome_outlined,
        onTap: onPredict,
        signature: true,
        active: hasPrediction,
      ),
      _SpeedDialActionData(
        label: 'Reply',
        icon: Icons.reply_outlined,
        onTap: onReply,
        signature: true,
        active: hasReply,
      ),
    ];

    return Positioned(
      right: 24,
      bottom: 88,
      child: IgnorePointer(
        ignoring: !open,
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < actions.length; i++)
                _AnimatedSpeedDialItem(
                  open: open,
                  index: i,
                  total: actions.length,
                  child: _SpeedDialItem(data: actions[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedDialActionData {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool signature;
  final bool active;

  const _SpeedDialActionData({
    required this.label,
    required this.icon,
    required this.onTap,
    this.signature = false,
    this.active = false,
  });
}

class _AnimatedSpeedDialItem extends StatelessWidget {
  final bool open;
  final int index;
  final int total;
  final Widget child;

  const _AnimatedSpeedDialItem({
    required this.open,
    required this.index,
    required this.total,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final reverseIndex = total - 1 - index;
    final durationMs = 180 + reverseIndex * 12;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: open ? 1 : 0),
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        final dy = (1 - t) * 10;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: 0.96 + 0.04 * t,
              alignment: Alignment.bottomRight,
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: index == total - 1 ? 0 : 10),
        child: child,
      ),
    );
  }
}

class _SpeedDialItem extends StatelessWidget {
  final _SpeedDialActionData data;

  const _SpeedDialItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final accentButton = data.active || data.signature;
    final buttonBg = accentButton ? AppColors.accent : AppColors.surface;
    final buttonFg = accentButton ? AppColors.surface : AppColors.ink;
    final radius = data.signature
        ? BorderRadius.circular(10)
        : BorderRadius.circular(24);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.ink, width: 2),
            boxShadow: const [
              BoxShadow(
                color: AppColors.ink,
                offset: Offset(2, 2),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            data.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: data.onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: buttonBg,
              borderRadius: radius,
              border: Border.all(color: AppColors.ink, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.ink,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Icon(data.icon, size: 20, color: buttonFg),
          ),
        ),
      ],
    );
  }
}
