import 'package:flutter/material.dart';

/// Centralized color palette for the Plantum Smart Greenhouse app.
/// Exact matches extracted and sampled from the Figma design.
class AppColors {
  AppColors._();

  // Screen background & surfaces
  static const Color background = Color(0xFFF5F7F5);
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
  static const Color switchActive = Color(0xFF7772B4); // Figma slate purple
  static const Color switchInactive = Color(0xFFCCCCCC);
  static const Color switchThumb = Color(0xFFF7F8FA);

  // 3D Viewport Dark Box
  static const Color darkViewport = Color(0xFF1E1E1E);

  // Sensor Card Gradients (Soft pastel & vibrant blends)
  static const Color tempCardStart = Color(0xFFFFA5A5);
  static const Color tempCardEnd = Color(0xFFFF7272);

  static const Color humidityCardStart = Color(0xFF90CAF9);
  static const Color humidityCardEnd = Color(0xFF64B5F6);

  static const Color soilCardStart = Color(0xFFB7F5BE);
  static const Color soilCardEnd = Color(0xFF8FE79A);

  static const Color lightCardStart = Color(0xFFFEE685);
  static const Color lightCardEnd = Color(0xFFF5CF47);

  // Condition Tiles
  static const Color conditionTileBg = Color(0xFFEDEDED);
  static const Color conditionBadgeBg = Color(0xFFDFE2E6);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textMuted = Color(0xFF888888);

  // Actuator Icons
  static const Color waterBlue = Color(0xFF2196F3);
  static const Color lightYellow = Color(0xFFFFB300);
  static const Color fanGreen = Color(0xFF43A047);
}
