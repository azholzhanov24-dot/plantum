import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantum/main.dart';
import 'package:plantum/models/greenhouse_state.dart';

void main() {
  testWidgets('Plantum app loads and displays home dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const PlantumApp());
    await tester.pumpAndSettle();

    // Verify brand title is displayed
    expect(find.text('Plantum'), findsOneWidget);

    // Verify sensor titles
    expect(find.text('Temperature'), findsOneWidget);
    expect(find.text('Humidity'), findsOneWidget);
    expect(find.text('Soil moisture'), findsOneWidget);
    expect(find.text('Grow Light'), findsOneWidget);

    // Flush initial startup toast timer
    await tester.pump(const Duration(seconds: 4));
  });

  test('GreenhouseController calculates rounded arithmetic mean when ranges update', () {
    final controller = GreenhouseController();

    // Test Temperature 17-21 °C -> rounded mean is 19
    controller.updateTemperatureRange(17, 21);
    expect(controller.temperature.round(), 19);
    expect(controller.tempRangeText, '17-21°C');

    // Test Humidity 40-59 % -> rounded mean is 50
    controller.updateHumidityRange(40, 59);
    expect(controller.humidity.round(), 50);
    expect(controller.humidityRangeText, '40-59%');

    // Test Soil moisture 60-77 % -> rounded mean is 69
    controller.updateSoilMoistureRange(60, 77);
    expect(controller.soilMoisture.round(), 69);
    expect(controller.soilMoistureRangeText, '60-77%');
  });

  test('GreenhouseController handles universal toast notifications for all switches', () {
    final controller = GreenhouseController();

    // 1. Watering
    controller.toggleWatering(true);
    expect(controller.isWateringOn, true);
    expect(controller.toastMessage, 'Watering successfully activated');
    expect(controller.isToastVisible, true);

    controller.toggleWatering(false);
    expect(controller.isWateringOn, false);
    expect(controller.toastMessage, 'Watering deactivated');

    // 2. Lighting
    controller.toggleLighting(true);
    expect(controller.isLightingOn, true);
    expect(controller.toastMessage, 'Lighting successfully activated');

    controller.toggleLighting(false);
    expect(controller.isLightingOn, false);
    expect(controller.toastMessage, 'Lighting deactivated');

    // 3. Ventilation
    controller.toggleVentilation(true);
    expect(controller.isVentilationOn, true);
    expect(controller.toastMessage, 'Ventilation successfully activated');

    controller.toggleVentilation(false);
    expect(controller.isVentilationOn, false);
    expect(controller.toastMessage, 'Ventilation deactivated');
  });

  testWidgets('Home Screen reflects updated calculated mean and light switch state',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final controller = GreenhouseController();

    await tester.pumpWidget(PlantumApp(controller: controller));
    await tester.pumpAndSettle();

    // Update ranges
    controller.updateTemperatureRange(17, 21);
    controller.updateHumidityRange(40, 59);
    controller.updateSoilMoistureRange(60, 77);
    controller.toggleLighting(false); // Turn off
    await tester.pumpAndSettle();

    expect(find.text('19°C'), findsOneWidget);
    expect(find.text('Target: 17–21°C'), findsOneWidget);

    expect(find.text('50%'), findsOneWidget);
    expect(find.text('Target: 40–59%'), findsOneWidget);

    expect(find.text('69%'), findsOneWidget);
    expect(find.text('Target: 60–77%'), findsOneWidget);

    expect(find.text('OFF'), findsOneWidget);
    expect(find.text('Manual mode'), findsOneWidget);

    // Flush any pending toast timers
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Grow Light toggle opens confirmation dialog before changing state',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final controller = GreenhouseController();

    await tester.pumpWidget(PlantumApp(controller: controller));
    await tester.pumpAndSettle();

    // 1. Initially ON
    expect(controller.isLightingOn, true);
    expect(find.text('ON'), findsOneWidget);

    // 2. Tap Grow Light card
    await tester.tap(find.text('Grow Light'));
    await tester.pumpAndSettle();

    // Dialog appears with turn OFF message
    expect(find.text('Are you sure you want to turn OFF the grow light?'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // State is still ON
    expect(controller.isLightingOn, true);
    expect(find.text('ON'), findsOneWidget);

    // 3. Tap again and tap Confirm
    await tester.tap(find.text('Grow Light'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure you want to turn OFF the grow light?'), findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // Now state is OFF
    expect(controller.isLightingOn, false);
    expect(find.text('OFF'), findsOneWidget);

    // 4. Tap again: should ask to turn ON
    await tester.tap(find.text('Grow Light'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure you want to turn ON the grow light?'), findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // Now back ON
    expect(controller.isLightingOn, true);
    expect(find.text('ON'), findsOneWidget);

    // Flush any pending toast timers
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Control screen toggles require confirmation dialog before toggling',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final controller = GreenhouseController();

    await tester.pumpWidget(PlantumApp(controller: controller));
    await tester.pumpAndSettle();

    // Navigate to Control screen (index 1)
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Control'), findsOneWidget);
    expect(find.text('Watering'), findsOneWidget);

    // Initial watering state is true
    expect(controller.isWateringOn, true);

    // Tap Watering tile/switch -> should ask to turn OFF
    await tester.tap(find.text('Watering'));
    await tester.pumpAndSettle();

    // Confirmation dialog appears
    expect(find.text('Are you sure you want to turn OFF Watering?'), findsOneWidget);

    // Tap Cancel -> should stay true
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(controller.isWateringOn, true);

    // Tap Watering tile again and Confirm
    await tester.tap(find.text('Watering'));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure you want to turn OFF Watering?'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // Now watering is false
    expect(controller.isWateringOn, false);

    // Tap again -> asks to turn ON
    await tester.tap(find.text('Watering'));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure you want to turn ON Watering?'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(controller.isWateringOn, true);

    // Flush any pending toast timers
    await tester.pump(const Duration(seconds: 4));
  });
}
