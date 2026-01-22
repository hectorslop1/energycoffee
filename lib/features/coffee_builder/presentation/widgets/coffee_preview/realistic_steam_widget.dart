import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../domain/enums/temperature.dart';

class RealisticSteamWidget extends StatefulWidget {
  final Temperature temperature;

  const RealisticSteamWidget({
    super.key,
    required this.temperature,
  });

  @override
  State<RealisticSteamWidget> createState() => _RealisticSteamWidgetState();
}

class _RealisticSteamWidgetState extends State<RealisticSteamWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<SteamParticle> _particles = [];
  final math.Random _random = math.Random();
  double _time = 0.0;
  int _frameCount = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _time = elapsed.inMilliseconds / 1000.0;
      _frameCount++;

      final config = _getTemperatureConfig(widget.temperature);

      // Emit new particles based on temperature
      if (config.emissionRate > 0 &&
          _frameCount % config.emissionInterval == 0) {
        _emitParticle(config);
      }

      // Update existing particles
      _particles.removeWhere((p) => p.isDead);
      for (var particle in _particles) {
        particle.update(config);
      }
    });
  }

  void _emitParticle(TemperatureConfig config) {
    // Emit from coffee surface inside cup with narrow horizontal variance
    final xOffset = (_random.nextDouble() - 0.5) * 12.0;

    _particles.add(SteamParticle(
      x: 60.0 + xOffset,
      y: 185.0, // Start from coffee surface level inside cup
      vx: (_random.nextDouble() - 0.5) * config.horizontalSpread,
      vy: -config.riseSpeed * (0.8 + _random.nextDouble() * 0.4),
      size: 3.0 + _random.nextDouble() * 3.0,
      opacity: 0.0,
      lifespan: 2.5 + _random.nextDouble() * 1.5,
      turbulence: config.turbulence,
      random: _random,
    ));
  }

  TemperatureConfig _getTemperatureConfig(Temperature temp) {
    switch (temp) {
      case Temperature.iced:
        return TemperatureConfig(
          emissionRate: 0,
          emissionInterval: 999,
          riseSpeed: 0,
          turbulence: 0,
          horizontalSpread: 0,
        );
      case Temperature.warm:
        return TemperatureConfig(
          emissionRate: 2,
          emissionInterval: 8,
          riseSpeed: 25.0,
          turbulence: 0.3,
          horizontalSpread: 8.0,
        );
      case Temperature.hot:
        return TemperatureConfig(
          emissionRate: 4,
          emissionInterval: 5,
          riseSpeed: 35.0,
          turbulence: 0.5,
          horizontalSpread: 12.0,
        );
      case Temperature.extraHot:
        return TemperatureConfig(
          emissionRate: 6,
          emissionInterval: 3,
          riseSpeed: 45.0,
          turbulence: 0.7,
          horizontalSpread: 18.0,
        );
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.temperature == Temperature.iced) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 120,
      height: 200,
      child: CustomPaint(
        painter: SteamPainter(
          particles: _particles,
          time: _time,
        ),
      ),
    );
  }
}

class TemperatureConfig {
  final int emissionRate;
  final int emissionInterval;
  final double riseSpeed;
  final double turbulence;
  final double horizontalSpread;

  TemperatureConfig({
    required this.emissionRate,
    required this.emissionInterval,
    required this.riseSpeed,
    required this.turbulence,
    required this.horizontalSpread,
  });
}

class SteamParticle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;
  double age;
  final double lifespan;
  final double turbulence;
  final math.Random random;
  final double noiseOffsetX;
  final double noiseOffsetY;

  SteamParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
    required this.lifespan,
    required this.turbulence,
    required this.random,
  })  : age = 0.0,
        noiseOffsetX = random.nextDouble() * 1000,
        noiseOffsetY = random.nextDouble() * 1000;

  bool get isDead => age >= lifespan;

  void update(TemperatureConfig config) {
    age += 0.016; // ~60fps

    // Rise upward
    y += vy * 0.016;

    // Horizontal drift with turbulence
    final turbulenceX = (math.sin(age * 2.0 + noiseOffsetX) *
            math.cos(age * 1.5 + noiseOffsetY)) *
        turbulence *
        15.0;
    x += (vx + turbulenceX) * 0.016;

    // Slow down as it rises (air resistance)
    vy *= 0.99;
    vx *= 0.98;

    // Expand as it rises (subtle growth)
    size += 0.15;

    // Fade in quickly, then fade out
    final lifeProgress = age / lifespan;
    if (lifeProgress < 0.1) {
      opacity = lifeProgress / 0.1;
    } else if (lifeProgress > 0.6) {
      opacity = 1.0 - ((lifeProgress - 0.6) / 0.4);
    } else {
      opacity = 1.0;
    }

    // Reduce opacity as it rises (diffusion)
    opacity *= math.max(0.0, 1.0 - (200.0 - y) / 200.0);
  }
}

class SteamPainter extends CustomPainter {
  final List<SteamParticle> particles;
  final double time;

  SteamPainter({
    required this.particles,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Main particle with soft edges
      final paint = Paint()
        ..color = Color.fromRGBO(230, 235, 245, particle.opacity * 0.25)
        ..maskFilter = const ui.MaskFilter.blur(BlurStyle.normal, 2.5);

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );

      // Subtle inner glow
      final glowPaint = Paint()
        ..color = Color.fromRGBO(250, 252, 255, particle.opacity * 0.15)
        ..maskFilter = const ui.MaskFilter.blur(BlurStyle.normal, 1.5);

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size * 0.5,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(SteamPainter oldDelegate) => true;
}
