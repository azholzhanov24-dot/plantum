import 'package:flutter/material.dart';
import '../models/greenhouse_state.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_toggle_dialog.dart';
import '../widgets/sensor_card.dart';
import 'auth/sign_in_screen.dart';

/// Screen 1: Home Dashboard displaying greenhouse live metrics and photo banner.
class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToControl;

  const HomeScreen({
    super.key,
    required this.onNavigateToControl,
  });

  @override
  Widget build(BuildContext context) {
    final controller = GreenhouseScope.of(context);

    // Direct dynamic progress calculations based on real sensor numbers
    // 1. Temperature: base scale 0–50°C
    final tempProgress = (controller.temperature / 50.0).clamp(0.0, 1.0);

    // 2. Humidity: direct percentage 0–100%
    final humidityProgress = (controller.humidity / 100.0).clamp(0.0, 1.0);

    // 3. Soil moisture: direct percentage 0–100%
    final soilProgress = (controller.soilMoisture / 100.0).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),

              // Top Bar: Brand Logo & Settings Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: AppColors.brandIconGreen.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco_rounded,
                          color: AppColors.brandIconGreen,
                          size: 26.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        'Plantum',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brandGreen,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardBorder, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: AppColors.textPrimary,
                        size: 20.0,
                      ),
                      splashRadius: 20.0,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _showSettingsDialog(context);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14.0),

              // Greenhouse Photo Banner
              _buildGreenhouseBanner(context),

              const SizedBox(height: 14.0),

              // 2x2 Modern White Sensor Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.88,
                children: [
                  // 1. Temperature Card (0-50°C scale)
                  SensorCard(
                    title: 'Temperature',
                    value: '${controller.temperature.round()}°C',
                    subtitle: 'Target: ${controller.tempMin.round()}–${controller.tempMax.round()}°C',
                    icon: Icons.thermostat_rounded,
                    accentColor: AppColors.tempAccent,
                    progress: tempProgress,
                    onTap: onNavigateToControl,
                  ),

                  // 2. Humidity Card (0-100% scale)
                  SensorCard(
                    title: 'Humidity',
                    value: '${controller.humidity.round()}%',
                    subtitle: 'Target: ${controller.humidityMin.round()}–${controller.humidityMax.round()}%',
                    icon: Icons.water_drop_rounded,
                    accentColor: AppColors.humidityAccent,
                    progress: humidityProgress,
                    onTap: onNavigateToControl,
                  ),

                  // 3. Soil Moisture Card (0-100% scale)
                  SensorCard(
                    title: 'Soil moisture',
                    value: '${controller.soilMoisture.round()}%',
                    subtitle: 'Target: ${controller.soilMoistureMin.round()}–${controller.soilMoistureMax.round()}%',
                    icon: Icons.grass_rounded,
                    accentColor: AppColors.soilAccent,
                    progress: soilProgress,
                    onTap: onNavigateToControl,
                  ),

                  // 4. Grow Light Card (Confirmation dialog before toggle)
                  SensorCard(
                    title: 'Grow Light',
                    value: controller.isLightingOn ? 'ON' : 'OFF',
                    subtitle: 'Manual mode',
                    icon: Icons.wb_sunny_rounded,
                    accentColor: AppColors.lightAccent,
                    isSwitch: true,
                    switchValue: controller.isLightingOn,
                    onToggle: (_) async {
                      final confirmed = await showToggleConfirmDialog(
                        context: context,
                        deviceName: 'Grow Light',
                        turnOn: !controller.isLightingOn,
                        confirmColor: AppColors.lightAccent,
                      );
                      if (confirmed) {
                        controller.toggleLighting(!controller.isLightingOn);
                      }
                    },
                    onTap: () async {
                      final confirmed = await showToggleConfirmDialog(
                        context: context,
                        deviceName: 'Grow Light',
                        turnOn: !controller.isLightingOn,
                        confirmColor: AppColors.lightAccent,
                      );
                      if (confirmed) {
                        controller.toggleLighting(!controller.isLightingOn);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24.0), // Padding above bottom navigation bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreenhouseBanner(BuildContext context) {
    final controller = GreenhouseScope.of(context);
    return Container(
      height: 170.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Local asset with network fallback
            Image.asset(
              'assets/images/greenhouse_banner.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?auto=format&fit=crop&w=1000&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.energy_savings_leaf_rounded,
                          size: 64,
                          color: Colors.white54,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Subtle dark gradient overlay at top and bottom for contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.25),
                  ],
                ),
              ),
            ),

            // Live status badge overlay
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF69F0AE),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Live • ${controller.greenhouseName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
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

  void _showSettingsDialog(BuildContext context) {
    final controller = GreenhouseScope.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.settings_outlined, color: AppColors.brandIconGreen, size: 22),
            SizedBox(width: 8),
            Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.greenhouseName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Area: ${controller.greenhouseArea.toStringAsFixed(0)} m²',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            Text(
              'Location: ${controller.greenhouseAddress}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Plantum Smart Greenhouse v1.0.0\nAutomatic climate control is running smoothly.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.tempAccent),
            label: const Text('Log out', style: TextStyle(color: AppColors.tempAccent, fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.clearUser();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (route) => false,
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.authGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
