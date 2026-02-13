import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/config/app_config.dart';
import '../../../core/widgets/checkout_progress.dart';
import '../../order/models/order_model.dart';
import '../../order/pages/active_order/active_order_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'cash';
  String _tipMode = 'percent';
  double _tipPercentage = 0.15;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _tipAmountController = TextEditingController();
  final TextEditingController _cashAmountController = TextEditingController();
  String? _selectedCard;
  String? _cashAmountError;
  final Map<String, bool> _expandedItems = {};

  @override
  void dispose() {
    _notesController.dispose();
    _tipAmountController.dispose();
    _cashAmountController.dispose();
    super.dispose();
  }

  double _calculateTipAmount(CartProvider cart) {
    if (_tipMode == 'none') return 0.0;
    if (_tipMode == 'amount') {
      return double.tryParse(_tipAmountController.text) ?? 0.0;
    }
    return cart.subtotal * _tipPercentage;
  }

  double _calculateTotal(CartProvider cart) {
    final tipAmount = _calculateTipAmount(cart);
    final total = cart.subtotal + cart.tax + tipAmount;

    // Si el método de pago es efectivo, redondear a número entero
    if (_paymentMethod == 'cash') {
      return total.roundToDouble();
    }

    return total;
  }

  void _validateCashAmount(String value, double total) {
    setState(() {
      if (value.isEmpty) {
        _cashAmountError = null;
        return;
      }

      final cashAmount = double.tryParse(value);
      if (cashAmount == null) {
        _cashAmountError = 'Ingresa un monto válido';
        return;
      }

      if (cashAmount <= 0) {
        _cashAmountError = 'El monto debe ser mayor a 0';
        return;
      }

      if (cashAmount < total) {
        _cashAmountError = 'El monto es insuficiente';
        return;
      }

      _cashAmountError = null;
    });
  }

  bool _canConfirmOrder(double total) {
    if (_paymentMethod == 'cash') {
      if (_cashAmountController.text.isEmpty) {
        return false;
      }
      final cashAmount = double.tryParse(_cashAmountController.text);
      if (cashAmount == null || cashAmount <= 0 || cashAmount < total) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundPrimary(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.getTextPrimary(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirmar Pedido',
                  style: TextStyle(
                    color: AppColors.getTextPrimary(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (cart.tableNumber > 0)
                  Text(
                    'Mesa ${cart.tableNumber}',
                    style: TextStyle(
                      color: AppColors.getTextSecondary(context),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppColors.secondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textAltPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Volver al Menú'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Progress Bar
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: CheckoutProgressBar(
                  currentStep: 1,
                  steps: ['Carrito', 'Pago', 'Confirmar'],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderSummary(cart),
                      const SizedBox(height: 24),
                      _buildTipSection(cart),
                      const SizedBox(height: 24),
                      _buildPaymentMethod(),
                      const SizedBox(height: 24),
                      _buildNotesSection(),
                      const SizedBox(height: 24),
                      _buildPriceSummary(cart),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                'Resumen del Pedido',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...cart.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${item.quantity}x',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textAltPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                        if (item.getCustomizationSummary().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          _buildExpandableCustomization(
                              item.id, item.getCustomizationSummary()),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          Divider(
              height: 24,
              color:
                  AppColors.getTextSecondary(context).withValues(alpha: 0.2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${cart.itemCount} ${cart.itemCount == 1 ? "producto" : "productos"}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              Text(
                '\$${cart.subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCustomization(
      String itemId, String customizationSummary) {
    final isExpanded = _expandedItems[itemId] ?? false;

    final textPainter = TextPainter(
      text: TextSpan(
        text: customizationSummary,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary.withValues(alpha: 0.8),
          height: 1.4,
        ),
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 160);

    final isTextOverflowing = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          customizationSummary,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            height: 1.4,
          ),
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (isTextOverflowing) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedItems[itemId] = !isExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  isExpanded ? 'Ver menos' : 'Ver más',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTipSection(CartProvider cart) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.volunteer_activism_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                'Propina',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTipModeButton('amount', 'Monto'),
              const SizedBox(width: 8),
              _buildTipModeButton('percent', 'Porcentaje'),
              const SizedBox(width: 8),
              _buildTipModeButton('none', 'Sin Propina'),
            ],
          ),
          if (_tipMode == 'amount') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _tipAmountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                //FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                prefixText: '\$',
                hintText: '0.00',
                filled: true,
                fillColor: AppColors.getBackgroundPrimary(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 16),
              onChanged: (value) => setState(() {}),
            ),
          ],
          if (_tipMode == 'percent') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTipPercentButton(0.05, '5%'),
                const SizedBox(width: 8),
                _buildTipPercentButton(0.10, '10%'),
                const SizedBox(width: 8),
                _buildTipPercentButton(0.15, '15%'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipModeButton(String mode, String label) {
    final isSelected = _tipMode == mode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _tipMode = mode;
          if (mode == 'none') {
            _tipPercentage = 0.0;
            _tipAmountController.clear();
          } else if (mode == 'percent' && _tipPercentage == 0.0) {
            _tipPercentage = 0.15;
          }
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected
                ? null
                : isDark
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.lightBackgroundSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : isDark
                      ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                      : AppColors.lightTextSecondary.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? AppColors.textAltPrimary
                  : AppColors.getTextPrimary(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipPercentButton(double percentage, String label) {
    final isSelected = _tipPercentage == percentage;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tipPercentage = percentage),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected
                ? null
                : isDark
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.lightBackgroundSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : isDark
                      ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                      : AppColors.lightTextSecondary.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? AppColors.textAltPrimary
                  : AppColors.getTextPrimary(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payment_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                'Método de Pago',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCashPaymentOption(),
          const SizedBox(height: 12),
          _buildCardPaymentOption(),
        ],
      ),
    );
  }

  Widget _buildCashPaymentOption() {
    final isSelected = _paymentMethod == 'cash';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = 'cash'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackgroundSecondary
              : AppColors.lightBackgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isDark
                    ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.money_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Efectivo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.secondary.withValues(alpha: 0.3),
                  size: 24,
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              Text(
                '¿Cuánto efectivo entregarás?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              const SizedBox(height: 8),
              Consumer<CartProvider>(
                builder: (context, cart, child) {
                  final total = _calculateTotal(cart);
                  return TextField(
                    controller: _cashAmountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      prefixText: '\$',
                      prefixStyle: TextStyle(
                        color: AppColors.getTextPrimary(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        color: AppColors.getTextSecondary(context)
                            .withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkBackgroundPrimary
                          : AppColors.lightBackgroundPrimary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _cashAmountError != null
                              ? AppColors.error
                              : isDark
                                  ? AppColors.darkTextSecondary
                                      .withValues(alpha: 0.3)
                                  : AppColors.lightTextSecondary
                                      .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _cashAmountError != null
                              ? AppColors.error
                              : AppColors.primary,
                          width: 2,
                        ),
                      ),
                      errorText: _cashAmountError,
                      errorStyle: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: TextStyle(
                        color: AppColors.getTextPrimary(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    onChanged: (value) => _validateCashAmount(value, total),
                  );
                },
              ),
              if (_cashAmountController.text.isNotEmpty) ...[
                const SizedBox(height: 12),
                Consumer<CartProvider>(builder: (context, cart, child) {
                  final cashAmount =
                      double.tryParse(_cashAmountController.text) ?? 0;
                  final total = _calculateTotal(cart);
                  final change = cashAmount - total;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (change >= 0 ? AppColors.success : AppColors.error)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            change >= 0 ? AppColors.success : AppColors.error,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tu cambio será:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                        Text(
                          change >= 0
                              ? '\$${change.toStringAsFixed(2)}'
                              : '-\$${(-change).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: change >= 0
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardPaymentOption() {
    final isSelected = _paymentMethod == 'card';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final savedCards = [
      {'last4': '1234', 'brand': 'Visa'},
      {'last4': '5678', 'brand': 'Mastercard'},
    ];

    return GestureDetector(
      onTap: () => setState(() {
        _paymentMethod = 'card';
        if (_selectedCard == null && savedCards.isNotEmpty) {
          _selectedCard = savedCards[0]['last4'];
        }
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackgroundSecondary
              : AppColors.lightBackgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isDark
                    ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.credit_card_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tarjeta (App)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.secondary.withValues(alpha: 0.3),
                  size: 24,
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              ...savedCards.map((card) {
                final cardLast4 = card['last4']!;
                final isCardSelected = _selectedCard == cardLast4;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCard = cardLast4),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCardSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : isDark
                              ? AppColors.darkBackgroundPrimary
                              : AppColors.lightBackgroundPrimary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCardSelected
                            ? AppColors.primary
                            : isDark
                                ? AppColors.darkTextSecondary
                                    .withValues(alpha: 0.3)
                                : AppColors.lightTextSecondary
                                    .withValues(alpha: 0.3),
                        width: isCardSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: isCardSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${card['brand']} terminada en $cardLast4',
                            style: TextStyle(
                              fontSize: 14,
                              color: isCardSelected
                                  ? AppColors.primary
                                  : AppColors.getTextPrimary(context),
                              fontWeight: isCardSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isCardSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Funcionalidad de agregar tarjeta próximamente'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBackgroundPrimary
                        : AppColors.lightBackgroundPrimary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Agregar nueva tarjeta',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.note_alt_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                'Notas del Pedido',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Instrucciones adicionales para tu pedido...',
              hintStyle: TextStyle(
                  color: AppColors.getTextSecondary(context)
                      .withValues(alpha: 0.5)),
              filled: true,
              fillColor: AppColors.getBackgroundPrimary(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            style: TextStyle(
                color: AppColors.getTextPrimary(context), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(CartProvider cart) {
    final tipAmount = _calculateTipAmount(cart);
    final totalBeforeRounding = cart.subtotal + cart.tax + tipAmount;
    final total = _calculateTotal(cart);
    final roundingAmount = total - totalBeforeRounding;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal', cart.subtotal, false),
          if (AppConfig.hasTax) ...[
            const SizedBox(height: 8),
            _buildPriceRow(AppConfig.taxLabel, cart.tax, false),
          ],
          if (tipAmount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              _tipMode == 'percent'
                  ? 'Propina (${(_tipPercentage * 100).toStringAsFixed(0)}%)'
                  : 'Propina',
              tipAmount,
              false,
            ),
          ],
          if (_paymentMethod == 'cash' && roundingAmount != 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Redondeo',
              roundingAmount,
              false,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
                color: AppColors.textAltPrimary, height: 1, thickness: 1),
          ),
          _buildPriceRow('Total', total, true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: AppColors.textAltPrimary,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 22 : 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textAltPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, CartProvider cart) {
    final total = _calculateTotal(cart);
    final canConfirm = _canConfirmOrder(total);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                canConfirm ? () => _confirmOrder(context, cart, total) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canConfirm
                  ? AppColors.primary
                  : AppColors.secondary.withValues(alpha: 0.3),
              foregroundColor: AppColors.textAltPrimary,
              disabledBackgroundColor:
                  AppColors.secondary.withValues(alpha: 0.3),
              disabledForegroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: canConfirm ? 4 : 0,
              shadowColor: AppColors.primary.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_rounded, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Confirmar Pedido - \$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmOrder(BuildContext context, CartProvider cart, double total) {
    // Calcular redondeo si aplica
    final tipAmount = _calculateTipAmount(cart);
    final subtotalWithTip = cart.subtotal + cart.tax + tipAmount;
    final roundingAmount =
        _paymentMethod == 'cash' ? total - subtotalWithTip : 0.0;

    // Crear orden con los datos del carrito
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    final order = OrderModel(
      id: orderId,
      userId: 'temp-user-id', // TODO: Obtener del auth provider
      establishmentId:
          'temp-establishment-id', // TODO: Configurar establecimiento
      tableId: 'TBL-001',
      tableNumber: cart.tableNumber,
      items: cart.items
          .map((cartItem) => OrderItem(
                id: 'ITEM-${now.millisecondsSinceEpoch}-${cart.items.indexOf(cartItem)}',
                orderId: orderId,
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                productImageUrl: cartItem.product.imageUrl,
                quantity: cartItem.quantity,
                customizations: cartItem.customizations,
                customizationSummary: cartItem.getCustomizationSummary(),
                notes: cartItem.specialInstructions,
                unitPrice: cartItem.product.price,
                totalPrice: cartItem.totalPrice,
                status: OrderItemStatus.pending,
                createdAt: now,
                updatedAt: now,
              ))
          .toList(),
      status: OrderStatus.pending,
      createdAt: now,
      updatedAt: now,
      estimatedReadyAt: now.add(const Duration(minutes: 15)),
      subtotal: cart.subtotal,
      tax: cart.tax,
      tip: tipAmount,
      total: total,
      roundingAmount: roundingAmount.abs() > 0.01 ? roundingAmount : null,
      paymentMethod: _getPaymentMethodName(),
      isPaid: true,
    );

    // Limpiar carrito
    cart.clear();

    // Navegar a la pantalla de pedido activo
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ActiveOrderPage(order: order),
      ),
      (route) => route.isFirst,
    );
  }

  String _getPaymentMethodName() {
    switch (_paymentMethod) {
      case 'cash':
        return 'Efectivo';
      case 'card':
        return 'Tarjeta (App)';
      case 'terminal':
        return 'Terminal';
      default:
        return 'Efectivo';
    }
  }
}
