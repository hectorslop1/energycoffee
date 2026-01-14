import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:energy_coffee/core/constants/app_colors.dart';
import 'package:energy_coffee/core/l10n/app_localizations.dart';
import 'package:energy_coffee/features/order/models/order_model.dart';
import 'package:energy_coffee/features/router/pages/router/router_page.dart';
import 'package:energy_coffee/core/providers/cart_provider.dart';

class CompletedOrderPage extends StatelessWidget {
  final OrderModel order;

  const CompletedOrderPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildSuccessIcon(),
                    const SizedBox(height: 24),
                    _buildTitle(context),
                    const SizedBox(height: 12),
                    _buildSubtitle(context),
                    const SizedBox(height: 40),
                    _buildOrderInfo(context),
                    const SizedBox(height: 24),
                    _buildOrderSummary(context),
                    const SizedBox(height: 24),
                    _buildRatingSection(context),
                  ],
                ),
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 60,
        color: AppColors.textAltPrimary,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context).orderCompletedLabel,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimary(context),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context).orderDeliveredSuccessfully,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.getTextSecondary(context),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: Icons.receipt_long_rounded,
            label: AppLocalizations.of(context).orderNumberLabel,
            value: order.id,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.table_restaurant_rounded,
            label: AppLocalizations.of(context).table,
            value: '${AppLocalizations.of(context).table} ${order.tableNumber}',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.access_time_rounded,
            label: AppLocalizations.of(context).orderTimeLabel,
            value: _formatTime(order.createdAt),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.payment_rounded,
            label: AppLocalizations.of(context).paymentMethodLabel,
            value: order.paymentMethod ?? 'No especificado',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.textAltPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).orderSummary,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.quantity}x',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.productName,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                  ],
                ),
              )),
          const Divider(height: 24),
          _buildSummaryRow(
              context, AppLocalizations.of(context).subtotal, order.subtotal),
          if (order.tip > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
                context, AppLocalizations.of(context).tipLabel, order.tip),
          ],
          if (order.roundingAmount != null &&
              order.roundingAmount!.abs() > 0.01) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
                context,
                AppLocalizations.of(context).roundingLabel,
                order.roundingAmount!),
          ],
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).total,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.getTextSecondary(context),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).howWasYourExperience,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.star_rounded,
                  size: 40,
                  color: AppColors.secondary.withValues(alpha: 0.3),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).tapStarsToRate,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Resetear el número de mesa
                final cart = Provider.of<CartProvider>(context, listen: false);
                cart.setTableNumber(0);

                // Navegar a RouterPage con el tab de "Mesa" activo (índice 1)
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const RouterPage(initialIndex: 1),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textAltPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context).makeAnotherOrder,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // Resetear el número de mesa
              final cart = Provider.of<CartProvider>(context, listen: false);
              cart.setTableNumber(0);

              // Navegar a RouterPage (Home)
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const RouterPage()),
                (route) => false,
              );
            },
            child: Text(
              AppLocalizations.of(context).backToHome,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getTextSecondary(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
