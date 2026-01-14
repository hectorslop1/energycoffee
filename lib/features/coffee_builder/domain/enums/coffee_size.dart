import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum CoffeeSize {
  small,
  medium,
  large,
  extraLarge;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case CoffeeSize.small:
        return l10n.sizeSmall;
      case CoffeeSize.medium:
        return l10n.sizeMedium;
      case CoffeeSize.large:
        return l10n.sizeLarge;
      case CoffeeSize.extraLarge:
        return l10n.sizeExtraLarge;
    }
  }

  String get displayName {
    switch (this) {
      case CoffeeSize.small:
        return 'Small';
      case CoffeeSize.medium:
        return 'Medium';
      case CoffeeSize.large:
        return 'Large';
      case CoffeeSize.extraLarge:
        return 'Extra Large';
    }
  }

  int get ounces {
    switch (this) {
      case CoffeeSize.small:
        return 8;
      case CoffeeSize.medium:
        return 12;
      case CoffeeSize.large:
        return 16;
      case CoffeeSize.extraLarge:
        return 20;
    }
  }

  double get priceMultiplier {
    switch (this) {
      case CoffeeSize.small:
        return 1.0;
      case CoffeeSize.medium:
        return 1.3;
      case CoffeeSize.large:
        return 1.6;
      case CoffeeSize.extraLarge:
        return 2.0;
    }
  }
}
