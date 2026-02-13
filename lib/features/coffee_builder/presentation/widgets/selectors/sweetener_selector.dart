import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../domain/enums/sweetener_type.dart';
import '../../../state/coffee_builder_state.dart';

class SweetenerSelector extends StatelessWidget {
  const SweetenerSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CoffeeBuilderState>();
    final selectedSweetener = state.currentCoffee.sweetenerType;
    final sweetenerLevel = state.currentCoffee.sweetenerLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).sweetener,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
            itemCount: SweetenerType.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final sweetener = SweetenerType.values[index];
              final isSelected = sweetener == selectedSweetener;
              return _SweetenerChip(
                sweetenerType: sweetener,
                isSelected: isSelected,
                onTap: () {
                  final newLevel = sweetener == SweetenerType.none ? 0 : 2;
                  context
                      .read<CoffeeBuilderState>()
                      .updateSweetener(sweetener, newLevel);
                },
              );
            },
          ),
        ),
        if (selectedSweetener != SweetenerType.none) ...[
          const SizedBox(height: 16),
          const Text(
            'Sweetness level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: sweetenerLevel.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: const Color(0xFF6D4C41),
                  label: sweetenerLevel.toString(),
                  onChanged: (value) {
                    context.read<CoffeeBuilderState>().updateSweetener(
                          selectedSweetener,
                          value.toInt(),
                        );
                  },
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF6D4C41),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    sweetenerLevel.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SweetenerChip extends StatelessWidget {
  final SweetenerType sweetenerType;
  final bool isSelected;
  final VoidCallback onTap;

  const _SweetenerChip({
    required this.sweetenerType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sweetenerType.getDisplayName(context),
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
            if (sweetenerType.additionalPrice > 0) ...[
              const SizedBox(width: 8),
              Text(
                '+\$${sweetenerType.additionalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ],
            if (sweetenerType.isFlavored) ...[
              const SizedBox(width: 4),
              Text(
                '✨',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.amber,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
