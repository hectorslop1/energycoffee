import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

enum Temperature {
  iced,
  warm,
  hot,
  extraHot;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case Temperature.iced:
        return l10n.tempIced;
      case Temperature.warm:
        return l10n.tempWarm;
      case Temperature.hot:
        return l10n.tempHot;
      case Temperature.extraHot:
        return l10n.tempExtraHot;
    }
  }

  String get displayName {
    switch (this) {
      case Temperature.iced:
        return 'Cold';
      case Temperature.warm:
        return 'Warm';
      case Temperature.hot:
        return 'Hot';
      case Temperature.extraHot:
        return 'Extra Hot';
    }
  }

  String get icon {
    switch (this) {
      case Temperature.iced:
        return '❄️';
      case Temperature.warm:
        return '☕';
      case Temperature.hot:
        return '🔥';
      case Temperature.extraHot:
        return '🌡️';
    }
  }
}
