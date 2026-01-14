import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../domain/enums/heating_option.dart';
import '../../../state/coffee_builder_state.dart';

class HeatingOptionSelector extends StatelessWidget {
  const HeatingOptionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Consumer<CoffeeBuilderState>(
      builder: (context, state, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.heatingPreference,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: HeatingOption.values.map((option) {
                final isSelected = state.heatingOption == option;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: option != HeatingOption.values.last ? 12 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        state.updateHeatingOption(option);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? AppColors.primaryGradient
                              : (isDark
                                  ? AppColors.darkCardGradient
                                  : AppColors.lightCardGradient),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade300),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              option == HeatingOption.cold
                                  ? Icons.ac_unit
                                  : option == HeatingOption.warm
                                      ? Icons.thermostat
                                      : Icons.local_fire_department,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.getTextPrimary(context),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              option.getDisplayName(context),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.getTextPrimary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
