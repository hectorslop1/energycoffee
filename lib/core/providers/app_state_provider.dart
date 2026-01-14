import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  bool _isOnboardingCompleted = false;
  bool _isDemoMode = true;
  bool _isBiometricLoginEnabled = false;
  String? _currentUserId;

  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isDemoMode => _isDemoMode;
  bool get isBiometricLoginEnabled => _isBiometricLoginEnabled;
  String? get currentUserId => _currentUserId;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    _isDemoMode = prefs.getBool('demo_mode') ?? true;
    _isBiometricLoginEnabled =
        prefs.getBool('biometric_login_enabled') ?? false;
    _currentUserId = prefs.getString('current_user_id');
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    _isOnboardingCompleted = true;
    notifyListeners();
  }

  Future<void> setDemoMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('demo_mode', enabled);
    _isDemoMode = enabled;
    notifyListeners();
  }

  Future<void> setBiometricLoginEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_login_enabled', enabled);
    _isBiometricLoginEnabled = enabled;
    notifyListeners();
  }

  Future<void> setCurrentUser(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      await prefs.setString('current_user_id', userId);
    } else {
      await prefs.remove('current_user_id');
    }
    _currentUserId = userId;
    notifyListeners();
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isOnboardingCompleted = false;
    _isDemoMode = true;
    _isBiometricLoginEnabled = false;
    _currentUserId = null;
    notifyListeners();
  }
}
