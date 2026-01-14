import 'dart:io';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Servicio para manejar autenticación biométrica
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Verifica si el dispositivo soporta biométricos
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  /// Obtiene los tipos de biométricos disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Autentica usando biométricos
  /// Retorna true si la autenticación fue exitosa
  Future<bool> authenticate({
    String localizedReason = 'Por favor autentícate para continuar',
  }) async {
    try {
      print('🔐 [BiometricService] Iniciando authenticate con localAuth...');
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Permite PIN/patrón como fallback
        ),
      );
      print(
          '🔐 [BiometricService] Resultado de localAuth.authenticate: $didAuthenticate');
      return didAuthenticate;
    } on PlatformException catch (e) {
      print(
          '🔐 [BiometricService] ❌ PlatformException: ${e.code} - ${e.message}');
      // Manejar errores específicos
      if (e.code == 'NotAvailable') {
        // Biométricos no disponibles
        print('🔐 [BiometricService] Error: Biométricos no disponibles');
        return false;
      } else if (e.code == 'NotEnrolled') {
        // No hay biométricos registrados
        print('🔐 [BiometricService] Error: No hay biométricos registrados');
        return false;
      } else if (e.code == 'LockedOut') {
        // Demasiados intentos fallidos
        print('🔐 [BiometricService] Error: Bloqueado por intentos fallidos');
        return false;
      } else if (e.code == 'PermanentlyLockedOut') {
        // Bloqueado permanentemente
        print('🔐 [BiometricService] Error: Bloqueado permanentemente');
        return false;
      }
      print('🔐 [BiometricService] Error no manejado: ${e.code}');
      return false;
    } catch (e) {
      print('🔐 [BiometricService] ❌ Error inesperado: $e');
      return false;
    }
  }

  /// Verifica si hay biométricos fuertes disponibles (huella/face)
  Future<bool> hasStrongBiometrics() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong) ||
        biometrics.contains(BiometricType.face);
  }

  /// Obtiene el tipo de biométrico disponible
  Future<BiometricType?> getPrimaryBiometricType() async {
    final biometrics = await getAvailableBiometrics();
    if (biometrics.contains(BiometricType.face)) {
      return BiometricType.face;
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return BiometricType.fingerprint;
    } else if (biometrics.contains(BiometricType.strong)) {
      return BiometricType.strong;
    }
    return null;
  }

  /// Verifica si es iOS
  bool isIOS() {
    return Platform.isIOS;
  }

  /// Verifica si es Android
  bool isAndroid() {
    return Platform.isAndroid;
  }
}
