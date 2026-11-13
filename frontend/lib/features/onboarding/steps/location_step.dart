// Responsibility: Collects the user's approximate location during onboarding (step 3 of 6).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_viewmodel.dart';
import '../widgets/onboarding_widgets.dart';

class LocationStep extends ConsumerStatefulWidget {
  const LocationStep({
    super.key,
    required this.onBack,
    required this.onContinue,
  });

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  ConsumerState<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends ConsumerState<LocationStep> {
  late final TextEditingController _country;
  late final TextEditingController _city;
  String _timeZone = '';
  bool _showPermission = false;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingViewModelProvider).data;
    _country = TextEditingController(text: data.country);
    _city = TextEditingController(text: data.city);
    _timeZone = data.timeZone;
    _country.addListener(() => setState(() {}));
    _city.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _country.dispose();
    _city.dispose();
    super.dispose();
  }

  void _save() {
    final vm = ref.read(onboardingViewModelProvider.notifier);
    final data = ref.read(onboardingViewModelProvider).data;
    vm.updateData(
      data.copyWith(
        country: _country.text.trim(),
        city: _city.text.trim(),
        timeZone: _timeZone.trim(),
      ),
    );
  }

  void _applyStubLocation() {
    setState(() {
      _country.text = 'Malawi';
      _city.text = 'Blantyre';
      _timeZone = 'Africa/Blantyre, UTC+2';
      _showPermission = false;
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OnboardingScaffold(
          step: 3,
          totalSteps: 6,
          onBack: () {
            _save();
            widget.onBack();
          },
          continueLabel: 'Continue',
          continueEnabled: true,
          onContinue: () {
            _save();
            widget.onContinue();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const OnboardingHeadline('Where in the world are you?'),
              const SizedBox(height: 6),
              const OnboardingSubtitle('This helps with time and reminders.'),
              const SizedBox(height: 28),
              const WhyWeAskSticker(
                message: 'We use your approximate area to set your time zone and reminders.',
              ),
              const SizedBox(height: 18),
              const OnbFieldLabel('Country'),
              const SizedBox(height: 6),
              OnbFieldBox(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _country,
                        textInputAction: TextInputAction.next,
                        style: GoogleFonts.caveat(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: OnbColors.ink,
                          height: 24 / 22,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Select country',
                          hintStyle: GoogleFonts.caveat(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: _country.text.trim().isEmpty
                                ? OnbColors.ink
                                : OnbColors.muted,
                            height: 24 / 22,
                          ),
                        ),
                      ),
                    ),
                    if (_country.text.trim().isEmpty)
                      Text(
                        '⌄',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: OnbColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const OnbFieldLabel('City (optional)'),
              const SizedBox(height: 6),
              OnbFieldBox(
                child: TextField(
                  controller: _city,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _save();
                    widget.onContinue();
                  },
                  style: GoogleFonts.caveat(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: OnbColors.ink,
                    height: 24 / 22,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: '',
                    hintStyle: GoogleFonts.caveat(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: OnbColors.muted,
                      height: 24 / 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _UseLocationButton(
                onPressed: () => setState(() => _showPermission = true),
              ),
              if (_timeZone.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                _TimeZoneSticker(
                  timeZone: _timeZone,
                  onChange: () {
                    // Allow manual adjustment by clearing; user can re-detect or type.
                    setState(() => _timeZone = '');
                    _save();
                  },
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Only your approximate area is kept, never exact coordinates.',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  color: OnbColors.muted,
                ),
              ),
            ],
          ),
        ),
        if (_showPermission)
          _LocationPermissionOverlay(
            onAllow: _applyStubLocation,
            onDeny: () => setState(() => _showPermission = false),
          ),
      ],
    );
  }
}

class _UseLocationButton extends StatelessWidget {
  const _UseLocationButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: OnbColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: OnbColors.ink, width: 2),
          boxShadow: [hardShadow(x: 2, y: 2)],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Text(
                '◎  Use my location',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OnbColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeZoneSticker extends StatelessWidget {
  const _TimeZoneSticker({required this.timeZone, required this.onChange});
  final String timeZone;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          constraints: const BoxConstraints(minHeight: 30),
          decoration: BoxDecoration(
            color: OnbColors.privacy,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: OnbColors.ink, width: 2),
            boxShadow: [hardShadow(x: 2, y: 2)],
          ),
          child: Text(
            timeZone,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: OnbColors.ink,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onChange,
          child: Text(
            'Change',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: OnbColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationPermissionOverlay extends StatelessWidget {
  const _LocationPermissionOverlay({
    required this.onAllow,
    required this.onDeny,
  });
  final VoidCallback onAllow;
  final VoidCallback onDeny;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: OnbColors.dim,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 44),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                decoration: BoxDecoration(
                  color: OnbColors.page,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: OnbColors.ink, width: 3),
                  boxShadow: [hardShadow(x: 6, y: 6)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: OnbColors.card,
                        shape: BoxShape.circle,
                        border: Border.all(color: OnbColors.ink, width: 2),
                        boxShadow: [hardShadow(x: 2, y: 2)],
                      ),
                      child: Text(
                        '◎',
                        style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: OnbColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Allow location access?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: OnbColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We only keep your approximate area to set your time zone. Never exact coordinates.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.newsreader(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: OnbColors.muted,
                        height: 21 / 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: _DialogButton(
                        label: 'Allow',
                        filled: true,
                        onPressed: onAllow,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: _DialogButton(
                        label: "Don't allow",
                        filled: false,
                        onPressed: onDeny,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: filled ? OnbColors.accent : OnbColors.page,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OnbColors.ink, width: 2),
        boxShadow: filled ? [hardShadow(x: 3, y: 3)] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: filled ? OnbColors.onAccent : OnbColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
