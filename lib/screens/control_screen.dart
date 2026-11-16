import 'package:flutter/material.dart';
import '../models/greenhouse_state.dart';
import '../theme/app_colors.dart';
import '../widgets/condition_tile.dart';
import '../widgets/control_toggle_tile.dart';
import '../widgets/greenhouse_web_view.dart';

/// Screen 2: Control Screen with 3D model viewport, actuator toggles, and target conditions.
class ControlScreen extends StatelessWidget {
  final VoidCallback onNavigateBack;

  const ControlScreen({
    super.key,
    required this.onNavigateBack,
  });

  @override
  Widget build(BuildContext context) {
    final controller = GreenhouseScope.of(context);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),

                  // Header: Back arrow + Title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textPrimary,
                          size: 26.0,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 22.0,
                        onPressed: onNavigateBack,
                      ),
                      const SizedBox(width: 14.0),
                      const Text(
                        'Control',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12.0),

                  // Animated Toast / Status Banner
                  _buildToastNotification(controller),

                  const SizedBox(height: 12.0),

                  // 3D Model Viewport (Three.js WebGL / HTML View)
                  _build3DViewport(controller),

                  const SizedBox(height: 20.0),

                  // Actuators Section (Toggles)
                  ControlToggleTile(
                    type: ActuatorType.watering,
                    title: 'Watering',
                    isEnabled: controller.isWateringOn,
                    onChanged: (val) => controller.toggleWatering(val),
                  ),
                  ControlToggleTile(
                    type: ActuatorType.lighting,
                    title: 'Lighting',
                    isEnabled: controller.isLightingOn,
                    onChanged: (val) => controller.toggleLighting(val),
                  ),
                  ControlToggleTile(
                    type: ActuatorType.ventilation,
                    title: 'Ventilation',
                    isEnabled: controller.isVentilationOn,
                    onChanged: (val) => controller.toggleVentilation(val),
                  ),

                  const SizedBox(height: 14.0),

                  // Conditions Section Title
                  const Text(
                    'Set your conditions',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // Condition Tiles
                  ConditionTile(
                    label: 'Temperature',
                    valueText: '${controller.tempMin.round()}-${controller.tempMax.round()} °C',
                    onTap: () {
                      showConditionEditorSheet(
                        context: context,
                        title: 'Temperature',
                        unit: '°C',
                        currentMin: controller.tempMin,
                        currentMax: controller.tempMax,
                        absoluteMin: 15.0,
                        absoluteMax: 35.0,
                        onSaved: (newMin, newMax) {
                          controller.updateTemperatureRange(newMin, newMax);
                        },
                      );
                    },
                  ),
                  ConditionTile(
                    label: 'Humadity',
                    valueText: '${controller.humidityMin.round()}-${controller.humidityMax.round()} %',
                    onTap: () {
                      showConditionEditorSheet(
                        context: context,
                        title: 'Humidity',
                        unit: '%',
                        currentMin: controller.humidityMin,
                        currentMax: controller.humidityMax,
                        absoluteMin: 30.0,
                        absoluteMax: 95.0,
                        onSaved: (newMin, newMax) {
                          controller.updateHumidityRange(newMin, newMax);
                        },
                      );
                    },
                  ),
                  ConditionTile(
                    label: 'Soil moisture',
                    valueText: '${controller.soilMoistureMin.round()}-${controller.soilMoistureMax.round()} %',
                    onTap: () {
                      showConditionEditorSheet(
                        context: context,
                        title: 'Soil Moisture',
                        unit: '%',
                        currentMin: controller.soilMoistureMin,
                        currentMax: controller.soilMoistureMax,
                        absoluteMin: 20.0,
                        absoluteMax: 95.0,
                        onSaved: (newMin, newMax) {
                          controller.updateSoilMoistureRange(newMin, newMax);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 90.0), // Spacing above bottom bar
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToastNotification(GreenhouseController controller) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: controller.isToastVisible
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Center(
        child: GestureDetector(
          onTap: () => controller.hideToast(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: AppColors.toastGreen,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.toastGreen.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.toastText,
                  size: 18.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  controller.toastMessage,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.toastText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      secondChild: const SizedBox(width: double.infinity, height: 0),
    );
  }

  Widget _build3DViewport(GreenhouseController controller) {
    return Container(
      height: 200.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkViewport,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Stack(
          children: [
            // Интерактивная 3D сцена через HTML/Three.js виджет
            const GreenhouseWebView(),

            // Bottom-left tag badge
            Positioned(
              bottom: 12,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.threed_rotation_rounded,
                      size: 14,
                      color: Colors.white70,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Interactive 3D Viewport',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}