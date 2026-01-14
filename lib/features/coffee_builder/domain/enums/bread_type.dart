import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum BreadType {
  white,
  wheat,
  multigrain,
  sourdough,
  ciabatta;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case BreadType.white:
        return l10n.whiteBread;
      case BreadType.wheat:
        return l10n.wheatBread;
      case BreadType.multigrain:
        return l10n.multigrain;
      case BreadType.sourdough:
        return l10n.sourdough;
      case BreadType.ciabatta:
        return l10n.ciabatta;
    }
  }

  String get displayName {
    switch (this) {
      case BreadType.white:
        return 'White Bread';
      case BreadType.wheat:
        return 'Wheat Bread';
      case BreadType.multigrain:
        return 'Multigrain';
      case BreadType.sourdough:
        return 'Sourdough';
      case BreadType.ciabatta:
        return 'Ciabatta';
    }
  }

  double get priceModifier {
    switch (this) {
      case BreadType.white:
      case BreadType.wheat:
        return 0.0;
      case BreadType.multigrain:
        return 1.0;
      case BreadType.sourdough:
        return 1.5;
      case BreadType.ciabatta:
        return 1.0;
    }
  }
}
