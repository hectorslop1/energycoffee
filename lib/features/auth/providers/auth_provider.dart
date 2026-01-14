import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');

    if (userJson != null) {
      try {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        _user = UserModel.fromJson(userMap);
        _status = AuthStatus.authenticated;
        notifyListeners();
      } catch (e) {
        await prefs.remove('current_user');
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      }
    } else {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String emailOrPhone,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement Hive local auth
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      _user = UserModel(
        id: '1',
        email: emailOrPhone,
        firstName: 'Usuario',
        lastName: 'Demo',
        createdAt: now,
        updatedAt: now,
      );
      _status = AuthStatus.authenticated;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(_user!.toJson()));

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithBiometric() async {
    print('🔑 [AuthProvider] loginWithBiometric iniciado');
    // NO cambiar el estado a loading para evitar reconstrucciones prematuras
    _error = null;

    try {
      // TODO: Implement biometric auth
      print('🔑 [AuthProvider] Esperando 1 segundo (simulación)...');
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      _user = UserModel(
        id: '1',
        email: 'biometric@user.com',
        firstName: 'Usuario',
        lastName: 'Biométrico',
        createdAt: now,
        updatedAt: now,
      );
      _status = AuthStatus.authenticated;
      print('🔑 [AuthProvider] Usuario creado: ${_user?.email}');
      print('🔑 [AuthProvider] Status cambiado a: $_status');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(_user!.toJson()));
      print('🔑 [AuthProvider] Usuario guardado en SharedPreferences');

      print('🔑 [AuthProvider] Llamando a notifyListeners()...');
      print(
          '🔑 [AuthProvider] Número de listeners: ${hasListeners ? "Tiene listeners" : "NO tiene listeners"}');
      notifyListeners();
      print('🔑 [AuthProvider] ✅ notifyListeners() ejecutado');
      print('🔑 [AuthProvider] ✅ Login biométrico exitoso, retornando true');
      return true;
    } catch (e) {
      print('🔑 [AuthProvider] ❌ ERROR en loginWithBiometric: $e');
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement Hive local registration
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final nameParts = name.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      _user = UserModel(
        id: now.millisecondsSinceEpoch.toString(),
        email: email,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        createdAt: now,
        updatedAt: now,
      );
      _status = AuthStatus.authenticated;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(_user!.toJson()));

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    print('🚪 [AuthProvider] logout iniciado');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');

    _user = null;
    _status = AuthStatus.unauthenticated;
    print('🚪 [AuthProvider] Status cambiado a: $_status');
    print('🚪 [AuthProvider] Llamando a notifyListeners()...');
    print(
        '🚪 [AuthProvider] Número de listeners: ${hasListeners ? "Tiene listeners" : "NO tiene listeners"}');
    notifyListeners();
    print('🚪 [AuthProvider] ✅ Logout completado');
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
