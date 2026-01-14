import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isSmallScreen ? 55 : 65),
          child: Image.asset(
            'assets/images/LogoCoffee.png',
            width: isSmallScreen ? 207 : 253,
            height: isSmallScreen ? 207 : 253,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          AppStrings.login,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.15),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
