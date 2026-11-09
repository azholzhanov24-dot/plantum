import 'dart:math' as math;
import 'package:flutter/material.dart';

enum SensorType {
  temperature,
  humidity,
  soilMoisture,
  light,
}

/// Reusable sensor card widget accurately styled after the Figma design.
class SensorCard extends StatelessWidget {
  final SensorType type;
  final String title;
  final String value;
  final String rangeOrMode;
  final Color gradientStart;
  final Color gradientEnd;
  final VoidCallback? onTap;

  const SensorCard({
    super.key,
    required this.type,
    required this.title,
    required this.value,
    required this.rangeOrMode,
    required this.gradientStart,
    required this.gradientEnd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradientStart, gradientEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: gradientEnd.withValues(alpha: 0.32),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // Stylized graphic / watermark
                _buildGraphic(),

                // Text Content
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: _buildCardContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    switch (type) {
      case SensorType.temperature:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1E1E),
                letterSpacing: -0.2,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 48), // Space for thermometer graphic
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF141414),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Text(
                        rangeOrMode,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E1E1E).withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

      case SensorType.humidity:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1B1B),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF141414),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rangeOrMode,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1B1B1B).withValues(alpha: 0.55),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        );

      case SensorType.soilMoisture:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1B1B),
                height: 1.15,
                letterSpacing: -0.2,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF141414),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rangeOrMode,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1B1B1B).withValues(alpha: 0.55),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        );

      case SensorType.light:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1B1B),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF141414),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    rangeOrMode,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1B1B1B).withValues(alpha: 0.55),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildGraphic() {
    switch (type) {
      case SensorType.temperature:
        return Positioned(
          left: 10,
          bottom: 10,
          child: SizedBox(
            width: 48,
            height: 68,
            child: CustomPaint(
              painter: _ThermometerPainter(),
            ),
          ),
        );

      case SensorType.humidity:
        return Positioned(
          left: 12,
          top: 10,
          child: SizedBox(
            width: 42,
            height: 52,
            child: CustomPaint(
              painter: _DropletPainter(),
            ),
          ),
        );

      case SensorType.soilMoisture:
        return Positioned(
          right: 8,
          top: 6,
          child: SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: _SproutWatermarkPainter(),
            ),
          ),
        );

      case SensorType.light:
        return Positioned(
          left: 8,
          top: 6,
          child: SizedBox(
            width: 62,
            height: 62,
            child: CustomPaint(
              painter: _SunPainter(),
            ),
          ),
        );
    }
  }
}

/// Custom painter for the glowing thermometer graphic with translucent pill & bulb.
class _ThermometerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    const bulbRadius = 18.0;
    const stemWidth = 18.0;
    const stemTop = 8.0;

    // Outer thick rounded silhouette in translucent white
    final outerPath = Path();
    outerPath.moveTo(center.dx - stemWidth / 2, center.dy - 12);
    outerPath.lineTo(center.dx - stemWidth / 2, stemTop + stemWidth / 2);
    outerPath.arcToPoint(
      Offset(center.dx + stemWidth / 2, stemTop + stemWidth / 2),
      radius: const Radius.circular(stemWidth / 2),
    );
    outerPath.lineTo(center.dx + stemWidth / 2, center.dy - 12);
    outerPath.addOval(Rect.fromCircle(center: center, radius: bulbRadius));

    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..style = PaintingStyle.fill;
    canvas.drawPath(outerPath, glowPaint);

    // Inner mercury column
    const innerStemWidth = 8.0;
    final innerPath = Path();
    innerPath.moveTo(center.dx - innerStemWidth / 2, center.dy);
    innerPath.lineTo(center.dx - innerStemWidth / 2, stemTop + 14);
    innerPath.arcToPoint(
      Offset(center.dx + innerStemWidth / 2, stemTop + 14),
      radius: const Radius.circular(innerStemWidth / 2),
    );
    innerPath.lineTo(center.dx + innerStemWidth / 2, center.dy);
    innerPath.addOval(Rect.fromCircle(center: center, radius: bulbRadius * 0.55));

    final mercuryPaint = Paint()
      ..color = const Color(0xFFFF5252).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerPath, mercuryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the soft water droplet in the Humidity card.
class _DropletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final dropPath = Path();
    dropPath.moveTo(w * 0.5, 4);
    dropPath.cubicTo(w * 0.85, h * 0.45, w, h * 0.72, w * 0.5, h - 2);
    dropPath.cubicTo(0, h * 0.72, w * 0.15, h * 0.45, w * 0.5, 4);
    dropPath.close();

    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dropPath, fillPaint);

    // Inner subtle curve
    final innerPath = Path();
    innerPath.moveTo(w * 0.58, h * 0.62);
    innerPath.cubicTo(w * 0.7, h * 0.72, w * 0.55, h * 0.85, w * 0.45, h * 0.86);

    final linePaint = Paint()
      ..color = const Color(0xFF2196F3).withValues(alpha: 0.4)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(innerPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the large sprout watermark in the Soil moisture card.
class _SproutWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.36)
      ..style = PaintingStyle.fill;

    // Stem
    final stem = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.42, h * 0.38, w * 0.12, h * 0.55),
      const Radius.circular(8),
    );
    canvas.drawRRect(stem, paint);

    // Left leaf
    final leftLeaf = Path();
    leftLeaf.moveTo(w * 0.46, h * 0.46);
    leftLeaf.cubicTo(w * 0.1, h * 0.42, 0, h * 0.15, w * 0.35, h * 0.15);
    leftLeaf.cubicTo(w * 0.42, h * 0.28, w * 0.46, h * 0.38, w * 0.46, h * 0.46);
    leftLeaf.close();
    canvas.drawPath(leftLeaf, paint);

    // Right leaf
    final rightLeaf = Path();
    rightLeaf.moveTo(w * 0.48, h * 0.46);
    rightLeaf.cubicTo(w * 0.65, h * 0.36, w * 0.75, h * 0.12, w, h * 0.1);
    rightLeaf.cubicTo(w * 0.98, h * 0.42, w * 0.7, h * 0.55, w * 0.48, h * 0.46);
    rightLeaf.close();
    canvas.drawPath(rightLeaf, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the sun graphic with radiating soft pills in the Light card.
class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 13.0;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    // Center disc
    canvas.drawCircle(center, radius, paint);

    // 8 rays
    const numRays = 8;
    const rayLength = 5.5;
    const rayDist = radius + 4.5;
    final rayPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < numRays; i++) {
      final angle = (i * 2 * math.pi) / numRays;
      final start = Offset(
        center.dx + math.cos(angle) * rayDist,
        center.dy + math.sin(angle) * rayDist,
      );
      final end = Offset(
        center.dx + math.cos(angle) * (rayDist + rayLength),
        center.dy + math.sin(angle) * (rayDist + rayLength),
      );
      canvas.drawLine(start, end, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
