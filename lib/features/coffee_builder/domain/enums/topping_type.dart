import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum ToppingType {
  whippedCream,
  cinnamon,
  cocoa,
  caramelDrizzle,
  chocolateChips,
  nutmeg,
  marshmallows;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case ToppingType.whippedCream:
        return l10n.toppingWhippedCream;
      case ToppingType.cinnamon:
        return l10n.toppingCinnamon;
      case ToppingType.cocoa:
        return l10n.toppingCocoa;
      case ToppingType.caramelDrizzle:
        return l10n.toppingCaramelDrizzle;
      case ToppingType.chocolateChips:
        return l10n.toppingChocolateChips;
      case ToppingType.nutmeg:
        return l10n.toppingNutmeg;
      case ToppingType.marshmallows:
        return l10n.toppingMarshmallows;
    }
  }

  String get displayName {
    switch (this) {
      case ToppingType.whippedCream:
        return 'Whipped cream';
      case ToppingType.cinnamon:
        return 'Cinnamon';
      case ToppingType.cocoa:
        return 'Cocoa';
      case ToppingType.caramelDrizzle:
        return 'Caramel drizzle';
      case ToppingType.chocolateChips:
        return 'Chocolate chips';
      case ToppingType.nutmeg:
        return 'Nutmeg';
      case ToppingType.marshmallows:
        return 'Marshmallows';
    }
  }

  double get additionalPrice {
    switch (this) {
      case ToppingType.whippedCream:
        return 0.5;
      case ToppingType.cinnamon:
      case ToppingType.cocoa:
      case ToppingType.nutmeg:
        return 0.0;
      case ToppingType.caramelDrizzle:
        return 0.4;
      case ToppingType.chocolateChips:
      case ToppingType.marshmallows:
        return 0.6;
    }
  }
}
