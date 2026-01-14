import 'package:flutter/material.dart';
import '../../../../domain/enums/coffee_size.dart';
import '../../../../domain/enums/coffee_type.dart';
import '../../../../domain/enums/milk_type.dart';
import '../../../../domain/enums/temperature.dart';

class LiquidLayer extends StatelessWidget {
  final CoffeeType coffeeType;
  final CoffeeSize size;
  final MilkType milkType;
  final Temperature temperature;

  const LiquidLayer({
    super.key,
    required this.coffeeType,
    required this.size,
    required this.milkType,
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

  Color get _liquidColor {
    if (coffeeType == CoffeeType.mocha) {
      return const Color(0xFF3E2723);
    }

    if (milkType == MilkType.none) {
      return const Color(0xFF2C1810);
    }

    switch (coffeeType) {
      case CoffeeType.espresso:
        return const Color(0xFF3E2723);
      case CoffeeType.americano:
        return const Color(0xFF4E342E);
      case CoffeeType.latte:
      case CoffeeType.flatWhite:
        return const Color(0xFFBCAAA4);
      case CoffeeType.cappuccino:
        return const Color(0xFFA1887F);
      case CoffeeType.macchiato:
        return const Color(0xFF6D4C41);
      case CoffeeType.coldBrew:
        return const Color(0xFF5D4037);
      case CoffeeType.mocha:
        return const Color(0xFF3E2723);
    }
  }

  double get _fillLevel {
    switch (coffeeType) {
      case CoffeeType.espresso:
        return 0.3;
      case CoffeeType.macchiato:
        return 0.4;
      case CoffeeType.americano:
      case CoffeeType.coldBrew:
        return 0.75;
      case CoffeeType.latte:
      case CoffeeType.cappuccino:
      case CoffeeType.mocha:
      case CoffeeType.flatWhite:
        return 0.8;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIced = temperature == Temperature.iced;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomPaint(
      size: Size(_cupWidth, _cupHeight),
      painter: _LiquidPainter(
        liquidColor: _liquidColor,
        fillLevel: _fillLevel,
        isIced: isIced,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final Color liquidColor;
  final double fillLevel;
  final bool isIced;
  final bool isDarkMode;

  _LiquidPainter({
    required this.liquidColor,
    required this.fillLevel,
    required this.isIced,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          liquidColor.withOpacity(0.9),
          liquidColor,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();

    // Siempre usa la forma cónica de la taza
    final topWidth = size.width * 0.6;
    final liquidHeight = size.height * 0.8 * fillLevel;
    final liquidTop = size.height * 0.9 - liquidHeight;

    final topLeft = (size.width - topWidth) / 2;
    final bottomLeft = size.width * 0.1;

    path.moveTo(topLeft + (bottomLeft - topLeft) * (1 - fillLevel), liquidTop);
    path.lineTo(bottomLeft, size.height * 0.9);
    path.lineTo(size.width * 0.9, size.height * 0.9);
    path.lineTo(size.width - topLeft - (bottomLeft - topLeft) * (1 - fillLevel),
        liquidTop);
    path.close();

    canvas.drawPath(path, paint);

    if (isIced) {
      _drawIceCubes(canvas, size);
    }
  }

  void _drawIceCubes(Canvas canvas, Size size) {
    final iceColor = isDarkMode
        ? const Color(0xFFE3F2FD).withOpacity(0.8)
        : const Color(0xFFB0BEC5).withOpacity(0.6);

    final iceOutlineColor = isDarkMode
        ? const Color(0xFF90CAF9).withOpacity(0.9)
        : const Color(0xFF78909C).withOpacity(0.8);

    final icePaint = Paint()
      ..color = iceColor
      ..style = PaintingStyle.fill;

    final iceOutline = Paint()
      ..color = iceOutlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cubes = [
      Rect.fromLTWH(size.width * 0.25, size.height * 0.4, 20, 20),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.35, 18, 18),
      Rect.fromLTWH(size.width * 0.35, size.height * 0.55, 22, 22),
    ];

    for (final cube in cubes) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(cube, const Radius.circular(3)),
        icePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(cube, const Radius.circular(3)),
        iceOutline,
      );
    }
  }

  @override
  bool shouldRepaint(_LiquidPainter oldDelegate) {
    return oldDelegate.liquidColor != liquidColor ||
        oldDelegate.fillLevel != fillLevel ||
        oldDelegate.isIced != isIced ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
