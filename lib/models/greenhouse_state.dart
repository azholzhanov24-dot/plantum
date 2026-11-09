import 'dart:async';
import 'package:flutter/material.dart';

/// State controller for the greenhouse metrics, actuators, and target conditions.
class GreenhouseController extends ChangeNotifier {
  // Sensor readings
  double _temperature = 24.0;
  double _humidity = 79.0;
  double _soilMoisture = 67.0;

  // Target ranges (Set your conditions)
  double _tempMin = 20.0;
  double _tempMax = 28.0;

  double _humidityMin = 50.0;
  double _humidityMax = 80.0;

  double _soilMoistureMin = 60.0;
  double _soilMoistureMax = 90.0;

  // Actuator switches
  bool _isWateringOn = true;
  bool _isLightingOn = true;
  bool _isVentilationOn = true;

  // 3D Viewport Zoom
  double _zoomLevel = 1.0;

  // Toast / Notification banner
  bool _isToastVisible = true;
  String _toastMessage = 'Watering successfully activated';
  Timer? _toastTimer;

  GreenhouseController() {
    // Show toast for 4 seconds on initial startup matching Figma
    _scheduleToastDismissal(duration: const Duration(seconds: 4));
  }

  // Getters
  double get temperature => _temperature;
  double get humidity => _humidity;
  double get soilMoisture => _soilMoisture;

  double get tempMin => _tempMin;
  double get tempMax => _tempMax;

  double get humidityMin => _humidityMin;
  double get humidityMax => _humidityMax;

  double get soilMoistureMin => _soilMoistureMin;
  double get soilMoistureMax => _soilMoistureMax;

  bool get isWateringOn => _isWateringOn;
  bool get isLightingOn => _isLightingOn;
  bool get isVentilationOn => _isVentilationOn;

  double get zoomLevel => _zoomLevel;

  bool get isToastVisible => _isToastVisible;
  String get toastMessage => _toastMessage;

  String get tempRangeText => '${_tempMin.round()}-${_tempMax.round()}°C';
  String get humidityRangeText => '${_humidityMin.round()}-${_humidityMax.round()}%';
  String get soilMoistureRangeText => '${_soilMoistureMin.round()}-${_soilMoistureMax.round()}%';

  // Sensor updates
  void updateSensors({double? temperature, double? humidity, double? soilMoisture}) {
    if (temperature != null) _temperature = temperature;
    if (humidity != null) _humidity = humidity;
    if (soilMoisture != null) _soilMoisture = soilMoisture;
    notifyListeners();
  }

  // Toggle Actuators
  void toggleWatering(bool value) {
    _isWateringOn = value;
    if (value) {
      triggerToast('Watering successfully activated');
    } else {
      triggerToast('Watering deactivated');
    }
    notifyListeners();
  }

  void toggleLighting(bool value) {
    _isLightingOn = value;
    notifyListeners();
  }

  void toggleVentilation(bool value) {
    _isVentilationOn = value;
    notifyListeners();
  }

  // Toast banner trigger
  void triggerToast(String message) {
    _toastMessage = message;
    _isToastVisible = true;
    _scheduleToastDismissal();
    notifyListeners();
  }

  void hideToast() {
    _isToastVisible = false;
    _toastTimer?.cancel();
    notifyListeners();
  }

  void _scheduleToastDismissal({Duration duration = const Duration(seconds: 3)}) {
    _toastTimer?.cancel();
    _toastTimer = Timer(duration, () {
      _isToastVisible = false;
      notifyListeners();
    });
  }

  // Condition range updates
  void updateTemperatureRange(double min, double max) {
    _tempMin = min;
    _tempMax = max;
    notifyListeners();
  }

  void updateHumidityRange(double min, double max) {
    _humidityMin = min;
    _humidityMax = max;
    notifyListeners();
  }

  void updateSoilMoistureRange(double min, double max) {
    _soilMoistureMin = min;
    _soilMoistureMax = max;
    notifyListeners();
  }

  // 3D Viewport Zoom controls
  void zoomIn() {
    _zoomLevel = (_zoomLevel + 0.15).clamp(0.7, 2.2);
    notifyListeners();
  }

  void zoomOut() {
    _zoomLevel = (_zoomLevel - 0.15).clamp(0.7, 2.2);
    notifyListeners();
  }

  void resetZoom() {
    _zoomLevel = 1.0;
    notifyListeners();
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }
}

/// Inherited notifier to give access to [GreenhouseController] down the widget tree.
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
