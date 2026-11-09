import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'control_screen.dart';
import 'home_screen.dart';

/// Main scaffolding wrapper containing the BottomNavigationBar and Tab navigation.
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480.0),
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: _currentIndex,
            children: [
              // Tab 0: Home Screen
              HomeScreen(
                onNavigateToControl: () => _onTabTapped(1),
              ),

              // Tab 1: Control Screen
              ControlScreen(
                onNavigateBack: () => _onTabTapped(0),
              ),

              // Tab 2: Notifications (Placeholder)
              _buildNotificationsPlaceholder(),

              // Tab 3: History (Placeholder)
              _buildHistoryPlaceholder(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                tooltip: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.tune_rounded,
                activeIcon: Icons.tune_rounded,
                tooltip: 'Control',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications_none_rounded,
                activeIcon: Icons.notifications_rounded,
                tooltip: 'Notifications',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.history_rounded,
                activeIcon: Icons.history_rounded,
                tooltip: 'History',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String tooltip,
  }) {
    final isSelected = _currentIndex == index;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(20.0),
        splashColor: AppColors.navActiveGreen.withValues(alpha: 0.12),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.navActiveGreen.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Icon(
            isSelected ? activeIcon : icon,
            size: 28.0,
            color: isSelected ? AppColors.navActiveGreen : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsPlaceholder() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildNotificationItem(
            title: 'Watering routine completed',
            subtitle: 'Zone 1 tomato crops received 150ml moisture',
            time: '12m ago',
            icon: Icons.water_drop_rounded,
            iconColor: AppColors.waterBlue,
          ),
          _buildNotificationItem(
            title: 'Temperature optimal',
            subtitle: 'Greenhouse maintained 24°C target condition',
            time: '1h ago',
            icon: Icons.thermostat_rounded,
            iconColor: AppColors.tempCardEnd,
          ),
          _buildNotificationItem(
            title: 'Ventilation active',
            subtitle: 'Exhaust fan cycled to regulate air humidity',
            time: '3h ago',
            icon: Icons.air_rounded,
            iconColor: AppColors.fanGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22.0),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryPlaceholder() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Telemetry History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '24h Microclimate Trend',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.navActiveGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Stable',
                        style: TextStyle(
                          color: AppColors.navActiveGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHistoryStat('Avg Temp', '23.8 °C', AppColors.tempCardEnd),
                    _buildHistoryStat('Avg Humidity', '76 %', AppColors.humidityCardEnd),
                    _buildHistoryStat('Avg Moisture', '68 %', AppColors.soilCardEnd),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Stylized bar chart representation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < 12; i++)
                      Container(
                        width: 16,
                        height: 30.0 + (i % 4) * 15.0 + (i % 3) * 10,
                        decoration: BoxDecoration(
                          color: i == 8
                              ? AppColors.navActiveGreen
                              : AppColors.navActiveGreen.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('00:00', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('06:00', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('12:00', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('18:00', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('Now', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.analytics_outlined, color: AppColors.brandIconGreen, size: 28),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Full telemetry export available via CSV or Cloud Sync.',
                    style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
