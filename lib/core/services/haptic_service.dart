import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticService {
  HapticService._();

  static Future<bool> get canVibrate async {
    return await Vibration.hasVibrator() ?? false;
  }

  static void light() {
    HapticFeedback.lightImpact();
  }

  static void medium() {
    HapticFeedback.mediumImpact();
  }

  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  static void selection() {
    HapticFeedback.selectionClick();
  }

  static void success() async {
    if (await canVibrate) {
      Vibration.vibrate(duration: 50);
    }
    HapticFeedback.mediumImpact();
  }

  static void warning() async {
    if (await canVibrate) {
      Vibration.vibrate(duration: 100);
    }
    HapticFeedback.heavyImpact();
  }

  static void error() async {
    if (await canVibrate) {
      Vibration.vibrate(duration: 150);
    }
    HapticFeedback.heavyImpact();
  }

  static void addToCart() {
    success();
  }

  static void removeFromCart() {
    warning();
  }

  static void paymentSuccess() async {
    if (await canVibrate) {
      Vibration.vibrate(duration: 100);
      await Future.delayed(const Duration(milliseconds: 150));
      Vibration.vibrate(duration: 100);
    }
    heavy();
  }

  static void scanSuccess() {
    success();
  }

  static void buttonPress() {
    light();
  }
}
