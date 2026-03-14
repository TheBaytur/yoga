import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:antigravity/presentation/theme/zen_design_system.dart';

class ZenProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final String label;

  const ZenProgressRing({
    super.key,
    required this.progress,
    this.size = 60,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _ProgressPainter(
                  progress: value,
                  color: ZenColors.sageGreen,
                  backgroundColor: ZenColors.sageGreen.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    '${(value * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: size * 0.25,
                      fontWeight: FontWeight.bold,
                      color: ZenColors.deepTeal,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: ZenColors.slateGray),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    const strokeWidth = 6.0;

    // Draw background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Draw progress
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
