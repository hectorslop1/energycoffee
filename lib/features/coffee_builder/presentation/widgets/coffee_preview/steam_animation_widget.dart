import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/enums/temperature.dart';

class SteamAnimationWidget extends StatelessWidget {
  final Temperature temperature;

  const SteamAnimationWidget({
    super.key,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    final steamConfig = _getSteamConfig(temperature);

    if (steamConfig.particleCount == 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 120,
      height: 100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: List.generate(steamConfig.particleCount, (index) {
          final offsetX = (index % 3) * 20.0 - 20.0;
          final delayMs = index * 300;
          final particleSize = 15.0 + (index % 2) * 10.0;

          return Positioned(
            left: 50 + offsetX,
            bottom: 0,
            child: _SteamParticle(
              delay: delayMs,
              baseOpacity: steamConfig.baseOpacity,
              size: particleSize,
              driftAmount: 0.3 + (index % 3) * 0.2,
              riseDistance: steamConfig.riseDistance,
              duration: steamConfig.duration,
            ),
          );
        }),
      ),
    );
  }

  _SteamConfig _getSteamConfig(Temperature temp) {
    switch (temp) {
      case Temperature.iced:
        return _SteamConfig(
          particleCount: 0,
          baseOpacity: 0.0,
          riseDistance: 0.0,
          duration: 0,
        );
      case Temperature.warm:
        return _SteamConfig(
          particleCount: 3,
          baseOpacity: 0.15,
          riseDistance: 1.2,
          duration: 2500,
        );
      case Temperature.hot:
        return _SteamConfig(
          particleCount: 5,
          baseOpacity: 0.25,
          riseDistance: 1.8,
          duration: 2200,
        );
      case Temperature.extraHot:
        return _SteamConfig(
          particleCount: 7,
          baseOpacity: 0.35,
          riseDistance: 2.2,
          duration: 2000,
        );
    }
  }
}

class _SteamConfig {
  final int particleCount;
  final double baseOpacity;
  final double riseDistance;
  final int duration;

  _SteamConfig({
    required this.particleCount,
    required this.baseOpacity,
    required this.riseDistance,
    required this.duration,
  });
}

class _SteamParticle extends StatelessWidget {
  final int delay;
  final double baseOpacity;
  final double size;
  final double driftAmount;
  final double riseDistance;
  final int duration;

  const _SteamParticle({
    required this.delay,
    required this.baseOpacity,
    required this.size,
    required this.driftAmount,
    required this.riseDistance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 2.5,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomCenter,
          radius: 1.2,
          colors: [
            Colors.white.withOpacity(baseOpacity * 0.8),
            Colors.white.withOpacity(baseOpacity * 0.4),
            Colors.white.withOpacity(0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .fadeIn(
          duration: 600.ms,
          delay: delay.ms,
          curve: Curves.easeIn,
        )
        .slideY(
          begin: 0,
          end: -riseDistance,
          duration: duration.ms,
          delay: delay.ms,
          curve: Curves.easeOut,
        )
        .slideX(
          begin: 0,
          end: driftAmount * (delay % 2 == 0 ? 1 : -1),
          duration: duration.ms,
          delay: delay.ms,
          curve: Curves.easeInOut,
        )
        .scale(
          begin: const Offset(0.6, 0.6),
          end: const Offset(1.4, 1.6),
          duration: duration.ms,
          delay: delay.ms,
          curve: Curves.easeOut,
        )
        .fadeOut(
          duration: 700.ms,
          delay: (delay + (duration * 0.6).toInt()).ms,
          curve: Curves.easeIn,
        );
  }
}
