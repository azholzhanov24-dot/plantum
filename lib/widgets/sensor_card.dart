import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Modern, clean white sensor card widget based on the Plantum reference design.
class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final double? progress;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.progress,
    this.isSwitch = false,
    this.switchValue = false,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: context.dividerLineColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.035),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        borderRadius: BorderRadius.circular(24.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(24.0),
          canRequestFocus: false,
          focusColor: Colors.transparent,
          hoverColor: Colors.black.withValues(alpha: 0.03),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Zone A: Top Row (Icon & Status badge / Switch)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Leading Icon
                      Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: (isSwitch && !switchValue)
                              ? context.subtleSurfaceColor
                              : accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          icon,
                          size: 20.0,
                          color: (isSwitch && !switchValue)
                              ? context.textSecondaryColor
                              : accentColor,
                        ),
                      ),
                      const SizedBox(width: 4.0),

                      // Right side: "Norm" badge or interactive Switch
                      if (isSwitch)
                        _buildSwitch()
                      else
                        Flexible(child: _buildNormBadge(context)),
                    ],
                  ),

                  // Zone B: Middle Part (Title & Value)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 18.0,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: context.textSecondaryColor,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w700,
                            color: context.textPrimaryColor,
                            letterSpacing: -0.5,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Zone C: Bottom Part (Progress indicator & Subtitle)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isSwitch && progress != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: SizedBox(
                            height: 5.0,
                            child: LinearProgressIndicator(
                              value: progress!.clamp(0.0, 1.0),
                              backgroundColor: accentColor.withValues(alpha: 0.20),
                              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7.0),
                      ],
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: context.textSecondaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildNormBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.5),
      decoration: BoxDecoration(
        color: AppColors.badgeGreenBg,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          context.strings.norm,
          style: const TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            color: AppColors.badgeGreenText,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    return Focus(
      canRequestFocus: false,
      descendantsAreFocusable: false,
      child: GestureDetector(
        onTap: () => onToggle?.call(!switchValue),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 44.0,
          height: 25.0,
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            color: switchValue ? accentColor : const Color(0xFFD8DCD9),
          ),
          alignment: switchValue ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 19.0,
            height: 19.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 3.0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
