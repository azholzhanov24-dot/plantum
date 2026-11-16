import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/greenhouse_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/condition_tile.dart';
import '../widgets/confirm_toggle_dialog.dart';
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
    final strings = context.strings;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: context.bgColor,
          body: SafeArea(
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
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: context.textPrimaryColor,
                          size: 26.0,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 22.0,
                        onPressed: onNavigateBack,
                      ),
                      const SizedBox(width: 14.0),
                      Text(
                        strings.control,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimaryColor,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  // Animated Floating Toast / Status Banner
                  SizedBox(
                    height: 44.0,
                    child: _buildToastNotification(controller),
                  ),

                  const SizedBox(height: 8.0),

                  // 3D Model Viewport (Three.js WebGL / HTML View)
                  _build3DViewport(controller),

                  const SizedBox(height: 20.0),

                  // Actuators Section (Toggles with Confirmation Dialog)
                  ControlToggleTile(
                    type: ActuatorType.watering,
                    title: strings.watering,
                    isEnabled: controller.isWateringOn,
                    onChanged: (val) async {
                      final confirmed = await showToggleConfirmDialog(
                        context: context,
                        deviceName: strings.watering,
                        turnOn: val,
                        confirmColor: AppColors.waterBlue,
                      );
                      if (confirmed) {
                        controller.toggleWatering(
                          val,
                          val
                              ? strings.toastWateringActivated
                              : strings.toastWateringDeactivated,
                        );
                      }
                    },
                  ),
                  ControlToggleTile(
                    type: ActuatorType.lighting,
                    title: strings.lighting,
                    isEnabled: controller.isLightingOn,
                    onChanged: (val) async {
                      final confirmed = await showToggleConfirmDialog(
                        context: context,
                        deviceName: strings.lighting,
                        turnOn: val,
                        confirmColor: AppColors.lightYellow,
                      );
                      if (confirmed) {
                        controller.toggleLighting(
                          val,
                          val
                              ? strings.toastLightingActivated
                              : strings.toastLightingDeactivated,
                        );
                      }
                    },
                  ),
                  ControlToggleTile(
                    type: ActuatorType.ventilation,
                    title: strings.ventilation,
                    isEnabled: controller.isVentilationOn,
                    onChanged: (val) async {
                      final confirmed = await showToggleConfirmDialog(
                        context: context,
                        deviceName: strings.ventilation,
                        turnOn: val,
                        confirmColor: AppColors.fanGreen,
                      );
                      if (confirmed) {
                        controller.toggleVentilation(
                          val,
                          val
                              ? strings.toastVentilationActivated
                              : strings.toastVentilationDeactivated,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 14.0),

                  // Conditions Section Title
                  Text(
                    strings.setYourConditions,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimaryColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // Condition Tiles
                  ConditionTile(
                    label: strings.temperature,
                    valueText: '${controller.tempMin.round()}-${controller.tempMax.round()} °C',
                    onTap: () {
                      showConditionEditorSheet(
                        context: context,
                        title: strings.temperature,
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
                    label: strings.humidity,
                    valueText: '${controller.humidityMin.round()}-${controller.humidityMax.round()} %',
                    onTap: () {
                      showConditionEditorSheet(
                        context: context,
                        title: strings.humidity,
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
                    label: strings.soilMoisture,
                    valueText: '${controller.soilMoistureMin.round()}-${controller.soilMoistureMax.round()} %',
                    onTap: () {
                      showConditionEditorSheet(
                        context: context,
                        title: strings.soilMoisture,
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
    return AnimatedSlide(
      offset: controller.isToastVisible ? Offset.zero : const Offset(0, -0.35),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: controller.isToastVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeInOut,
        child: IgnorePointer(
          ignoring: !controller.isToastVisible,
          child: Center(
            child: GestureDetector(
              onTap: () => controller.hideToast(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.toastGreen,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.toastGreen.withValues(alpha: 0.38),
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
                    Flexible(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        child: Text(
                          controller.toastMessage,
                          key: ValueKey<String>(controller.toastMessage),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.toastText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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