import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/biometric_service.dart';

class BiometricProvider extends ChangeNotifier {
  final BiometricService _biometricService = BiometricService();
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;

  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isBiometricAvailable => _isBiometricAvailable;

  BiometricProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkBiometricAvailability();
    await _loadBiometricPreference();
  }

  Future<void> _checkBiometricAvailability() async {
    _isBiometricAvailable = await _biometricService.isBiometricAvailable();
    notifyListeners();
  }

  Future<void> _loadBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    notifyListeners();
  }

  Future<void> toggleBiometric(bool value) async {
    if (!_isBiometricAvailable && value) {
      return;
    }

    _isBiometricEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
    notifyListeners();
  }

  Future<bool> authenticate({String? reason}) async {
    print('🔒 [BiometricProvider] authenticate llamado');
    print('🔒 [BiometricProvider] isBiometricEnabled: $_isBiometricEnabled');
    print(
        '🔒 [BiometricProvider] isBiometricAvailable: $_isBiometricAvailable');

    if (!_isBiometricEnabled || !_isBiometricAvailable) {
      print(
          '🔒 [BiometricProvider] ❌ Biométrico no disponible o no habilitado');
      return false;
    }

    print(
        '🔒 [BiometricProvider] Llamando a _biometricService.authenticate...');
    final result = await _biometricService.authenticate(
      localizedReason: reason ?? 'Autentícate para iniciar sesión',
    );
    print('🔒 [BiometricProvider] Resultado de authenticate: $result');
    return result;
  }

  bool isIOS() {
    return _biometricService.isIOS();
  }

  bool isAndroid() {
    return _biometricService.isAndroid();
  }
}
