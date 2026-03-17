import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand palette - Navy & Teal/Cyan theme
  static const Color primary = Color(0xFF00C9A7); // Teal
  static const Color primaryLight = Color(0xFF0096FF); // Cyan
  static const Color primaryDark = Color(0xFF007A8A);

  static const Color secondary = Color(0xFF0096FF); // Cyan
  static const Color secondaryLight = Color(0xFF33B5FF);
  static const Color secondaryDark = Color(0xFF0072C6);

  // Backgrounds - Deep Navy
  static const Color background = Color(0xFF0D1B2A);
  static const Color surface = Color(0xFF1B263B);
  static const Color surfaceVariant = Color(0xFF415A77);

  // Text - Warm White
  static const Color textPrimary = Color(0xFFF8FAFB);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textDisabled = Color(0xFF71717A);

  // Status colours
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Dose status
  static const Color taken = Color(0xFF10B981);
  static const Color skipped = Color(0xFFEF4444);
  static const Color pending = Color(0xFFF59E0B);

  // Borders & dividers
  static const Color border = Color(0x33FFFFFF); // 20% white for glass border
  static const Color divider = Color(0x1AFFFFFF); // 10% white

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00C9A7), Color(0xFF0096FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient progressGradient = LinearGradient(
    colors: [Color(0xFF00C9A7), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
