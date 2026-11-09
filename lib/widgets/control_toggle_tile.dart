import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'custom_figma_switch.dart';

enum ActuatorType {
  watering,
  lighting,
  ventilation,
}

/// Control toggle tile widget matching Figma's actuator cards.
class ControlToggleTile extends StatelessWidget {
  final ActuatorType type;
  final String title;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const ControlToggleTile({
    super.key,
    required this.type,
    required this.title,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F1),
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28.0),
          onTap: () => onChanged(!isEnabled),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // Icon
                _buildLeadingIcon(),
                const SizedBox(width: 16.0),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        isEnabled ? 'On' : 'Off',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Switch
                CustomFigmaSwitch(
                  value: isEnabled,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    switch (type) {
      case ActuatorType.watering:
        return const Icon(
          Icons.water_drop_rounded,
          color: AppColors.waterBlue,
          size: 32.0,
        );

      case ActuatorType.lighting:
        return const Icon(
          Icons.wb_sunny_rounded,
          color: AppColors.lightYellow,
          size: 32.0,
        );

      case ActuatorType.ventilation:
        return const _FanIcon(
          color: AppColors.fanGreen,
          size: 32.0,
        );
    }
  }
}

/// Custom 4-blade fan/propeller icon accurately matching Figma's ventilation icon.
class _FanIcon extends StatelessWidget {
  final Color color;
  final double size;

  const _FanIcon({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FanPainter(color: color),
      ),
    );
  }
}

class _FanPainter extends CustomPainter {
  final Color color;

  _FanPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Center hub
    canvas.drawCircle(center, size.width * 0.14, paint);

    // 4 rounded propeller blades
    for (int i = 0; i < 4; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * 3.1415926535 / 2);

      final bladePath = Path();
      bladePath.moveTo(0, -size.width * 0.1);
      bladePath.cubicTo(
        size.width * 0.28, -size.width * 0.25,
        size.width * 0.38, -size.width * 0.46,
        size.width * 0.18, -size.width * 0.48,
      );
      bladePath.cubicTo(
        0, -size.width * 0.45,
        -size.width * 0.08, -size.width * 0.25,
        0, -size.width * 0.1,
      );
      bladePath.close();

      canvas.drawPath(bladePath, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _FanPainter oldDelegate) => oldDelegate.color != color;
}
