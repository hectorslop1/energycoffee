import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CheckoutProgressBar extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CheckoutProgressBar({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        steps.length * 2 - 1,
        (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            return _buildStep(
              stepIndex + 1,
              steps[stepIndex],
              isActive: currentStep == stepIndex,
              isCompleted: currentStep > stepIndex,
            );
          } else {
            final stepIndex = index ~/ 2;
            return _buildConnector(isCompleted: currentStep > stepIndex);
          }
        },
      ),
    );
  }

  Widget _buildStep(int number, String label,
      {required bool isActive, required bool isCompleted}) {
    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient:
                  isActive || isCompleted ? AppColors.primaryGradient : null,
              color: !isActive && !isCompleted
                  ? AppColors.textSecondary.withValues(alpha: 0.3)
                  : null,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnector({required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          gradient: isCompleted ? AppColors.primaryGradient : null,
          color: isCompleted
              ? null
              : AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
