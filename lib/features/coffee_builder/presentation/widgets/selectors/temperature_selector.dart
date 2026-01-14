import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../domain/enums/temperature.dart';
import '../../../state/coffee_builder_state.dart';

class TemperatureSelector extends StatelessWidget {
  const TemperatureSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CoffeeBuilderState>();
    final selectedTemp = state.currentCoffee.temperature;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).temperature,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Temperature.values.map((temp) {
            final isSelected = temp == selectedTemp;
            return _TemperatureChip(
              temperature: temp,
              isSelected: isSelected,
              onTap: () =>
                  context.read<CoffeeBuilderState>().updateTemperature(temp),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TemperatureChip extends StatelessWidget {
  final Temperature temperature;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemperatureChip({
    required this.temperature,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBackgroundCard : Colors.white),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: 2,
          ),
        ),
        child: Text(
          temperature.getDisplayName(context),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : Colors.black87),
          ),
        ),
      ),
    );
  }
}
