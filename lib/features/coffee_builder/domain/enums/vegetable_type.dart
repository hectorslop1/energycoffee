import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum VegetableType {
  lettuce,
  tomato,
  onion,
  cucumber,
  pickles,
  peppers,
  avocado;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case VegetableType.lettuce:
        return l10n.lettuce;
      case VegetableType.tomato:
        return l10n.tomato;
      case VegetableType.onion:
        return l10n.onion;
      case VegetableType.cucumber:
        return l10n.cucumber;
      case VegetableType.pickles:
        return l10n.pickles;
      case VegetableType.peppers:
        return l10n.peppers;
      case VegetableType.avocado:
        return l10n.avocado;
    }
  }

  String get displayName {
    switch (this) {
      case VegetableType.lettuce:
        return 'Lettuce';
      case VegetableType.tomato:
        return 'Tomato';
      case VegetableType.onion:
        return 'Onion';
      case VegetableType.cucumber:
        return 'Cucumber';
      case VegetableType.pickles:
        return 'Pickles';
      case VegetableType.peppers:
        return 'Peppers';
      case VegetableType.avocado:
        return 'Avocado';
    }
  }

  double get priceModifier {
    switch (this) {
      case VegetableType.lettuce:
      case VegetableType.tomato:
      case VegetableType.onion:
      case VegetableType.cucumber:
      case VegetableType.pickles:
      case VegetableType.peppers:
        return 0.0;
      case VegetableType.avocado:
        return 2.0;
    }
  }
}
