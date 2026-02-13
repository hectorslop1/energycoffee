import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/providers/biometric_provider.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../providers/auth_provider.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginForm({super.key, this.onLoginSuccess});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    print('🗑️ [LoginForm] dispose() llamado - LoginForm se está desmontando');
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Credenciales del usuario registrado por defecto
  static const String _defaultEmail = 'user@coffee.com';
  static const String _defaultPassword = 'default';

  Future<void> _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Validar credenciales
      if (email == _defaultEmail && password == _defaultPassword) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.login(
          emailOrPhone: email,
          password: password,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (success) {
            widget.onLoginSuccess?.call();
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).invalidCredentials),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _onBiometricLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔐 [BiometricLogin] Iniciando autenticación biométrica...');
      final biometricProvider =
          Provider.of<BiometricProvider>(context, listen: false);
      final authenticated = await biometricProvider.authenticate(
        reason: AppLocalizations.of(context).biometricLogin,
      );

      print(
          '🔐 [BiometricLogin] Autenticación biométrica resultado: $authenticated');

      if (authenticated) {
        print('🔐 [BiometricLogin] Llamando a loginWithBiometric()...');
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.loginWithBiometric();

        print('🔐 [BiometricLogin] Login resultado: $success');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (success) {
            print('🔐 [BiometricLogin] ✅ Login exitoso');
            // No hacer nada aquí, el listener del _AppNavigator manejará la navegación
          } else {
            print('🔐 [BiometricLogin] ❌ Login falló, success = false');
          }
        }
      } else {
        print('🔐 [BiometricLogin] ❌ Autenticación biométrica falló');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).biometricAuthFailed),
              backgroundColor: AppColors.secondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('🔐 [BiometricLogin] ❌ ERROR: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _onRegister() {
    // TODO: Navigate to register
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final spacing = isSmallScreen ? 10.0 : 12.0;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontSize: 14,
              color:
                  isDark ? AppColors.darkTextPrimary : const Color(0xFF2C1810),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark
                  ? AppColors.darkBackgroundCard
                  : const Color(0xFFFFFFFF).withValues(alpha: 0.5),
              hintText: AppStrings.email,
              hintStyle: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xFF8B7355).withValues(alpha: 0.8),
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                size: 20,
                color: isDark ? AppColors.primary : const Color(0xFF8B7355),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).pleaseEnterEmail;
              }
              if (!value.contains('@')) {
                return AppLocalizations.of(context).enterValidEmail;
              }
              return null;
            },
          ),
          SizedBox(height: spacing),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(
              fontSize: 14,
              color:
                  isDark ? AppColors.darkTextPrimary : const Color(0xFF2C1810),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark
                  ? AppColors.darkBackgroundCard
                  : const Color(0xFFFFFFFF).withValues(alpha: 0.5),
              hintText: AppStrings.password,
              hintStyle: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xFF8B7355).withValues(alpha: 0.8),
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                size: 20,
                color: isDark ? AppColors.primary : const Color(0xFF8B7355),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: isDark ? AppColors.primary : const Color(0xFF8B7355),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).pleaseEnterPassword;
              }
              if (value.length < 6) {
                return AppLocalizations.of(context).passwordMinLength;
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          ElevatedButton(
            onPressed: _onLogin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(AppStrings.login,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: spacing),
          Consumer<BiometricProvider>(
            builder: (context, biometricProvider, child) {
              if (biometricProvider.isBiometricAvailable &&
                  biometricProvider.isBiometricEnabled) {
                final l10n = AppLocalizations.of(context);
                final isIOS = biometricProvider.isIOS();
                final buttonText =
                    isIOS ? l10n.loginWithFaceID : l10n.loginWithFingerprint;
                final buttonIcon =
                    isIOS ? Icons.face_rounded : Icons.fingerprint;

                return OutlinedButton.icon(
                  onPressed: _isLoading ? null : _onBiometricLogin,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        )
                      : Icon(buttonIcon, size: 22),
                  label: Text(
                    _isLoading ? l10n.authenticating : buttonText,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).dontHaveAccount,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 13),
              ),
              TextButton(
                onPressed: _onRegister,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  AppStrings.register,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              AppStrings.forgotPassword,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
