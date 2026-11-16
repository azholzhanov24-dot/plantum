import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
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
          backgroundColor: context.bgColor,
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
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        border: Border(top: BorderSide(color: context.dividerLineColor, width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.25 : 0.06),
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
                tooltip: context.strings.navHome,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.tune_rounded,
                activeIcon: Icons.tune_rounded,
                tooltip: context.strings.navControl,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications_none_rounded,
                activeIcon: Icons.notifications_rounded,
                tooltip: context.strings.navNotifications,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.history_rounded,
                activeIcon: Icons.history_rounded,
                tooltip: context.strings.navHistory,
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
        canRequestFocus: false,
        focusColor: Colors.transparent,
        hoverColor: Colors.black.withValues(alpha: 0.03),
        splashColor: AppColors.navActiveGreen.withValues(alpha: 0.12),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? context.greenSoftColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Icon(
            isSelected ? activeIcon : icon,
            size: 26.0,
            color: isSelected ? context.brandGreenColor : context.textSecondaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsPlaceholder() {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          context.strings.notifications,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.textPrimaryColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildNotificationItem(
            title: context.strings.notifWateringTitle,
            subtitle: context.strings.notifWateringSub,
            time: context.strings.time12mAgo,
            icon: Icons.water_drop_rounded,
            iconColor: AppColors.waterBlue,
          ),
          _buildNotificationItem(
            title: context.strings.notifTempTitle,
            subtitle: context.strings.notifTempSub,
            time: context.strings.time1hAgo,
            icon: Icons.thermostat_rounded,
            iconColor: AppColors.tempAccent,
          ),
          _buildNotificationItem(
            title: context.strings.notifVentTitle,
            subtitle: context.strings.notifVentSub,
            time: context.strings.time3hAgo,
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
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: context.dividerLineColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.03),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: context.textSecondaryColor,
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
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          context.strings.telemetryHistory,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.textPrimaryColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: context.dividerLineColor, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.03),
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
                    Expanded(
                      child: Text(
                        context.strings.trend24h,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.greenSoftColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.strings.stable,
                        style: TextStyle(
                          color: context.brandGreenColor,
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
                    _buildHistoryStat(context.strings.avgTemp, '23.8 °C', AppColors.tempAccent),
                    _buildHistoryStat(context.strings.avgHumidity, '76 %', AppColors.humidityAccent),
                    _buildHistoryStat(context.strings.avgMoisture, '68 %', AppColors.soilAccent),
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
                              ? context.brandGreenColor
                              : context.brandGreenColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('00:00', style: TextStyle(fontSize: 11, color: context.textSecondaryColor)),
                    Text('06:00', style: TextStyle(fontSize: 11, color: context.textSecondaryColor)),
                    Text('12:00', style: TextStyle(fontSize: 11, color: context.textSecondaryColor)),
                    Text('18:00', style: TextStyle(fontSize: 11, color: context.textSecondaryColor)),
                    Text('Now', style: TextStyle(fontSize: 11, color: context.textSecondaryColor)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(22.0),
              border: Border.all(color: context.dividerLineColor, width: 1.0),
            ),
            child: Row(
              children: [
                Icon(Icons.analytics_outlined, color: context.brandGreenColor, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    context.strings.exportNotice,
                    style: TextStyle(fontSize: 13.5, color: context.textSecondaryColor),
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
            color: context.textSecondaryColor,
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
