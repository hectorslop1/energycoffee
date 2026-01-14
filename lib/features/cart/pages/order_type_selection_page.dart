import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';
import '../../table/pages/assign_table/assign_table_page.dart';
import '../../checkout/pages/checkout_page.dart';

class OrderTypeSelectionPage extends StatelessWidget {
  const OrderTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.getTextPrimary(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '¿Dónde consumirás?',
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(
                'Selecciona cómo disfrutarás tu pedido',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.getTextSecondary(context),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _OrderTypeCard(
                icon: Icons.restaurant_rounded,
                title: 'Comer Aquí',
                description: 'Disfruta en nuestro local',
                gradient: isDark
                    ? AppColors.darkCardGradient
                    : AppColors.lightCardGradient,
                isDark: isDark,
                onTap: () => _handleDineIn(context),
              ),
              const SizedBox(height: 16),
              _OrderTypeCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Para Llevar',
                description: 'Recoge tu pedido y disfrútalo donde quieras',
                gradient: isDark
                    ? AppColors.darkCardGradient
                    : AppColors.lightCardGradient,
                isDark: isDark,
                onTap: () => _handleTakeout(context),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDineIn(BuildContext context) {
    // Navigate to table assignment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssignTablePage(),
      ),
    ).then((tableNumber) {
      if (tableNumber != null && context.mounted) {
        // Table was assigned, save it and go to checkout
        context.read<CartProvider>().setTableNumber(tableNumber);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CheckoutPage(),
          ),
        );
      }
    });
  }

  void _handleTakeout(BuildContext context) {
    // Set table number to 0 for takeout
    context.read<CartProvider>().setTableNumber(0);

    // Go directly to checkout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutPage(),
      ),
    );
  }
}

class _OrderTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final bool isDark;
  final VoidCallback onTap;

  const _OrderTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              width: 1,
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
