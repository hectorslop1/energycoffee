import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../state/coffee_builder_state.dart';
import '../../domain/enums/milk_type.dart';
import '../../domain/enums/topping_type.dart';
import '../../domain/enums/product_category.dart';

class SelectionSummaryPanel extends StatelessWidget {
  final Function(int) onStepTap;

  const SelectionSummaryPanel({
    super.key,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeBuilderState>(
      builder: (context, state, child) {
        if (!state.isFromProductSelection) {
          return _buildCoffeeBuilderSummary(context, state);
        } else {
          switch (state.productCategory) {
            case ProductCategory.coffee:
              return _buildProductCoffeeSummary(context, state);
            case ProductCategory.bakery:
              return _buildBakerySummary(context, state);
            case ProductCategory.sandwiches:
              return _buildSandwichSummary(context, state);
            case ProductCategory.extras:
              return _buildExtrasSummary(context, state);
          }
        }
      },
    );
  }

  Widget _buildCoffeeBuilderSummary(
      BuildContext context, CoffeeBuilderState state) {
    final steps = [
      _SummaryStep(
        index: 0,
        label: 'Type',
        value: state.currentCoffee.type.displayName,
        isCompleted: true,
        isCurrent: state.currentStep == 0,
      ),
      _SummaryStep(
        index: 1,
        label: 'Size',
        value: state.currentCoffee.size.displayName,
        isCompleted: state.currentStep > 1,
        isCurrent: state.currentStep == 1,
      ),
      _SummaryStep(
        index: 2,
        label: 'Temp',
        value: state.currentCoffee.temperature.displayName,
        isCompleted: state.currentStep > 2,
        isCurrent: state.currentStep == 2,
      ),
      _SummaryStep(
        index: 3,
        label: 'Milk',
        value: state.currentCoffee.milkType == MilkType.none
            ? 'None'
            : state.currentCoffee.milkType.displayName,
        isCompleted: state.currentStep > 3,
        isCurrent: state.currentStep == 3,
      ),
      _SummaryStep(
        index: 4,
        label: 'Sweet',
        value: state.currentCoffee.sweetenerLevel > 0
            ? '${state.currentCoffee.sweetenerLevel}x'
            : 'None',
        isCompleted: state.currentStep > 4,
        isCurrent: state.currentStep == 4,
      ),
      _SummaryStep(
        index: 5,
        label: 'Topping',
        value: _getToppingDisplay(state.currentCoffee.toppings),
        isCompleted: state.currentStep > 5,
        isCurrent: state.currentStep == 5,
      ),
    ];

    return _buildHorizontalSummary(context, steps);
  }

  Widget _buildProductCoffeeSummary(
      BuildContext context, CoffeeBuilderState state) {
    final steps = [
      _SummaryStep(
        index: 0,
        label: 'Size',
        value: state.currentCoffee.size.displayName,
        isCompleted: state.currentStep > 0,
        isCurrent: state.currentStep == 0,
      ),
      _SummaryStep(
        index: 1,
        label: 'Temp',
        value: state.currentCoffee.temperature.displayName,
        isCompleted: state.currentStep > 1,
        isCurrent: state.currentStep == 1,
      ),
      _SummaryStep(
        index: 2,
        label: 'Milk',
        value: state.currentCoffee.milkType == MilkType.none
            ? 'None'
            : state.currentCoffee.milkType.displayName,
        isCompleted: state.currentStep > 2,
        isCurrent: state.currentStep == 2,
      ),
      _SummaryStep(
        index: 3,
        label: 'Sweet',
        value: state.currentCoffee.sweetenerLevel > 0
            ? '${state.currentCoffee.sweetenerLevel}x'
            : 'None',
        isCompleted: state.currentStep > 3,
        isCurrent: state.currentStep == 3,
      ),
      _SummaryStep(
        index: 4,
        label: 'Topping',
        value: _getToppingDisplay(state.currentCoffee.toppings),
        isCompleted: state.currentStep > 4,
        isCurrent: state.currentStep == 4,
      ),
    ];

    return _buildHorizontalSummary(context, steps);
  }

  Widget _buildBakerySummary(BuildContext context, CoffeeBuilderState state) {
    final steps = [
      _SummaryStep(
        index: 0,
        label: 'Heating',
        value: state.heatingOption.displayName,
        isCompleted: true,
        isCurrent: state.currentStep == 0,
      ),
    ];

    return _buildHorizontalSummary(context, steps);
  }

  Widget _buildSandwichSummary(BuildContext context, CoffeeBuilderState state) {
    final steps = [
      _SummaryStep(
        index: 0,
        label: 'Bread',
        value: state.breadType.displayName,
        isCompleted: true,
        isCurrent: state.currentStep == 0,
      ),
      _SummaryStep(
        index: 1,
        label: 'Veggies',
        value:
            state.vegetables.isEmpty ? 'None' : '${state.vegetables.length}x',
        isCompleted: state.currentStep > 1,
        isCurrent: state.currentStep == 1,
      ),
    ];

    return _buildHorizontalSummary(context, steps);
  }

  Widget _buildExtrasSummary(BuildContext context, CoffeeBuilderState state) {
    final steps = [
      _SummaryStep(
        index: 0,
        label: 'Quantity',
        value: '${state.quantity}',
        isCompleted: state.quantity > 0,
        isCurrent: state.currentStep == 0,
      ),
    ];

    return _buildHorizontalSummary(context, steps);
  }

  Widget _buildHorizontalSummary(
      BuildContext context, List<_SummaryStep> steps) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
          bottom: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final step = steps[index];
          return _buildStepCard(context, step, isDark);
        },
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, _SummaryStep step, bool isDark) {
    final isActive = step.isCurrent;
    final isCompleted = step.isCompleted;

    return GestureDetector(
      onTap: () => onStepTap(step.index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(
          minWidth: 70,
          maxWidth: 100,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.15)
              : (isDark ? Colors.grey.shade800 : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : (isCompleted
                    ? AppColors.primary.withOpacity(0.3)
                    : (isDark ? Colors.grey.shade700 : Colors.grey.shade300)),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCompleted && !isActive)
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.check_circle,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ),
                Flexible(
                  child: Text(
                    step.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? AppColors.primary
                          : (isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              step.value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? AppColors.primary
                    : (isDark ? Colors.white : Colors.black87),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getToppingDisplay(List<ToppingType> toppings) {
    if (toppings.isEmpty) return 'None';

    final visualToppings = toppings
        .where((t) =>
            t == ToppingType.whippedCream || t == ToppingType.caramelDrizzle)
        .toList();

    if (visualToppings.isEmpty) return 'None';
    if (visualToppings.length == 1) return visualToppings.first.displayName;
    return '${visualToppings.length}x';
  }
}

class _SummaryStep {
  final int index;
  final String label;
  final String value;
  final bool isCompleted;
  final bool isCurrent;

  _SummaryStep({
    required this.index,
    required this.label,
    required this.value,
    required this.isCompleted,
    required this.isCurrent,
  });
}
