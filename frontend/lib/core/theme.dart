// Responsibility: Defines the Material 3 theme, with all app colors and text styles as named constants.
import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Core palette (restyle later from Figma by changing values here).
  static const Color creamBackground = Color(0xFFF7F1E3);
  static const Color surface = Color(0xFFFFFBF4);
  static const Color darkInk = Color(0xFF1F2433);
  static const Color inkMuted = Color(0xFF5B6173);
  static const Color orangePrimary = Color(0xFFE07A2F);
  static const Color orangePrimaryDark = Color(0xFFC7661F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFD7CFC0);
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
}

class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.darkInk,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w600,
    color: AppColors.darkInk,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.darkInk,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.45,
    fontWeight: FontWeight.w400,
    color: AppColors.darkInk,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.45,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: AppColors.darkInk,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );
}

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.orangePrimary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.orangePrimaryDark,
    onSecondary: AppColors.onPrimary,
    error: AppColors.error,
    onError: AppColors.onError,
    surface: AppColors.surface,
    onSurface: AppColors.darkInk,
    outline: AppColors.outline,
    outlineVariant: AppColors.outline,
    surfaceContainerHighest: AppColors.creamBackground,
    onSurfaceVariant: AppColors.inkMuted,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.creamBackground,
    canvasColor: AppColors.creamBackground,
    textTheme: const TextTheme(
      displaySmall: AppTextStyles.display,
      headlineSmall: AppTextStyles.headline,
      titleLarge: AppTextStyles.headline,
      titleMedium: AppTextStyles.title,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.bodyMuted,
      labelLarge: AppTextStyles.label,
      labelMedium: AppTextStyles.label,
      labelSmall: AppTextStyles.caption,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.creamBackground,
      foregroundColor: AppColors.darkInk,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.orangePrimary,
        foregroundColor: AppColors.onPrimary,
        textStyle: AppTextStyles.label,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.orangePrimary,
          width: 1.5,
        ),
      ),
      labelStyle: AppTextStyles.bodyMuted,
    ),
    dividerColor: AppColors.outline,
  );
}
