import 'package:flutter/material.dart';

/// Centralized color palette for the Plantum Smart Greenhouse app.
/// Matches the modern, clean aesthetic from the new reference design.
class AppColors {
  AppColors._();

  // Screen background & surfaces
  static const Color background = Color(0xFFF4F6F5); // Soft grayish-green background
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFECECEC);

  // Brand Greens
  static const Color brandGreen = Color(0xFF1B4D21); // Logo text
  static const Color brandIconGreen = Color(0xFF388E3C); // Sprout logo
  static const Color navActiveGreen = Color(0xFF2E7D32); // Bottom nav active

  // Toast / notification banner
  static const Color toastGreen = Color(0xFF7DF292);
  static const Color toastText = Color(0xFF133C1A);

  // Switch Toggle
  static const Color switchActive = Color(0xFF7772B4); // Slate purple for Control screen
  static const Color switchInactive = Color(0xFFCECECE);
  static const Color switchThumb = Color(0xFFF7F8FA);

  // 3D Viewport Dark Box
  static const Color darkViewport = Color(0xFF1E1E1E);

  // Sensor Card Colors (New White Card Style)
  static const Color cardBg = Colors.white;
  static const Color cardBorder = Color(0xFFE8ECEA);

  // Card Accent Colors
  static const Color tempAccent = Color(0xFFE55950);     // Coral Red
  static const Color humidityAccent = Color(0xFF3B9AE1); // Sky Blue
  static const Color soilAccent = Color(0xFF4CAF50);     // Fresh Green
  static const Color lightAccent = Color(0xFFF5A623);    // Warm Amber/Orange

  // Card Typography Colors
  static const Color cardTitle = Color(0xFF6B7770);  // 13px w500 grey
  static const Color cardValue = Color(0xFF1A241E);  // 28px w700 dark charcoal
  static const Color cardTarget = Color(0xFF8C9690); // 11-12px w500 subtitle

  // Status Badge Colors ("Norm")
  static const Color badgeGreenBg = Color(0xFFE8F5E9);
  static const Color badgeGreenText = Color(0xFF2E7D32);

  // Condition Tiles (Control Screen)
  static const Color conditionTileBg = Color(0xFFEDEDED);
  static const Color conditionBadgeBg = Color(0xFFDFE2E6);

  // General text colors
  static const Color textPrimary = Color(0xFF1A241E);
  static const Color textSecondary = Color(0xFF6B7770);
  static const Color textMuted = Color(0xFF8C9690);

  // Actuator Icons
  static const Color waterBlue = Color(0xFF3B9AE1);
  static const Color lightYellow = Color(0xFFF5A623);
  static const Color fanGreen = Color(0xFF4CAF50);
}
