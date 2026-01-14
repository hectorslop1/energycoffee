import 'package:flutter/material.dart';
import '../../../../domain/enums/coffee_size.dart';
import '../../../../domain/enums/temperature.dart';

class CupLayer extends StatelessWidget {
  final CoffeeSize size;
  final Temperature temperature;

  const CupLayer({
    super.key,
    required this.size,
    required this.temperature,
  });

  double get _cupHeight {
    switch (size) {
      case CoffeeSize.small:
        return 180.0;
      case CoffeeSize.medium:
        return 220.0;
      case CoffeeSize.large:
        return 260.0;
      case CoffeeSize.extraLarge:
        return 300.0;
    }
  }

  double get _cupWidth {
    return _cupHeight * 0.6;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomPaint(
      size: Size(_cupWidth, _cupHeight),
      painter: _CupPainter(
        cupColor:
            isDarkMode ? const Color(0xFFE0E0E0) : const Color(0xFFF5F5F5),
        outlineColor:
            isDarkMode ? const Color(0xFFD2691E) : const Color(0xFF8B4513),
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class _CupPainter extends CustomPainter {
  final Color cupColor;
  final Color outlineColor;
  final bool isDarkMode;

  _CupPainter({
    required this.cupColor,
    required this.outlineColor,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cupColor
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();

    // Siempre dibuja la taza cónica (forma de trapecio)
    path.moveTo(size.width * 0.2, size.height * 0.1);
    path.lineTo(size.width * 0.1, size.height * 0.9);
    path.lineTo(size.width * 0.9, size.height * 0.9);
    path.lineTo(size.width * 0.8, size.height * 0.1);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, outlinePaint);

    // Siempre dibuja el asa
    final handlePath = Path();
    handlePath.addArc(
      Rect.fromLTWH(
        size.width * 0.85,
        size.height * 0.3,
        size.width * 0.25,
        size.height * 0.3,
      ),
      -1.5,
      3.0,
    );
    canvas.drawPath(handlePath, outlinePaint);
  }

  @override
  bool shouldRepaint(_CupPainter oldDelegate) {
    return oldDelegate.cupColor != cupColor ||
        oldDelegate.outlineColor != outlineColor ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
