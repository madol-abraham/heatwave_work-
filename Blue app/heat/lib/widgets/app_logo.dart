import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  
  const AppLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HeatwaveLogoPainter(),
      ),
    );
  }
}

class _HeatwaveLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Draw sunset gradient background circle
    paint.shader = RadialGradient(
      colors: [
        AppColors.sunsetGold,
        AppColors.sunsetOrange,
        AppColors.primary,
      ],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, paint);
    
    // Draw sun rays
    paint.shader = null;
    paint.color = AppColors.sunsetGold;
    paint.strokeWidth = size.width * 0.03;
    paint.style = PaintingStyle.stroke;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final startRadius = radius * 0.7;
      final endRadius = radius * 1.2;
      
      final start = Offset(
        center.dx + startRadius * cos(angle),
        center.dy + startRadius * sin(angle),
      );
      final end = Offset(
        center.dx + endRadius * cos(angle),
        center.dy + endRadius * sin(angle),
      );
      
      canvas.drawLine(start, end, paint);
    }
    
    // Draw thermometer icon in center
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;
    
    final thermometerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.15,
        height: size.height * 0.5,
      ),
      Radius.circular(size.width * 0.075),
    );
    canvas.drawRRect(thermometerRect, paint);
    
    // Draw thermometer bulb
    paint.color = AppColors.extremeRisk;
    canvas.drawCircle(
      Offset(center.dx, center.dy + size.height * 0.15),
      size.width * 0.08,
      paint,
    );
  }

  double cos(double angle) => math.cos(angle);
  double sin(double angle) => math.sin(angle);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}