import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback? onLoginSuccess;

  const LoginPage({super.key, this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Degradado de fondo
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        const Color(
                            0xFF0A0806), // Casi negro en la parte superior
                        AppColors.darkBackgroundPrimary,
                        AppColors.darkBackgroundSecondary,
                        AppColors.darkBackgroundCard,
                      ]
                    : [
                        AppColors.lightBackgroundPrimary,
                        const Color(0xFFE8E0C8),
                        AppColors.lightBackgroundCard,
                      ],
                stops: isDark ? [0.0, 0.3, 0.6, 1.0] : null,
              ),
            ),
          ),
          // Imagen de granos de café en la parte inferior (fija en el fondo)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/coffeebeansbottom.png',
                fit: BoxFit.cover,
                height: 220,
                opacity: const AlwaysStoppedAnimation(0.85),
              ),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 4),
                          const LoginHeader(),
                          const SizedBox(height: 24),
                          LoginForm(onLoginSuccess: onLoginSuccess),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
