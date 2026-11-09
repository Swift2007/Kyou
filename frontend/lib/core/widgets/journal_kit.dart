// Responsibility: Shares the journal-editorial tokens and widgets from the OpenPencil
// Home UI prototype across the welcome, sign-in, and sign-up screens.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Prototype palette for the journal editorial screens (Home UI page).
class JournalColors {
  JournalColors._();

  static const background = Color(0xFFF3EEDF);
  static const ink = Color(0xFF191916);
  static const muted = Color(0xFF625F55);
  static const accent = Color(0xFFFF623C);
  static const page = Color(0xFFFFFDF5);
  static const rule = Color(0xFFC6C1B3);
}

/// Masthead strip: brand note on the right above a 2px ink rule (Home UI prototype).
/// The provisional `[ UNTITLED ]` wordmark is intentionally omitted.
class JournalMasthead extends StatelessWidget {
  const JournalMasthead({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;
    return Container(
      height: compact ? 40 : 48,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: JournalColors.ink, width: 2)),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'WORKING TITLE.\nYOUR JOURNAL.',
          textAlign: TextAlign.right,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: JournalColors.muted,
            height: 12 / 10,
          ),
        ),
      ),
    );
  }
}

/// Two-line Anton headline with an accent-colored closing word, plus the
/// editorial note row (28x3 accent rule + mono label).
class JournalAccentHeadline extends StatelessWidget {
  const JournalAccentHeadline({
    super.key,
    required this.firstLine,
    required this.accentText,
    required this.note,
  });

  final String firstLine;
  final String accentText;
  final String note;

  @override
  Widget build(BuildContext context) {
    // Match the prototype's Anton headline scale; FittedBox.scaleDown keeps it
    // unscrollable/fitting on narrow or short screens (e.g. 360dp phones).
    // Uses screen width (not LayoutBuilder) to stay compatible with IntrinsicHeight.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final fontSize = ((screenWidth - 48) * 0.22).clamp(44.0, 76.0);
    final lineHeight = fontSize * (72 / 76);
    final text = Text.rich(
      TextSpan(
        style: GoogleFonts.anton(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: JournalColors.ink,
          height: lineHeight / fontSize,
          letterSpacing: -1.5 * (fontSize / 76),
        ),
        children: [
          TextSpan(text: firstLine),
          TextSpan(
            text: accentText,
            style: const TextStyle(color: JournalColors.accent),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: text,
        ),
        SizedBox(height: (10 * (fontSize / 76)).clamp(6.0, 18.0)),
        Row(
          children: [
            Container(width: 24, height: 3, color: JournalColors.accent),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: JournalColors.ink,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Filled accent action button with ink border, hard offset shadow, and
/// forward-arrow glyph — "Start journaling" / "Sign in" / "Create space".
class JournalPrimaryButton extends StatelessWidget {
  const JournalPrimaryButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: onPressed == null ? 0.55 : 1,
      duration: const Duration(milliseconds: 120),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: JournalColors.accent,
          border: Border.all(color: JournalColors.ink, width: 2),
          boxShadow: const [
            BoxShadow(
              color: JournalColors.ink,
              offset: Offset(6, 6),
              blurRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: JournalColors.ink,
                    ),
                  ),
                  const _ForwardArrow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Continue with Google" button. Signs in via Supabase OAuth when tapped.
class JournalGoogleButton extends StatelessWidget {
  const JournalGoogleButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: JournalColors.page,
        border: Border.all(color: JournalColors.ink, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: JournalColors.ink,
                      height: 17 / 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Two-part helper row between actions: muted question on the left, bold ink
/// action link on the right.
class JournalSecondaryRow extends StatelessWidget {
  const JournalSecondaryRow({
    super.key,
    required this.question,
    required this.action,
    required this.onAction,
  });

  final String question;
  final String action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            question,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: JournalColors.muted,
              height: 21 / 14,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: JournalColors.ink,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(44, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            action,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: JournalColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}

/// Editorial "writing line" input matching the Home UI auth prototype:
/// page-white box with a 2px ink stroke, mono label, Caveat handwriting value,
/// and a thin rule under the text.
class JournalTextField extends StatelessWidget {
  const JournalTextField({
    super.key,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autocorrect = true,
    this.validator,
    this.onSaved,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autocorrect;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final inputStyle = GoogleFonts.caveat(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: JournalColors.ink,
      height: 24 / 22,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 6),
      decoration: BoxDecoration(
        color: JournalColors.page,
        border: Border.all(color: JournalColors.ink, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: JournalColors.muted,
              letterSpacing: 0.8,
              height: 11 / 9,
            ),
          ),
          const SizedBox(height: 1),
          TextFormField(
            style: inputStyle,
            cursorColor: JournalColors.ink,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autocorrect: autocorrect,
            validator: validator,
            onSaved: onSaved,
            onChanged: onChanged,
            decoration: InputDecoration(
              isCollapsed: true,
              isDense: true,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hint,
              hintStyle: inputStyle.copyWith(color: JournalColors.muted),
              errorStyle: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.red.shade700,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 1, color: JournalColors.rule),
        ],
      ),
    );
  }
}

/// Footer strip of the prototype screens: mono note on the left, edition mark
/// on the right, under a 1px ink rule ("LESS SCROLLING. MORE FEELING." / "VOL. YOU").
class JournalClosingNote extends StatelessWidget {
  const JournalClosingNote({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;
    return Container(
      height: compact ? 40 : 48,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: JournalColors.ink, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'LESS SCROLLING. MORE FEELING.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: JournalColors.muted,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'VOL. YOU',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: JournalColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ForwardArrow extends StatelessWidget {
  const _ForwardArrow();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(25, 24),
      painter: _ForwardArrowPainter(),
    );
  }
}

class _ForwardArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = JournalColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    final path = Path()
      ..moveTo(0, 12)
      ..lineTo(25, 12)
      ..moveTo(15, 0)
      ..lineTo(25, 12)
      ..lineTo(15, 24);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
