import 'package:flutter/material.dart';
import '../../../../domain/enums/coffee_size.dart';
import '../../../../domain/enums/coffee_type.dart';
import '../../../../domain/enums/milk_type.dart';

class FoamLayer extends StatelessWidget {
  final CoffeeType coffeeType;
  final CoffeeSize size;
  final MilkType milkType;

  const FoamLayer({
    super.key,
    required this.coffeeType,
    required this.size,
    required this.milkType,
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

  double get _foamThickness {
    switch (coffeeType) {
      case CoffeeType.cappuccino:
        return 0.25;
      case CoffeeType.latte:
        return 0.1;
      case CoffeeType.flatWhite:
        return 0.05;
      case CoffeeType.macchiato:
        return 0.15;
      case CoffeeType.mocha:
        return 0.12;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_foamThickness == 0.0 || milkType == MilkType.none) {
      return const SizedBox.shrink();
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final foamColor =
        isDarkMode ? const Color(0xFFFFF8E1) : const Color(0xFFFFFAF0);

    return CustomPaint(
      size: Size(_cupWidth, _cupHeight),
      painter: _FoamPainter(
        foamThickness: _foamThickness,
        foamColor: foamColor,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class _FoamPainter extends CustomPainter {
  final double foamThickness;
  final Color foamColor;
  final bool isDarkMode;

  _FoamPainter({
    required this.foamThickness,
    required this.foamColor,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          foamColor,
          foamColor.withOpacity(0.7),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final foamHeight = size.height * foamThickness;
    final foamTop = size.height * 0.1;

    final path = Path();
    path.moveTo(size.width * 0.2, foamTop);

    for (double i = 0; i <= 1; i += 0.1) {
      final x = size.width * 0.2 + (size.width * 0.6 * i);
      final y = foamTop + (i % 0.2 == 0 ? -3 : 3);
      path.lineTo(x, y);
    }

    path.lineTo(size.width * 0.8, foamTop + foamHeight);
    path.lineTo(size.width * 0.2, foamTop + foamHeight);
    path.close();

    canvas.drawPath(path, paint);

    final bubbleColor = isDarkMode
        ? Colors.white.withOpacity(0.3)
        : const Color(0xFF8D6E63).withOpacity(0.25);

    final bubblePaint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final x = size.width * 0.25 + (i * size.width * 0.07);
      final y = foamTop + (i % 2 == 0 ? 5 : 15);
      final radius = 2.0 + (i % 3);
      canvas.drawCircle(Offset(x, y), radius, bubblePaint);
    }
  }

  @override
  bool shouldRepaint(_FoamPainter oldDelegate) {
    return oldDelegate.foamThickness != foamThickness ||
        oldDelegate.foamColor != foamColor ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
