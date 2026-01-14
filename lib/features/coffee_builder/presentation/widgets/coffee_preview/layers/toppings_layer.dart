import 'package:flutter/material.dart';
import '../../../../domain/enums/coffee_size.dart';
import '../../../../domain/enums/topping_type.dart';
import '../../../../domain/enums/sweetener_type.dart';

class ToppingsLayer extends StatelessWidget {
  final List<ToppingType> toppings;
  final CoffeeSize size;
  final SweetenerType sweetenerType;

  const ToppingsLayer({
    super.key,
    required this.toppings,
    required this.size,
    required this.sweetenerType,
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
    if (toppings.isEmpty && sweetenerType == SweetenerType.none) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: Size(_cupWidth, _cupHeight),
      painter: _ToppingsPainter(
        toppings: toppings,
        sweetenerType: sweetenerType,
      ),
    );
  }
}

class _ToppingsPainter extends CustomPainter {
  final List<ToppingType> toppings;
  final SweetenerType sweetenerType;

  _ToppingsPainter({
    required this.toppings,
    required this.sweetenerType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (toppings.contains(ToppingType.whippedCream)) {
      _drawWhippedCream(canvas, size);
    }

    if (toppings.contains(ToppingType.caramelDrizzle) ||
        sweetenerType == SweetenerType.caramel) {
      _drawCaramelDrizzle(canvas, size);
    }

    if (toppings.contains(ToppingType.chocolateChips)) {
      _drawChocolateChips(canvas, size);
    }

    if (toppings.contains(ToppingType.cinnamon)) {
      _drawCinnamon(canvas, size);
    }

    if (toppings.contains(ToppingType.cocoa)) {
      _drawCocoa(canvas, size);
    }

    if (toppings.contains(ToppingType.marshmallows)) {
      _drawMarshmallows(canvas, size);
    }
  }

  void _drawWhippedCream(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFAF0)
      ..style = PaintingStyle.fill;

    final path = Path();
    final topY = size.height * 0.05;

    path.moveTo(size.width * 0.3, topY + 20);
    path.quadraticBezierTo(
      size.width * 0.35,
      topY,
      size.width * 0.4,
      topY + 15,
    );
    path.quadraticBezierTo(
      size.width * 0.5,
      topY - 5,
      size.width * 0.6,
      topY + 15,
    );
    path.quadraticBezierTo(
      size.width * 0.65,
      topY,
      size.width * 0.7,
      topY + 20,
    );
    path.lineTo(size.width * 0.3, topY + 20);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawCaramelDrizzle(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final startY = size.height * 0.08;

    path.moveTo(size.width * 0.25, startY);
    path.quadraticBezierTo(
      size.width * 0.35,
      startY + 15,
      size.width * 0.45,
      startY + 10,
    );
    path.quadraticBezierTo(
      size.width * 0.55,
      startY + 5,
      size.width * 0.65,
      startY + 20,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      startY + 25,
      size.width * 0.75,
      startY + 20,
    );

    canvas.drawPath(path, paint);
  }

  void _drawChocolateChips(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.fill;

    final chips = [
      Offset(size.width * 0.35, size.height * 0.12),
      Offset(size.width * 0.5, size.height * 0.08),
      Offset(size.width * 0.65, size.height * 0.15),
      Offset(size.width * 0.45, size.height * 0.18),
      Offset(size.width * 0.6, size.height * 0.22),
    ];

    for (final chip in chips) {
      canvas.drawCircle(chip, 3, paint);
    }
  }

  void _drawCinnamon(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B4513).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = size.width * 0.25 + (i % 10) * (size.width * 0.05);
      final y = size.height * 0.08 + (i ~/ 10) * 8;
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  void _drawCocoa(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3E2723).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      final x = size.width * 0.25 + (i % 12) * (size.width * 0.04);
      final y = size.height * 0.08 + (i ~/ 12) * 6;
      canvas.drawCircle(Offset(x, y), 0.8, paint);
    }
  }

  void _drawMarshmallows(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFF8F0)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFFFFE4E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final marshmallows = [
      Rect.fromLTWH(size.width * 0.3, size.height * 0.1, 15, 12),
      Rect.fromLTWH(size.width * 0.5, size.height * 0.08, 14, 11),
      Rect.fromLTWH(size.width * 0.65, size.height * 0.12, 16, 13),
    ];

    for (final marshmallow in marshmallows) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(marshmallow, const Radius.circular(4)),
        paint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(marshmallow, const Radius.circular(4)),
        outlinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ToppingsPainter oldDelegate) {
    return oldDelegate.toppings != toppings ||
        oldDelegate.sweetenerType != sweetenerType;
  }
}
