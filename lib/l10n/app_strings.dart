import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';

/// Supported language item data
class AppLanguageItem {
  final String code; // 'en', 'ru', 'kk'
  final String badge; // 'EN', 'RU', 'KZ'
  final String name; // 'English', 'Русский', 'Қазақша'

  const AppLanguageItem({
    required this.code,
    required this.badge,
    required this.name,
  });
}

/// Minimalist 32x32 badge for displaying language code (EN, RU, KZ).
class LanguageBadge extends StatelessWidget {
  final String code;
  final bool isSelected;
  final double size;

  const LanguageBadge({
    super.key,
    required this.code,
    this.isSelected = false,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final clean = code.trim().toLowerCase();
    final badgeText = (clean == 'kk' || clean == 'kz') ? 'KZ' : clean.toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected
            ? (context.isDark ? const Color(0x334CAF50) : const Color(0xFFE8F5E9))
            : context.subtleSurfaceColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isSelected ? context.brandGreenColor : context.dividerLineColor,
          width: 1.0,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: isSelected ? context.brandGreenColor : context.textPrimaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Strongly-typed localized strings container.
abstract class AppStringsData {
  String get appName;

  // Bottom Navigation
  String get navHome;
  String get navControl;
  String get navNotifications;
  String get navHistory;

  // General & Common Actions
  String get cancel;
  String get confirm;
  String get save;
  String get close;
  String get map;
  String get on;
  String get off;
  String get norm;
  String get target;
  String get manualMode;
  String get standby;

  // Sensors & Actuators
  String get temperature;
  String get humidity;
  String get soilMoisture;
  String get growLight;
  String get watering;
  String get lighting;
  String get ventilation;

  // Home Screen
  String get live;
  String liveGreenhouse(String name);
  String targetFormat(num min, num max, String unit);

  // Control Screen
  String get control;
  String get setYourConditions;
  String adjustCondition(String title);
  String get conditionHelper;
  String get saveTargetCondition;
  String get toastWateringActivated;
  String get toastWateringDeactivated;
  String get toastLightingActivated;
  String get toastLightingDeactivated;
  String get toastVentilationActivated;
  String get toastVentilationDeactivated;
  String confirmTurnOn(String device);
  String confirmTurnOff(String device);

  // Notifications Screen
  String get notifications;
  String get notifWateringTitle;
  String get notifWateringSub;
  String get notifTempTitle;
  String get notifTempSub;
  String get notifVentTitle;
  String get notifVentSub;
  String get time12mAgo;
  String get time1hAgo;
  String get time3hAgo;

  // History Screen
  String get telemetryHistory;
  String get trend24h;
  String get stable;
  String get avgTemp;
  String get avgHumidity;
  String get avgMoisture;
  String get exportNotice;

  // Settings Screen
  String get settings;
  String get editUsername;
  String get editUsernameDesc;
  String get enterNewUsername;
  String get usernameUpdated;
  String get activeGreenhouse;
  String get online;
  String areaFormat(num area);
  String coordinatesFormat(double lat, double lng);
  String get preferences;
  String get appearance;
  String get light;
  String get dark;
  String get language;
  String get selectLanguage;
  String languageChangedTo(String name);
  String get logOut;
  String get logOutConfirmTitle;
  String get logOutConfirmDesc;
  String get versionFooter;

  // Auth Screens
  String get createAccount;
  String get welcomeBack;
  String get username;
  String get email;
  String get password;
  String get signUp;
  String get signIn;
  String get alreadyHaveAccount;
  String get dontHaveAccount;
  String get forgotPassword;
}

class _EnglishStrings implements AppStringsData {
  const _EnglishStrings();

  @override
  String get appName => 'Plantum';

  @override
  String get navHome => 'Home';
  @override
  String get navControl => 'Control';
  @override
  String get navNotifications => 'Notifications';
  @override
  String get navHistory => 'History';

  @override
  String get cancel => 'Cancel';
  @override
  String get confirm => 'Confirm';
  @override
  String get save => 'Save';
  @override
  String get close => 'Close';
  @override
  String get map => 'Map';
  @override
  String get on => 'On';
  @override
  String get off => 'Off';
  @override
  String get norm => 'Norm';
  @override
  String get target => 'Target';
  @override
  String get manualMode => 'Manual mode';
  @override
  String get standby => 'Standby';

  @override
  String get temperature => 'Temperature';
  @override
  String get humidity => 'Humidity';
  @override
  String get soilMoisture => 'Soil moisture';
  @override
  String get growLight => 'Grow Light';
  @override
  String get watering => 'Watering';
  @override
  String get lighting => 'Lighting';
  @override
  String get ventilation => 'Ventilation';

  @override
  String get live => 'Live';
  @override
  String liveGreenhouse(String name) => 'Live • $name';
  @override
  String targetFormat(num min, num max, String unit) => 'Target: ${min.round()}–${max.round()}$unit';

  @override
  String get control => 'Control';
  @override
  String get setYourConditions => 'Set your conditions';
  @override
  String adjustCondition(String title) => 'Adjust $title';
  @override
  String get conditionHelper => 'Target range will be maintained automatically by actuators.';
  @override
  String get saveTargetCondition => 'Save Target Condition';
  @override
  String get toastWateringActivated => 'Watering successfully activated';
  @override
  String get toastWateringDeactivated => 'Watering deactivated';
  @override
  String get toastLightingActivated => 'Lighting successfully activated';
  @override
  String get toastLightingDeactivated => 'Lighting deactivated';
  @override
  String get toastVentilationActivated => 'Ventilation successfully activated';
  @override
  String get toastVentilationDeactivated => 'Ventilation deactivated';
  @override
  String confirmTurnOn(String device) => 'Are you sure you want to turn ON $device?';
  @override
  String confirmTurnOff(String device) => 'Are you sure you want to turn OFF $device?';

  @override
  String get notifications => 'Notifications';
  @override
  String get notifWateringTitle => 'Watering routine completed';
  @override
  String get notifWateringSub => 'Zone 1 tomato crops received 150ml moisture';
  @override
  String get notifTempTitle => 'Temperature optimal';
  @override
  String get notifTempSub => 'Greenhouse maintained 24°C target condition';
  @override
  String get notifVentTitle => 'Ventilation active';
  @override
  String get notifVentSub => 'Exhaust fan cycled to regulate air humidity';
  @override
  String get time12mAgo => '12m ago';
  @override
  String get time1hAgo => '1h ago';
  @override
  String get time3hAgo => '3h ago';

  @override
  String get telemetryHistory => 'Telemetry History';
  @override
  String get trend24h => '24h Microclimate Trend';
  @override
  String get stable => 'Stable';
  @override
  String get avgTemp => 'Avg Temp';
  @override
  String get avgHumidity => 'Avg Humidity';
  @override
  String get avgMoisture => 'Avg Moisture';
  @override
  String get exportNotice => 'Full telemetry export available via CSV or Cloud Sync.';

  @override
  String get settings => 'Settings';
  @override
  String get editUsername => 'Edit Username';
  @override
  String get editUsernameDesc => 'This name is displayed on your profile and greenhouse activity';
  @override
  String get enterNewUsername => 'Enter new username';
  @override
  String get usernameUpdated => 'Username updated';
  @override
  String get activeGreenhouse => 'ACTIVE GREENHOUSE';
  @override
  String get online => 'Online';
  @override
  String areaFormat(num area) => 'Area: ${area.toStringAsFixed(0)} m²';
  @override
  String coordinatesFormat(double lat, double lng) => 'Coordinates: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  @override
  String get preferences => 'PREFERENCES';
  @override
  String get appearance => 'Appearance';
  @override
  String get light => 'Light';
  @override
  String get dark => 'Dark';
  @override
  String get language => 'Language';
  @override
  String get selectLanguage => 'Select Language';
  @override
  String languageChangedTo(String name) => 'Language changed to $name';
  @override
  String get logOut => 'Log out';
  @override
  String get logOutConfirmTitle => 'Log out of Plantum?';
  @override
  String get logOutConfirmDesc => 'You will need to sign in again to control and monitor your greenhouse.';
  @override
  String get versionFooter => 'Plantum Smart Greenhouse • v1.0.0';

  @override
  String get createAccount => 'Create your account';
  @override
  String get welcomeBack => 'Welcome back';
  @override
  String get username => 'Username';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get signUp => 'Sign up';
  @override
  String get signIn => 'Sign in';
  @override
  String get alreadyHaveAccount => 'Already have an account?';
  @override
  String get dontHaveAccount => "Don't have an account?";
  @override
  String get forgotPassword => 'Forgot password?';
}

class _RussianStrings implements AppStringsData {
  const _RussianStrings();

  @override
  String get appName => 'Plantum';

  @override
  String get navHome => 'Главная';
  @override
  String get navControl => 'Управление';
  @override
  String get navNotifications => 'Уведомления';
  @override
  String get navHistory => 'История';

  @override
  String get cancel => 'Отмена';
  @override
  String get confirm => 'Подтвердить';
  @override
  String get save => 'Сохранить';
  @override
  String get close => 'Закрыть';
  @override
  String get map => 'Карта';
  @override
  String get on => 'Вкл';
  @override
  String get off => 'Выкл';
  @override
  String get norm => 'Норма';
  @override
  String get target => 'Цель';
  @override
  String get manualMode => 'Ручной режим';
  @override
  String get standby => 'Ожидание';

  @override
  String get temperature => 'Температура';
  @override
  String get humidity => 'Влажность';
  @override
  String get soilMoisture => 'Влажность почвы';
  @override
  String get growLight => 'Освещение';
  @override
  String get watering => 'Полив';
  @override
  String get lighting => 'Освещение';
  @override
  String get ventilation => 'Вентиляция';

  @override
  String get live => 'Онлайн';
  @override
  String liveGreenhouse(String name) => 'Онлайн • $name';
  @override
  String targetFormat(num min, num max, String unit) => 'Цель: ${min.round()}–${max.round()}$unit';

  @override
  String get control => 'Управление';
  @override
  String get setYourConditions => 'Задайте условия';
  @override
  String adjustCondition(String title) => 'Настроить: $title';
  @override
  String get conditionHelper => 'Целевой диапазон поддерживается автоматически исполнительными механизмами.';
  @override
  String get saveTargetCondition => 'Сохранить условие';
  @override
  String get toastWateringActivated => 'Полив успешно включен';
  @override
  String get toastWateringDeactivated => 'Полив выключен';
  @override
  String get toastLightingActivated => 'Освещение успешно включено';
  @override
  String get toastLightingDeactivated => 'Освещение выключено';
  @override
  String get toastVentilationActivated => 'Вентиляция успешно включена';
  @override
  String get toastVentilationDeactivated => 'Вентиляция выключена';
  @override
  String confirmTurnOn(String device) => 'Вы уверены, что хотите включить $device?';
  @override
  String confirmTurnOff(String device) => 'Вы уверены, что хотите выключить $device?';

  @override
  String get notifications => 'Уведомления';
  @override
  String get notifWateringTitle => 'Полив завершен';
  @override
  String get notifWateringSub => 'Томаты зоны 1 получили 150 мл влаги';
  @override
  String get notifTempTitle => 'Температура в норме';
  @override
  String get notifTempSub => 'В теплице поддерживается целевая температура 24°C';
  @override
  String get notifVentTitle => 'Вентиляция активна';
  @override
  String get notifVentSub => 'Вытяжной вентилятор включен для регулирования влажности';
  @override
  String get time12mAgo => '12 мин назад';
  @override
  String get time1hAgo => '1 ч назад';
  @override
  String get time3hAgo => '3 ч назад';

  @override
  String get telemetryHistory => 'История телеметрии';
  @override
  String get trend24h => 'Тренд микроклимата за 24 ч';
  @override
  String get stable => 'Стабильно';
  @override
  String get avgTemp => 'Ср. темп.';
  @override
  String get avgHumidity => 'Ср. влажность';
  @override
  String get avgMoisture => 'Ср. почва';
  @override
  String get exportNotice => 'Полный экспорт телеметрии доступен через CSV или Cloud Sync.';

  @override
  String get settings => 'Настройки';
  @override
  String get editUsername => 'Изменить имя пользователя';
  @override
  String get editUsernameDesc => 'Это имя отображается в вашем профиле и активности теплицы';
  @override
  String get enterNewUsername => 'Введите новое имя';
  @override
  String get usernameUpdated => 'Имя пользователя обновлено';
  @override
  String get activeGreenhouse => 'АКТИВНАЯ ТЕПЛИЦА';
  @override
  String get online => 'Онлайн';
  @override
  String areaFormat(num area) => 'Площадь: ${area.toStringAsFixed(0)} м²';
  @override
  String coordinatesFormat(double lat, double lng) => 'Координаты: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  @override
  String get preferences => 'НАСТРОЙКИ';
  @override
  String get appearance => 'Оформление';
  @override
  String get light => 'Светлая';
  @override
  String get dark => 'Тёмная';
  @override
  String get language => 'Язык';
  @override
  String get selectLanguage => 'Выберите язык';
  @override
  String languageChangedTo(String name) => 'Язык изменен на $name';
  @override
  String get logOut => 'Выйти';
  @override
  String get logOutConfirmTitle => 'Выйти из Plantum?';
  @override
  String get logOutConfirmDesc => 'Вам потребуется войти снова для управления и мониторинга теплицы.';
  @override
  String get versionFooter => 'Умная теплица Plantum • v1.0.0';

  @override
  String get createAccount => 'Создайте аккаунт';
  @override
  String get welcomeBack => 'С возвращением';
  @override
  String get username => 'Имя пользователя';
  @override
  String get email => 'Эл. почта';
  @override
  String get password => 'Пароль';
  @override
  String get signUp => 'Зарегистрироваться';
  @override
  String get signIn => 'Войти';
  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';
  @override
  String get dontHaveAccount => 'Еще нет аккаунта?';
  @override
  String get forgotPassword => 'Забыли пароль?';
}

class _KazakhStrings implements AppStringsData {
  const _KazakhStrings();

  @override
  String get appName => 'Plantum';

  @override
  String get navHome => 'Басты бет';
  @override
  String get navControl => 'Басқару';
  @override
  String get navNotifications => 'Хабарламалар';
  @override
  String get navHistory => 'Тарих';

  @override
  String get cancel => 'Бас тарту';
  @override
  String get confirm => 'Растау';
  @override
  String get save => 'Сақтау';
  @override
  String get close => 'Жабу';
  @override
  String get map => 'Карта';
  @override
  String get on => 'Қосулы';
  @override
  String get off => 'Өшірулі';
  @override
  String get norm => 'Қалыпты';
  @override
  String get target => 'Мақсат';
  @override
  String get manualMode => 'Қолмен басқару';
  @override
  String get standby => 'Күту режимі';

  @override
  String get temperature => 'Температура';
  @override
  String get humidity => 'Ылғалдылық';
  @override
  String get soilMoisture => 'Топырақ ылғалдылығы';
  @override
  String get growLight => 'Жарықтандыру';
  @override
  String get watering => 'Суару';
  @override
  String get lighting => 'Жарық';
  @override
  String get ventilation => 'Желдету';

  @override
  String get live => 'Тікелей эфир';
  @override
  String liveGreenhouse(String name) => 'Тікелей • $name';
  @override
  String targetFormat(num min, num max, String unit) => 'Мақсат: ${min.round()}–${max.round()}$unit';

  @override
  String get control => 'Басқару';
  @override
  String get setYourConditions => 'Жағдайларды орнату';
  @override
  String adjustCondition(String title) => '$title реттеу';
  @override
  String get conditionHelper => 'Мақсатты диапазон жетектер арқылы автоматты түрде сақталады.';
  @override
  String get saveTargetCondition => 'Мақсатты жағдайды сақтау';
  @override
  String get toastWateringActivated => 'Суару сәтті қосылды';
  @override
  String get toastWateringDeactivated => 'Суару өшірілді';
  @override
  String get toastLightingActivated => 'Жарықтандыру сәтті қосылды';
  @override
  String get toastLightingDeactivated => 'Жарықтандыру өшірілді';
  @override
  String get toastVentilationActivated => 'Желдету сәтті қосылды';
  @override
  String get toastVentilationDeactivated => 'Желдету өшірілді';
  @override
  String confirmTurnOn(String device) => '$device қосқыңыз келетініне сенімдісіз бе?';
  @override
  String confirmTurnOff(String device) => '$device өшіргіңіз келетініне сенімдісіз бе?';

  @override
  String get notifications => 'Хабарламалар';
  @override
  String get notifWateringTitle => 'Суару аяқталды';
  @override
  String get notifWateringSub => '1-аймақтағы қызанақтар 150 мл ылғал алды';
  @override
  String get notifTempTitle => 'Температура қалыпты';
  @override
  String get notifTempSub => 'Жылыжайда 24°C мақсатты температура сақталды';
  @override
  String get notifVentTitle => 'Желдету белсенді';
  @override
  String get notifVentSub => 'Ауа ылғалдылығын реттеу үшін желдеткіш іске қосылды';
  @override
  String get time12mAgo => '12 мин бұрын';
  @override
  String get time1hAgo => '1 сағ бұрын';
  @override
  String get time3hAgo => '3 сағ бұрын';

  @override
  String get telemetryHistory => 'Телеметрия тарихы';
  @override
  String get trend24h => '24 сағаттық микроклимат тренді';
  @override
  String get stable => 'Тұрақты';
  @override
  String get avgTemp => 'Орт. темп.';
  @override
  String get avgHumidity => 'Орт. ылғал.';
  @override
  String get avgMoisture => 'Орт. топырақ';
  @override
  String get exportNotice => 'Толық телеметрияны CSV немесе Cloud Sync арқылы экспорттауға болады.';

  @override
  String get settings => 'Баптаулар';
  @override
  String get editUsername => 'Пайдаланушы атын өзгерту';
  @override
  String get editUsernameDesc => 'Бұл атау сіздің профиліңізде және жылыжай әрекеттерінде көрсетіледі';
  @override
  String get enterNewUsername => 'Жаңа пайдаланушы атын енгізіңіз';
  @override
  String get usernameUpdated => 'Пайдаланушы аты жаңартылды';
  @override
  String get activeGreenhouse => 'БЕЛСЕНДІ ЖЫЛЫЖАЙ';
  @override
  String get online => 'Онлайн';
  @override
  String areaFormat(num area) => 'Ауданы: ${area.toStringAsFixed(0)} м²';
  @override
  String coordinatesFormat(double lat, double lng) => 'Координаттары: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  @override
  String get preferences => 'БАПТАУЛАР';
  @override
  String get appearance => 'Сыртқы түрі';
  @override
  String get light => 'Жарық';
  @override
  String get dark => 'Күңгірт';
  @override
  String get language => 'Тіл';
  @override
  String get selectLanguage => 'Тілді таңдаңыз';
  @override
  String languageChangedTo(String name) => 'Тіл $name тіліне өзгертілді';
  @override
  String get logOut => 'Шығу';
  @override
  String get logOutConfirmTitle => 'Plantum жүйесінен шығу керек пе?';
  @override
  String get logOutConfirmDesc => 'Жылыжайды басқару және бақылау үшін қайта кіру қажет болады.';
  @override
  String get versionFooter => 'Plantum ақылды жылыжайы • v1.0.0';

  @override
  String get createAccount => 'Тіркелгі жасаңыз';
  @override
  String get welcomeBack => 'Қош келдіңіз';
  @override
  String get username => 'Пайдаланушы аты';
  @override
  String get email => 'Электрондық пошта';
  @override
  String get password => 'Құпиясөз';
  @override
  String get signUp => 'Тіркелу';
  @override
  String get signIn => 'Кіру';
  @override
  String get alreadyHaveAccount => 'Тіркелгіңіз бар ма?';
  @override
  String get dontHaveAccount => 'Тіркелгіңіз жоқ па?';
  @override
  String get forgotPassword => 'Құпиясөзді ұмыттыңыз ба?';
}

/// Reactive localization provider and manager for Plantum.
class AppStrings {
  AppStrings._();

  static const String _prefKey = 'plantum_language_code';

  /// Standard supported language list
  static const List<AppLanguageItem> supportedLanguages = [
    AppLanguageItem(code: 'en', badge: 'EN', name: 'English'),
    AppLanguageItem(code: 'ru', badge: 'RU', name: 'Русский'),
    AppLanguageItem(code: 'kk', badge: 'KZ', name: 'Қазақша'),
  ];

  /// Reactive notifier holding the current language code ('en', 'ru', 'kk')
  static final ValueNotifier<String> languageNotifier = ValueNotifier<String>('en');

  static final Map<String, AppStringsData> _translations = {
    'en': const _EnglishStrings(),
    'ru': const _RussianStrings(),
    'kk': const _KazakhStrings(),
    'kz': const _KazakhStrings(),
  };

  /// Current active language code
  static String get currentCode => languageNotifier.value;

  /// Direct synchronous access to current strings
  static AppStringsData get current => _translations[currentCode] ?? const _EnglishStrings();

  /// Resolves strings for a specific language code
  static AppStringsData getForCode(String code) {
    final clean = code.trim().toLowerCase();
    return _translations[clean] ?? const _EnglishStrings();
  }

  /// Obtains localized strings reactively for [BuildContext]
  static AppStringsData of(BuildContext context) {
    try {
      final themeController = ThemeScope.of(context);
      return getForCode(themeController.languageCode);
    } catch (_) {
      return current;
    }
  }

  /// Sets language, updates notifier and persists in SharedPreferences
  static Future<void> setLanguage(String code) async {
    final clean = (code.toLowerCase() == 'kz') ? 'kk' : code.toLowerCase();
    if (languageNotifier.value == clean) return;
    languageNotifier.value = clean;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, clean);
    } catch (_) {}
  }

  /// Loads saved language from SharedPreferences
  static Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved != null && (saved == 'en' || saved == 'ru' || saved == 'kk' || saved == 'kz')) {
        final clean = (saved == 'kz') ? 'kk' : saved;
        languageNotifier.value = clean;
      }
    } catch (_) {}
  }
}

/// Extension for convenient access to strings anywhere: `context.strings`
extension AppStringsContextExtension on BuildContext {
  AppStringsData get strings => AppStrings.of(this);
}
