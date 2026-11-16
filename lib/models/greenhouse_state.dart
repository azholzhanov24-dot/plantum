import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GreenhouseController extends ChangeNotifier {
  // Состояние тумблеров
  bool isWateringOn = false;
  bool isLightingOn = false;
  bool isVentilationOn = false;

  // Текущие показатели датчиков (для отображения на Home Screen)
  double temperature = 24.5;
  double humidity = 65.0;
  double soilMoisture = 75.0;

  // Состояние диапазонов условий
  double tempMin = 20.0;
  double tempMax = 28.0;
  double humidityMin = 50.0;
  double humidityMax = 80.0;
  double soilMoistureMin = 60.0;
  double soilMoistureMax = 90.0;

  // Геттеры для текстовых диапазонов, которые запрашивает home_screen.dart
  String get tempRangeText => '${tempMin.round()}-${tempMax.round()} °C';
  String get humidityRangeText => '${humidityMin.round()}-${humidityMax.round()} %';
  String get soilMoistureRangeText => '${soilMoistureMin.round()}-${soilMoistureMax.round()} %';

  // Тост / Уведомления
  bool isToastVisible = false;
  String toastMessage = '';

  // Колбэк для отправки сообщений в 3D
  void Function(String action, bool value)? _sendTo3DCallback;

  void setIframeSender(void Function(String action, bool value) sender) {
    _sendTo3DCallback = sender;
  }

  // Переключение тумблеров с отправкой команды в 3D
  void toggleWatering(bool value) {
    isWateringOn = value;
    _sendTo3DCallback?.call('TOGGLE_WATER', value);
    showToast(value ? 'Watering activated' : 'Watering deactivated');
    notifyListeners();
  }

  void toggleLighting(bool value) {
    isLightingOn = value;
    _sendTo3DCallback?.call('TOGGLE_UV', value);
    showToast(value ? 'Lighting activated' : 'Lighting deactivated');
    notifyListeners();
  }

  void toggleVentilation(bool value) {
    isVentilationOn = value;
    _sendTo3DCallback?.call('TOGGLE_FAN', value);
    showToast(value ? 'Ventilation activated' : 'Ventilation deactivated');
    notifyListeners();
  }

  // Обновление диапазонов
  void updateTemperatureRange(double min, double max) {
    tempMin = min;
    tempMax = max;
    showToast('Temperature updated');
    notifyListeners();
  }

  void updateHumidityRange(double min, double max) {
    humidityMin = min;
    humidityMax = max;
    showToast('Humidity updated');
    notifyListeners();
  }

  void updateSoilMoistureRange(double min, double max) {
    soilMoistureMin = min;
    soilMoistureMax = max;
    showToast('Soil moisture updated');
    notifyListeners();
  }

  // Управление тостами
  void showToast(String message) {
    toastMessage = message;
    isToastVisible = true;
    notifyListeners();
  }

  void hideToast() {
    isToastVisible = false;
    notifyListeners();
  }
}

/// InheritedNotifier автоматически отслеживает notifyListeners() в контроллере
class GreenhouseScope extends InheritedNotifier<GreenhouseController> {
  const GreenhouseScope({
    super.key,
    required GreenhouseController controller,
    required super.child,
  }) : super(notifier: controller);

  static GreenhouseController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GreenhouseScope>();
    assert(scope != null, 'No GreenhouseScope found in context');
    return scope!.notifier!;
  }
}