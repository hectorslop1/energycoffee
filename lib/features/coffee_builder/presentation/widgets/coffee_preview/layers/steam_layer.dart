import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../domain/enums/temperature.dart';

class SteamLayer extends StatefulWidget {
  final Temperature temperature;
  final bool isVisible;

  const SteamLayer({
    super.key,
    required this.temperature,
    required this.isVisible,
  });

  @override
  State<SteamLayer> createState() => _SteamLayerState();
}

class _SteamLayerState extends State<SteamLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 300),
          painter: _SteamPainter(
            animationValue: _controller.value,
            opacity: widget.temperature == Temperature.extraHot ? 0.9 : 0.7,
            isDarkMode: isDarkMode,
          ),
        );
      },
    );
  }
}

class _SteamPainter extends CustomPainter {
  final double animationValue;
  final double opacity;
  final bool isDarkMode;

  _SteamPainter({
    required this.animationValue,
    required this.opacity,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final steamColor = isDarkMode ? Colors.white : const Color(0xFF616161);

    final paint = Paint()
      ..color = steamColor.withOpacity(opacity * (1 - animationValue))
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final steamPaths = [
      _createSteamPath(size, 0.4, animationValue),
      _createSteamPath(size, 0.5, animationValue + 0.3),
      _createSteamPath(size, 0.6, animationValue + 0.6),
    ];

    for (final path in steamPaths) {
      canvas.drawPath(path, paint);
    }
  }

  Path _createSteamPath(Size size, double xPosition, double progress) {
    final normalizedProgress = progress % 1.0;
    final path = Path();

    final startX = size.width * xPosition;
    final startY = size.height * 0.05;

    path.moveTo(startX, startY);

    for (double i = 0; i <= 1; i += 0.1) {
      final y = startY - (size.height * 0.15 * i * normalizedProgress);
      final x = startX +
          (size.width * 0.05 * math.sin(i * 6.28 + normalizedProgress * 6.28));
      final width = 8 * (1 - i * normalizedProgress);

      if (i == 0) {
        path.moveTo(x - width / 2, y);
      } else {
        path.lineTo(x - width / 2, y);
      }
    }

    for (double i = 1; i >= 0; i -= 0.1) {
      final y = startY - (size.height * 0.15 * i * normalizedProgress);
      final x = startX +
          (size.width * 0.05 * math.sin(i * 6.28 + normalizedProgress * 6.28));
      final width = 8 * (1 - i * normalizedProgress);
      path.lineTo(x + width / 2, y);
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_SteamPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.opacity != opacity;
  }
}
