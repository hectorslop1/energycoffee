import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../domain/enums/topping_type.dart';
import '../../../state/coffee_builder_state.dart';

class ToppingsSelector extends StatelessWidget {
  const ToppingsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CoffeeBuilderState>();
    final selectedToppings = state.currentCoffee.toppings;
    final hasNoToppings = selectedToppings.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).toppings,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Select one option',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 45,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: ToppingType.values.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _NoneChip(
                  isSelected: hasNoToppings,
                  onTap: () {
                    for (var topping in ToppingType.values) {
                      if (selectedToppings.contains(topping)) {
                        context
                            .read<CoffeeBuilderState>()
                            .toggleTopping(topping);
                      }
                    }
                  },
                );
              }

              final topping = ToppingType.values[index - 1];
              final isSelected = selectedToppings.contains(topping);
              return _ToppingChip(
                toppingType: topping,
                isSelected: isSelected,
                onTap: () =>
                    context.read<CoffeeBuilderState>().toggleTopping(topping),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NoneChip extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _NoneChip({
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBackgroundCard
                  : Colors.white),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            Text(
              'None',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToppingChip extends StatelessWidget {
  final ToppingType toppingType;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToppingChip({
    required this.toppingType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBackgroundCard
                  : Colors.white),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            Text(
              toppingType.getDisplayName(context),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : Colors.black87),
              ),
            ),
            if (toppingType.additionalPrice > 0) ...[
              const SizedBox(width: 8),
              Text(
                '+\$${toppingType.additionalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
