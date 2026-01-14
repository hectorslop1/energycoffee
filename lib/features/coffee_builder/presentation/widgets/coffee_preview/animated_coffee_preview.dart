import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../state/coffee_builder_state.dart';
import '../../../domain/enums/temperature.dart';
import 'layers/cup_layer.dart';
import 'layers/liquid_layer.dart';
import 'layers/foam_layer.dart';
import 'layers/toppings_layer.dart';
import 'layers/steam_layer.dart';

class AnimatedCoffeePreview extends StatelessWidget {
  const AnimatedCoffeePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeBuilderState>(
      builder: (context, state, child) {
        final coffee = state.currentCoffee;

        return Container(
          height: 220,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CupLayer(
                size: coffee.size,
                temperature: coffee.temperature,
              )
                  .animate(
                      key: ValueKey('cup_${coffee.size}_${coffee.temperature}'))
                  .scale(
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: 300.ms),
              LiquidLayer(
                coffeeType: coffee.type,
                size: coffee.size,
                milkType: coffee.milkType,
                temperature: coffee.temperature,
              )
                  .animate(
                      key: ValueKey('liquid_${coffee.type}_${coffee.milkType}'))
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(duration: 400.ms),
              if (coffee.type.requiresMilk)
                FoamLayer(
                  coffeeType: coffee.type,
                  size: coffee.size,
                  milkType: coffee.milkType,
                )
                    .animate(key: ValueKey('foam_${coffee.type}'))
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.0, 1.0),
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 300.ms, delay: 200.ms),
              ToppingsLayer(
                toppings: coffee.toppings,
                size: coffee.size,
                sweetenerType: coffee.sweetenerType,
              )
                  .animate(key: ValueKey('toppings_${coffee.toppings.length}'))
                  .slideY(
                    begin: -0.2,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.bounceOut,
                  )
                  .fadeIn(duration: 300.ms, delay: 300.ms),
              if (coffee.temperature != Temperature.iced)
                SteamLayer(
                  temperature: coffee.temperature,
                  isVisible: coffee.temperature == Temperature.hot ||
                      coffee.temperature == Temperature.extraHot,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms),
            ],
          ),
        );
      },
    );
  }
}
