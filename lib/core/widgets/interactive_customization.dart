import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/haptic_service.dart';

class AnimatedCounter extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minValue;
  final int maxValue;
  final Color? activeColor;

  const AnimatedCounter({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.minValue = 0,
    this.maxValue = 99,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para visibilidad
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > minValue
                ? () {
                    HapticService.light();
                    onDecrement();
                  }
                : null,
            icon: Icon(
              value > minValue
                  ? Icons.remove_rounded
                  : Icons.delete_outline_rounded,
              size: 20,
            ),
            color: value > minValue
                ? (activeColor ?? AppColors.primary)
                : AppColors.error,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 24), // Evita colapso
            alignment: Alignment.center, // Centra el número
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TweenAnimationBuilder<int>(
              tween: IntTween(begin: value, end: value),
              duration: const Duration(milliseconds: 300),
              builder: (context, animatedValue, child) {
                return Text(
                  '$animatedValue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Número siempre negro
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: value < maxValue
                ? () {
                    HapticService.light();
                    onIncrement();
                  }
                : null,
            icon: const Icon(Icons.add_rounded, size: 20),
            color: activeColor ?? AppColors.primary,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
