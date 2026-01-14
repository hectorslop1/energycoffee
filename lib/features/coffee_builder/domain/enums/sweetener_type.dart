import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum SweetenerType {
  none,
  sugar,
  honey,
  stevia,
  agave,
  vanilla,
  caramel,
  hazelnut;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case SweetenerType.none:
        return l10n.noSweetener;
      case SweetenerType.sugar:
        return l10n.sugar;
      case SweetenerType.honey:
        return l10n.honey;
      case SweetenerType.stevia:
        return l10n.stevia;
      case SweetenerType.agave:
        return l10n.agave;
      case SweetenerType.vanilla:
        return l10n.vanilla;
      case SweetenerType.caramel:
        return l10n.caramel;
      case SweetenerType.hazelnut:
        return l10n.hazelnut;
    }
  }

  String get displayName {
    switch (this) {
      case SweetenerType.none:
        return 'No sweetener';
      case SweetenerType.sugar:
        return 'Sugar';
      case SweetenerType.honey:
        return 'Honey';
      case SweetenerType.stevia:
        return 'Stevia';
      case SweetenerType.agave:
        return 'Agave';
      case SweetenerType.vanilla:
        return 'Vanilla';
      case SweetenerType.caramel:
        return 'Caramel';
      case SweetenerType.hazelnut:
        return 'Hazelnut';
    }
  }

  double get additionalPrice {
    switch (this) {
      case SweetenerType.none:
      case SweetenerType.sugar:
      case SweetenerType.stevia:
        return 0.0;
      case SweetenerType.honey:
      case SweetenerType.agave:
        return 0.3;
      case SweetenerType.vanilla:
      case SweetenerType.caramel:
      case SweetenerType.hazelnut:
        return 0.5;
    }
  }

  bool get isFlavored {
    switch (this) {
      case SweetenerType.none:
      case SweetenerType.sugar:
      case SweetenerType.honey:
      case SweetenerType.stevia:
      case SweetenerType.agave:
        return false;
      case SweetenerType.vanilla:
      case SweetenerType.caramel:
      case SweetenerType.hazelnut:
        return true;
    }
  }
}
