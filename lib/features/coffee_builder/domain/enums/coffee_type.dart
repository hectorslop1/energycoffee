import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum CoffeeType {
  espresso,
  americano,
  latte,
  cappuccino,
  mocha,
  flatWhite,
  macchiato,
  coldBrew;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case CoffeeType.espresso:
        return l10n.coffeeEspresso;
      case CoffeeType.americano:
        return l10n.coffeeAmericano;
      case CoffeeType.latte:
        return l10n.coffeeLatte;
      case CoffeeType.cappuccino:
        return l10n.coffeeCappuccino;
      case CoffeeType.mocha:
        return l10n.coffeeMocha;
      case CoffeeType.flatWhite:
        return l10n.coffeeFlatWhite;
      case CoffeeType.macchiato:
        return l10n.coffeeMacchiato;
      case CoffeeType.coldBrew:
        return l10n.coffeeColdBrew;
    }
  }

  String get displayName {
    switch (this) {
      case CoffeeType.espresso:
        return 'Espresso';
      case CoffeeType.americano:
        return 'Americano';
      case CoffeeType.latte:
        return 'Latte';
      case CoffeeType.cappuccino:
        return 'Cappuccino';
      case CoffeeType.mocha:
        return 'Mocha';
      case CoffeeType.flatWhite:
        return 'Flat White';
      case CoffeeType.macchiato:
        return 'Macchiato';
      case CoffeeType.coldBrew:
        return 'Cold Brew';
    }
  }

  String get description {
    switch (this) {
      case CoffeeType.espresso:
        return 'Café concentrado y fuerte';
      case CoffeeType.americano:
        return 'Espresso con agua caliente';
      case CoffeeType.latte:
        return 'Espresso con leche vaporizada';
      case CoffeeType.cappuccino:
        return 'Espresso con leche y espuma';
      case CoffeeType.mocha:
        return 'Latte con chocolate';
      case CoffeeType.flatWhite:
        return 'Espresso con microespuma';
      case CoffeeType.macchiato:
        return 'Espresso con toque de leche';
      case CoffeeType.coldBrew:
        return 'Café frío de extracción lenta';
    }
  }

  bool get requiresMilk {
    switch (this) {
      case CoffeeType.espresso:
      case CoffeeType.americano:
      case CoffeeType.coldBrew:
        return false;
      case CoffeeType.latte:
      case CoffeeType.cappuccino:
      case CoffeeType.mocha:
      case CoffeeType.flatWhite:
      case CoffeeType.macchiato:
        return true;
    }
  }

  double get basePrice {
    switch (this) {
      case CoffeeType.espresso:
        return 2.5;
      case CoffeeType.americano:
        return 3.0;
      case CoffeeType.latte:
        return 4.0;
      case CoffeeType.cappuccino:
        return 4.0;
      case CoffeeType.mocha:
        return 4.5;
      case CoffeeType.flatWhite:
        return 4.25;
      case CoffeeType.macchiato:
        return 3.5;
      case CoffeeType.coldBrew:
        return 3.75;
    }
  }
}
