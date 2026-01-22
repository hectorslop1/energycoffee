import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/coffee_builder_state.dart';
import '../../../domain/enums/coffee_type.dart';
import '../../../domain/enums/coffee_size.dart';
import '../../../domain/enums/temperature.dart';
import '../../../domain/enums/milk_type.dart';
import '../../../domain/enums/topping_type.dart';
import 'realistic_steam_widget.dart';

class CoffeeVisualWidget extends StatelessWidget {
  const CoffeeVisualWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeBuilderState>(
      builder: (context, state, child) {
        final coffee = state.currentCoffee;

        final String imagePath = _selectCoffeeImage(
          coffeeType: coffee.type,
          hasMilk: coffee.milkType != MilkType.none,
          toppingType: _getPrimaryTopping(coffee.toppings),
        );

        final double scale = _getSizeScale(coffee.size);

        return Container(
          height: 280,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Steam renders FIRST (behind the coffee cup)
              if (coffee.temperature != Temperature.iced)
                Positioned(
                  bottom: 105,
                  child: RealisticSteamWidget(
                    temperature: coffee.temperature,
                  ),
                ),

              // Coffee image (scaled based on size) - renders on top of steam
              Transform.scale(
                scale: scale,
                child: Image.asset(
                  imagePath,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.coffee,
                            size: 80,
                            color: Colors.brown.shade300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            coffee.type.displayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Selects the appropriate coffee image based on state
  String _selectCoffeeImage({
    required CoffeeType coffeeType,
    required bool hasMilk,
    required ToppingType? toppingType,
  }) {
    final String coffeeTypeName = _getCoffeeTypeImageName(coffeeType);

    // Priority 1: If topping is selected, use topping image
    if (toppingType == ToppingType.whippedCream) {
      return 'assets/images/Coffee_layers/Coffee_whippedcream/${coffeeTypeName}_whippedcream.png';
    } else if (toppingType == ToppingType.caramelDrizzle) {
      return 'assets/images/Coffee_layers/Coffee_caramel/${coffeeTypeName}_caramel.png';
    }

    // Priority 2: If milk is selected, use milk image
    if (hasMilk) {
      return 'assets/images/Coffee_layers/Coffee_withmilk/${coffeeTypeName}_withmilk.png';
    }

    // Priority 3: Use base coffee image
    return 'assets/images/Coffee_layers/Base_coffee/$coffeeTypeName.png';
  }

  /// Maps CoffeeType enum to image file name
  String _getCoffeeTypeImageName(CoffeeType type) {
    switch (type) {
      case CoffeeType.espresso:
        return 'espresso';
      case CoffeeType.americano:
        return 'americano';
      case CoffeeType.latte:
        return 'latte';
      case CoffeeType.cappuccino:
        return 'cappuccino';
      case CoffeeType.mocha:
        return 'mocha';
      case CoffeeType.flatWhite:
      case CoffeeType.macchiato:
      case CoffeeType.coldBrew:
        // For coffee types not in the asset list, default to latte
        return 'latte';
    }
  }

  /// Gets the primary topping (only whipped cream or caramel drizzle)
  /// Returns null if no valid topping is selected
  ToppingType? _getPrimaryTopping(List<ToppingType> toppings) {
    // Check for whipped cream first
    if (toppings.contains(ToppingType.whippedCream)) {
      return ToppingType.whippedCream;
    }

    // Check for caramel drizzle
    if (toppings.contains(ToppingType.caramelDrizzle)) {
      return ToppingType.caramelDrizzle;
    }

    // No valid topping
    return null;
  }

  /// Returns scale factor based on coffee size
  double _getSizeScale(CoffeeSize size) {
    switch (size) {
      case CoffeeSize.small:
        return 0.8;
      case CoffeeSize.medium:
        return 1.0;
      case CoffeeSize.large:
        return 1.2;
      case CoffeeSize.extraLarge:
        return 1.4;
    }
  }
}
