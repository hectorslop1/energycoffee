import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum ToppingType {
  whippedCream,
  caramelDrizzle;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case ToppingType.whippedCream:
        return l10n.toppingWhippedCream;
      case ToppingType.caramelDrizzle:
        return l10n.toppingCaramelDrizzle;
    }
  }

  String get displayName {
    switch (this) {
      case ToppingType.whippedCream:
        return 'Whipped cream';
      case ToppingType.caramelDrizzle:
        return 'Caramel drizzle';
    }
  }

  double get additionalPrice {
    switch (this) {
      case ToppingType.whippedCream:
        return 0.5;
      case ToppingType.caramelDrizzle:
        return 0.4;
    }
  }
}
