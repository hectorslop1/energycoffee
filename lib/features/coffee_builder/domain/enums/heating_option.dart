import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum HeatingOption {
  cold,
  warm,
  hot;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case HeatingOption.cold:
        return l10n.coldOption;
      case HeatingOption.warm:
        return l10n.warmOption;
      case HeatingOption.hot:
        return l10n.hotOption;
    }
  }

  String get displayName {
    switch (this) {
      case HeatingOption.cold:
        return 'Cold';
      case HeatingOption.warm:
        return 'Warm';
      case HeatingOption.hot:
        return 'Hot';
    }
  }
}
