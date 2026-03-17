import 'package:flutter/material.dart';
import 'constants/app_colors.dart';

const _headingFont = 'Plus Jakarta Sans';
const _bodyFont = 'DM Sans';

ThemeData buildAppTheme() {
  const baseTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: _headingFont,
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      letterSpacing: -1.0,
    ),
    displayMedium: TextStyle(
      fontFamily: _headingFont,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      fontFamily: _headingFont,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      letterSpacing: -0.5,
    ),
    titleLarge: TextStyle(
      fontFamily: _headingFont,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: _headingFont,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: _headingFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontFamily: _bodyFont,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: _bodyFont,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontFamily: _bodyFont,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontFamily: _headingFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontFamily: _headingFont,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
    labelSmall: TextStyle(
      fontFamily: _headingFont,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: _bodyFont,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.textSecondary,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
      scrim: Colors.black54,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: baseTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        fontFamily: _headingFont,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: _headingFont,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: _headingFont,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontFamily: _headingFont,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface.withValues(alpha: 0.5),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: const TextStyle(
        fontFamily: _bodyFont,
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      hintStyle: const TextStyle(
        fontFamily: _bodyFont,
        fontSize: 14,
        color: AppColors.textDisabled,
      ),
      errorStyle: const TextStyle(
        fontFamily: _bodyFont,
        fontSize: 12,
        color: AppColors.error,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface.withValues(alpha: 0.3),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border),
      ),
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: const TextStyle(
        fontFamily: _headingFont,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: _headingFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      contentTextStyle: const TextStyle(
        fontFamily: _bodyFont,
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
    ),
  );
}
