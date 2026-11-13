// Responsibility: Defines the neobrutalist Material theme, with all app colors
// and text styles unified with the journal_kit OpenPencil Home UI palette.
//
// Colors match lib/core/widgets/journal_kit.dart exactly:
//   background #F3EEDF, surface #FFFDF5, ink #191916, muted #625F55,
//   accent #FF623C, rule #C6C1B3.
//
// Fonts: Inter (UI), IBM Plex Mono (monospace/dates), Caveat (display),
// Anton (headline condensed) — wired via google_fonts.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  const AppColors._();

  // Neobrutalist palette — unified with core/widgets/journal_kit.dart
  static const Color background = Color(0xFFF3EEDF);
  static const Color surface = Color(0xFFFFFDF5);
  static const Color ink = Color(0xFF191916);
  static const Color muted = Color(0xFF625F55);
  static const Color accent = Color(0xFFFF623C);
  static const Color rule = Color(0xFFC6C1B3);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF623C);
  static const Color onError = Color(0xFFFFFFFF);
}

class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'Inter';

  static TextStyle display({
    double fontSize = 56,
    FontWeight fontWeight = FontWeight.w800,
  }) =>
      GoogleFonts.anton(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.ink,
        letterSpacing: -1.5,
        height: 1.1,
      );

  static TextStyle headline({
    double fontSize = 40,
    FontWeight fontWeight = FontWeight.w800,
  }) =>
      GoogleFonts.anton(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.ink,
        letterSpacing: -1,
        height: 1.15,
      );

  static TextStyle title({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.ink,
      );

  static TextStyle body({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.ink,
        height: 1.5,
      );

  static TextStyle bodyMuted({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.muted,
        height: 1.5,
      );

  static TextStyle label({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.ink,
        letterSpacing: 0.5,
      );

  static TextStyle caption({
    double fontSize = 10,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      GoogleFonts.ibmPlexMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.muted,
        letterSpacing: 0.5,
      );

  static TextStyle mono({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.ibmPlexMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.ink,
        height: 1.4,
      );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ink,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onPrimary,
      onSurface: AppColors.ink,
      error: AppColors.error,
      onError: AppColors.onError,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.display(),
      headlineMedium: AppTextStyles.headline(),
      titleLarge: AppTextStyles.title(),
      bodyLarge: AppTextStyles.body(),
      bodyMedium: AppTextStyles.body(),
      bodySmall: AppTextStyles.bodyMuted(),
      labelLarge: AppTextStyles.label(),
      labelMedium: AppTextStyles.caption(),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        shadowColor: AppColors.ink,
        side: const BorderSide(color: AppColors.ink, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.ink, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: AppColors.ink, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: AppColors.muted, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: AppColors.ink, width: 3),
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.background,
      elevation: 0,
      shadowColor: AppColors.ink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        side: BorderSide(color: AppColors.ink, width: 2),
      ),
    ),
    dividerTheme: const DividerThemeData(
      space: 1,
      thickness: 1,
      color: AppColors.rule,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.ink,
      unselectedItemColor: AppColors.muted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
