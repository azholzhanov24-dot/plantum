import 'package:flutter/material.dart';

/// Central theme definitions for Plantum (Light & Dark modes).
class AppTheme {
  AppTheme._();

  // Primary colors
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8ECEA);
  static const Color lightTextPrimary = Color(0xFF1A1D1A);
  static const Color lightTextSecondary = Color(0xFF6B756C);
  static const Color lightSubtle = Color(0xFFF2F4F1);
  static const Color lightGreen = Color(0xFF2E7D32);
  static const Color lightGreenSoft = Color(0xFFE8F5E9);

  static const Color darkBg = Color(0xFF121412);
  static const Color darkCard = Color(0xFF1C1F1C);
  static const Color darkBorder = Color(0xFF2C302C);
  static const Color darkTextPrimary = Color(0xFFF2F4F2);
  static const Color darkTextSecondary = Color(0xFF9AA19A);
  static const Color darkSubtle = Color(0xFF252927);
  static const Color darkGreen = Color(0xFF66BB6A);
  static const Color darkGreenSoft = Color(0x294CAF50); // ~16% green

  // Light ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      cardColor: lightCard,
      dividerColor: lightBorder,
      colorScheme: const ColorScheme.light(
        surface: lightCard,
        primary: lightGreen,
        secondary: Color(0xFF388E3C),
        error: Color(0xFFE55950),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      fontFamily: 'Roboto',
    );
  }

  // Dark ThemeData
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      dividerColor: darkBorder,
      colorScheme: const ColorScheme.dark(
        surface: darkCard,
        primary: darkGreen,
        secondary: Color(0xFF4CAF50),
        error: Color(0xFFEF5350),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      fontFamily: 'Roboto',
    );
  }
}

/// Handy extension on [BuildContext] to access adaptive colors easily anywhere.
extension ThemeContextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bgColor => isDark ? AppTheme.darkBg : AppTheme.lightBg;
  Color get surfaceColor => isDark ? AppTheme.darkCard : AppTheme.lightCard;
  Color get subtleSurfaceColor => isDark ? AppTheme.darkSubtle : AppTheme.lightSubtle;
  Color get textPrimaryColor => isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  Color get textSecondaryColor => isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
  Color get dividerLineColor => isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
  Color get brandGreenColor => isDark ? AppTheme.darkGreen : AppTheme.lightGreen;
  Color get greenSoftColor => isDark ? AppTheme.darkGreenSoft : AppTheme.lightGreenSoft;

  Color get logoutBgColor => isDark ? const Color(0xFF2D1B1B) : const Color(0xFFFFEBEE);
  Color get logoutTextColor => isDark ? const Color(0xFFEF5350) : const Color(0xFFD32F2F);
}
