import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../domain/enums/coffee_size.dart';
import '../../../state/coffee_builder_state.dart';

class SizeSelector extends StatelessWidget {
  const SizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CoffeeBuilderState>();
    final selectedSize = state.currentCoffee.size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).selectYourSize,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: CoffeeSize.values.map((size) {
            final isSelected = size == selectedSize;
            return _SizeOption(
              size: size,
              isSelected: isSelected,
              onTap: () => context.read<CoffeeBuilderState>().updateSize(size),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SizeOption extends StatelessWidget {
  final CoffeeSize size;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeOption({
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  double get _cupHeight {
    switch (size) {
      case CoffeeSize.small:
        return 60.0;
      case CoffeeSize.medium:
        return 80.0;
      case CoffeeSize.large:
        return 100.0;
      case CoffeeSize.extraLarge:
        return 120.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 120,
            width: 70,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                height: _cupHeight,
                width: _cupHeight * 0.6,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            size.getDisplayName(context),
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkTextPrimary : Colors.black87),
            ),
          ),
          Text(
            '${size.ounces} oz',
            style: TextStyle(
              fontSize: 11,
              color:
                  isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
