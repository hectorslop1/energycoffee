import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/coffee_builder_state.dart';
import '../../../domain/enums/temperature.dart';
import 'layers/cup_layer.dart';
import 'layers/liquid_layer.dart';
import 'layers/foam_layer.dart';
import 'layers/toppings_layer.dart';
import 'layers/steam_layer.dart';

class CoffeePreview extends StatelessWidget {
  const CoffeePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeBuilderState>(
      builder: (context, state, child) {
        final coffee = state.currentCoffee;

        return Container(
          height: 400,
          padding: const EdgeInsets.all(24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CupLayer(
                size: coffee.size,
                temperature: coffee.temperature,
              ),
              LiquidLayer(
                coffeeType: coffee.type,
                size: coffee.size,
                milkType: coffee.milkType,
                temperature: coffee.temperature,
              ),
              if (coffee.type.requiresMilk)
                FoamLayer(
                  coffeeType: coffee.type,
                  size: coffee.size,
                  milkType: coffee.milkType,
                ),
              ToppingsLayer(
                toppings: coffee.toppings,
                size: coffee.size,
                sweetenerType: coffee.sweetenerType,
              ),
              if (coffee.temperature != Temperature.iced)
                SteamLayer(
                  temperature: coffee.temperature,
                  isVisible: coffee.temperature == Temperature.hot ||
                      coffee.temperature == Temperature.extraHot,
                ),
            ],
          ),
        );
      },
    );
  }
}
