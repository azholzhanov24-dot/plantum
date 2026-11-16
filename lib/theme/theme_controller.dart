import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

/// Controller for managing application theme mode (Light / Dark) and language preferences.
class ThemeController extends ChangeNotifier {
  static const String _themePrefKey = 'plantum_theme_mode';
  static const String _langPrefKey = 'plantum_language_code';

  ThemeMode _themeMode = ThemeMode.light;
  String _languageCode = 'en'; // 'en', 'ru', 'kk'

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  String get languageCode => _languageCode;

  String get languageName {
    switch (_languageCode) {
      case 'ru':
        return 'Русский';
      case 'kk':
      case 'kz':
        return 'Қазақша';
      case 'en':
      default:
        return 'English';
    }
  }

  String get languageBadgeText {
    switch (_languageCode) {
      case 'ru':
        return 'RU';
      case 'kk':
      case 'kz':
        return 'KZ';
      case 'en':
      default:
        return 'EN';
    }
  }

  ThemeController() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePrefKey);
      if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      }

      final savedLang = prefs.getString(_langPrefKey);
      if (savedLang != null && (savedLang == 'en' || savedLang == 'ru' || savedLang == 'kk' || savedLang == 'kz')) {
        _languageCode = (savedLang == 'kz') ? 'kk' : savedLang;
        AppStrings.languageNotifier.value = _languageCode;
      }
      notifyListeners();
    } catch (_) {
      // Ignored in test environments without SharedPreferences mocking
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefKey, mode == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {}
  }

  Future<void> setLanguage(String code) async {
    final clean = (code.toLowerCase() == 'kz') ? 'kk' : code.toLowerCase();
    if (_languageCode == clean) return;
    _languageCode = clean;
    AppStrings.setLanguage(clean);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_langPrefKey, clean);
    } catch (_) {}
  }
}

/// Inherited notifier to provide [ThemeController] down the widget tree.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'No ThemeScope found in context');
    return scope!.notifier!;
  }
}
