import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../domain/enums/milk_type.dart';
import '../../../state/coffee_builder_state.dart';

class MilkSelector extends StatelessWidget {
  const MilkSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CoffeeBuilderState>();
    final selectedMilk = state.currentCoffee.milkType;
    final coffeeType = state.currentCoffee.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).milkType,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (!coffeeType.requiresMilk)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Optional for this coffee type',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: MilkType.values.length,
            itemBuilder: (context, index) {
              final milk = MilkType.values[index];
              final isSelected = milk == selectedMilk;
              return _MilkOption(
                milkType: milk,
                isSelected: isSelected,
                onTap: () =>
                    context.read<CoffeeBuilderState>().updateMilkType(milk),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MilkOption extends StatelessWidget {
  final MilkType milkType;
  final bool isSelected;
  final VoidCallback onTap;

  const _MilkOption({
    required this.milkType,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBackgroundCard : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              milkType.getDisplayName(context),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextPrimary : Colors.black87),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              milkType.additionalPrice > 0
                  ? '+\$${milkType.additionalPrice.toStringAsFixed(2)}'
                  : 'Included',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
