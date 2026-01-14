import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum MilkType {
  none,
  whole,
  skim,
  almond,
  oat,
  soy,
  coconut;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case MilkType.none:
        return l10n.noMilk;
      case MilkType.whole:
        return l10n.wholeMilk;
      case MilkType.skim:
        return l10n.skimMilk;
      case MilkType.almond:
        return l10n.almondMilk;
      case MilkType.oat:
        return l10n.oatMilk;
      case MilkType.soy:
        return l10n.soyMilk;
      case MilkType.coconut:
        return l10n.coconutMilk;
    }
  }

  String get displayName {
    switch (this) {
      case MilkType.none:
        return 'No milk';
      case MilkType.whole:
        return 'Whole milk';
      case MilkType.skim:
        return 'Skim milk';
      case MilkType.almond:
        return 'Almond milk';
      case MilkType.oat:
        return 'Oat milk';
      case MilkType.soy:
        return 'Soy milk';
      case MilkType.coconut:
        return 'Coconut milk';
    }
  }

  double get additionalPrice {
    switch (this) {
      case MilkType.none:
      case MilkType.whole:
      case MilkType.skim:
        return 0.0;
      case MilkType.almond:
      case MilkType.oat:
      case MilkType.soy:
      case MilkType.coconut:
        return 0.5;
    }
  }

  bool get isPlantBased {
    switch (this) {
      case MilkType.none:
      case MilkType.whole:
      case MilkType.skim:
        return false;
      case MilkType.almond:
      case MilkType.oat:
      case MilkType.soy:
      case MilkType.coconut:
        return true;
    }
  }
}
