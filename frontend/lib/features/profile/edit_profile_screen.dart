// Responsibility: Renders the Edit Profile screen matching the OpenPencil
// Home UI prototype exactly (frame 0:1452, 390x844).
// No status bar per user instruction.
//
// Structure from OpenPencil:
// - App bar: "Edit profile" title with back arrow (←) and Save button
// - Avatar: 112×112 ellipse with "S" initial + "Change photo" badge
// - Display name field: 342×52, label "Display name", value "Sam Smith"
// - Username field: 342×52, label "Username", value "@samsmith"
// - About me field: 342×96, label "About me", value "Writing a few honest lines every day.", counter "37 / 160"
// - Email field: 342×52, label "Email", value "sam.smith@email.com"
// - Verified badge: 78×24 with ✓ + "Verified" + "Managed by your login"
// - Save changes button (footer): 342×52, "Save changes"
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // App bar — "Edit profile" title with back arrow and Save button
            const _EditProfileAppBar(),
            const SizedBox(height: 18),
            // Avatar + edit badge
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _EditProfileAvatar(),
            ),
            const SizedBox(height: 24),
            // Form fields
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _EditProfileForm(),
            ),
            const SizedBox(height: 24),
            // Verified badge section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _VerifiedBadge(),
            ),
            const Spacer(),
            // Save changes button (footer)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _SaveChangesButton(),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _EditProfileAppBar extends ConsumerWidget {
  const _EditProfileAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          // Back arrow (←)
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: const Text(
                '←',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Title "Edit profile"
          const Text(
            'Edit profile',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          // Save button (top right) — disabled state (no shadow, muted)
          Container(
            width: 56,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.muted, width: 2),
              boxShadow: const [],
            ),
            child: const Center(
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileAvatar extends StatelessWidget {
  const _EditProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar circle — "S" initial, 112×112
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.ink, width: 3),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 66,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            // Edit photo badge — bottom right corner
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.ink, width: 2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '✎',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Change photo',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  const _EditProfileForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Display name field
        _EditProfileField(
          label: 'Display name',
          value: 'Sam Smith',
          counter: '37 / 160',
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        // Username field
        _EditProfileField(label: 'Username', value: 'samsmith', prefix: '@'),
        const SizedBox(height: 16),
        // Email field (read-only)
        _EditProfileField(
          label: 'Email',
          value: 'sam.smith@email.com',
          readOnly: true,
        ),
      ],
    );
  }
}

class _EditProfileField extends StatelessWidget {
  final String label;
  final String value;
  final String? counter;
  final String? prefix;
  final bool readOnly;
  final int? maxLines;

  const _EditProfileField({
    required this.label,
    required this.value,
    this.counter,
    this.prefix,
    this.readOnly = false,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(label, style: AppTextStyles.caption()),
        const SizedBox(height: 8),
        // Field input container
        Container(
          width: 342,
          height: maxLines != null ? 96 : 52,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.ink, width: 3),
            boxShadow: const [
              BoxShadow(
                color: AppColors.ink,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (prefix != null) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prefix!, style: AppTextStyles.caption()),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          value,
                          style: AppTextStyles.body(),
                          maxLines: maxLines ?? 1,
                          overflow: maxLines != null
                              ? TextOverflow.ellipsis
                              : null,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    value,
                    style: AppTextStyles.body(),
                    maxLines: maxLines ?? 1,
                    overflow: maxLines != null ? TextOverflow.ellipsis : null,
                  ),
                ],
                if (counter != null) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      counter!,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted,
                        height: 17 / 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.muted, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '✓',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Verified',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveChangesButton extends StatelessWidget {
  const _SaveChangesButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 342,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.ink, width: 3),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Save changes',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
