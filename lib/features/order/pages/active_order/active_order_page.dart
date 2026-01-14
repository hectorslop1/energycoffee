import 'dart:async';
import 'package:flutter/material.dart';
import 'package:energy_coffee/core/constants/app_colors.dart';
import 'package:energy_coffee/features/order/models/order_model.dart';
import 'package:energy_coffee/features/order/pages/completed_order/completed_order_page.dart';

class ActiveOrderPage extends StatefulWidget {
  final OrderModel order;

  const ActiveOrderPage({super.key, required this.order});

  @override
  State<ActiveOrderPage> createState() => _ActiveOrderPageState();
}

class _ActiveOrderPageState extends State<ActiveOrderPage>
    with SingleTickerProviderStateMixin {
  late OrderModel _currentOrder;
  late AnimationController _pulseController;
  Timer? _simulationTimer;
  final Map<String, bool> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _startOrderSimulation();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _startOrderSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_currentOrder.status == OrderStatus.pending) {
          _currentOrder = _currentOrder.copyWith(status: OrderStatus.preparing);
        } else if (_currentOrder.status == OrderStatus.preparing) {
          final updatedItems = _currentOrder.items.map((item) {
            if (item.status == OrderItemStatus.pending) {
              return item.copyWith(status: OrderItemStatus.preparing);
            } else if (item.status == OrderItemStatus.preparing) {
              return item.copyWith(status: OrderItemStatus.ready);
            }
            return item;
          }).toList();

          _currentOrder = _currentOrder.copyWith(items: updatedItems);

          if (updatedItems
              .every((item) => item.status == OrderItemStatus.ready)) {
            _currentOrder = _currentOrder.copyWith(status: OrderStatus.ready);
            timer.cancel();

            // Navegar a pantalla de orden completada después de 2 segundos
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        CompletedOrderPage(order: _currentOrder),
                  ),
                );
              }
            });
          }
        } else if (_currentOrder.status == OrderStatus.ready) {
          timer.cancel();
        }
      });
    });
  }

  OrderModel _createMockOrder() {
    final now = DateTime.now();
    const orderId = 'ORD-001';

    return OrderModel(
      id: orderId,
      userId: 'temp-user-id',
      establishmentId: 'temp-establishment-id',
      tableId: 'TBL-001',
      tableNumber: 5,
      items: [
        OrderItem(
          id: 'ITEM-001',
          orderId: orderId,
          productId: 'PROD-001',
          productName: 'Cappuccino Grande',
          quantity: 2,
          customizationSummary:
              'Tamaño: Grande • Temperatura: Caliente • Leche de almendras',
          unitPrice: 45.0,
          totalPrice: 90.0,
          status: OrderItemStatus.pending,
          createdAt: now,
          updatedAt: now,
        ),
        OrderItem(
          id: 'ITEM-002',
          orderId: orderId,
          productId: 'PROD-002',
          productName: 'Croissant de Chocolate',
          quantity: 1,
          customizationSummary: 'Sin azúcar glass',
          unitPrice: 35.0,
          totalPrice: 35.0,
          status: OrderItemStatus.pending,
          createdAt: now,
          updatedAt: now,
        ),
        OrderItem(
          id: 'ITEM-003',
          orderId: orderId,
          productId: 'PROD-003',
          productName: 'Americano Frío',
          quantity: 1,
          customizationSummary: 'Tamaño: Grande • Con hielo • Extra shot',
          unitPrice: 40.0,
          totalPrice: 40.0,
          status: OrderItemStatus.pending,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      status: OrderStatus.pending,
      createdAt: now,
      updatedAt: now,
      estimatedReadyAt: now.add(const Duration(minutes: 15)),
      subtotal: 165.0,
      tax: 0.0,
      tip: 24.75,
      total: 189.75,
      paymentMethod: 'Tarjeta (App)',
      isPaid: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundPrimary(context),
        elevation: 0,
        /* leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.getTextPrimary(context)),
          onPressed: () => Navigator.pop(context),
        ), */
        title: Text(
          'Pedido Activo',
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const SizedBox(height: 24),
            _buildStatusTimeline(),
            const SizedBox(height: 24),
            _buildOrderItems(),
            const SizedBox(height: 24),
            _buildOrderSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Orden',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textAltPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.textAltPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mesa ${_currentOrder.tableNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textAltPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '#${_currentOrder.id}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textAltPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.textAltPrimary, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tiempo estimado',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textAltPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getEstimatedTime(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textAltPrimary,
                    ),
                  ),
                ],
              ),
              Icon(
                _getStatusIcon(),
                size: 40,
                color: AppColors.textAltPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundSecondary(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado del Pedido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 20),
          _buildTimelineStep(
            'Pedido Recibido',
            'Tu pedido ha sido confirmado',
            Icons.receipt_long_rounded,
            isCompleted: true,
            isActive: _currentOrder.status == OrderStatus.pending,
          ),
          _buildTimelineConnector(isCompleted: _currentOrder.status.index > 0),
          _buildTimelineStep(
            'En Preparación',
            'Estamos preparando tu pedido',
            Icons.restaurant_rounded,
            isCompleted: _currentOrder.status.index > 1,
            isActive: _currentOrder.status == OrderStatus.preparing,
          ),
          _buildTimelineConnector(isCompleted: _currentOrder.status.index > 2),
          _buildTimelineStep(
            'Listo para Servir',
            'Tu pedido está listo',
            Icons.check_circle_rounded,
            isCompleted: _currentOrder.status.index > 2,
            isActive: _currentOrder.status == OrderStatus.ready,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, IconData icon,
      {required bool isCompleted, required bool isActive}) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient:
                    isCompleted || isActive ? AppColors.primaryGradient : null,
                color: isCompleted || isActive
                    ? null
                    : AppColors.secondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(
                              alpha: 0.4 + (_pulseController.value * 0.3)),
                          blurRadius: 12 + (_pulseController.value * 8),
                          spreadRadius: _pulseController.value * 4,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: isCompleted || isActive
                    ? AppColors.textAltPrimary
                    : AppColors.textSecondary,
                size: 24,
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isCompleted || isActive
                      ? AppColors.getTextPrimary(context)
                      : AppColors.getTextSecondary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: isCompleted || isActive
                      ? AppColors.getTextSecondary(context)
                      : AppColors.getTextSecondary(context)
                          .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector({required bool isCompleted}) {
    return Padding(
      padding: const EdgeInsets.only(left: 23, top: 8, bottom: 8),
      child: Container(
        width: 2,
        height: 32,
        decoration: BoxDecoration(
          gradient: isCompleted ? AppColors.primaryGradient : null,
          color:
              isCompleted ? null : AppColors.secondary.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildOrderItems() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundSecondary(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Productos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          ..._currentOrder.items.map((item) => _buildOrderItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    final customizationSummary = item.customizationSummary ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundPrimary(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getItemStatusColor(item.status).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: item.status == OrderItemStatus.ready
                  ? AppColors.primaryGradient
                  : null,
              color: item.status == OrderItemStatus.ready
                  ? null
                  : _getItemStatusColor(item.status).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${item.quantity}x',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: item.status == OrderItemStatus.ready
                      ? AppColors.textAltPrimary
                      : _getItemStatusColor(item.status),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                if (customizationSummary.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _buildExpandableCustomization(item.id, customizationSummary),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _getItemStatusText(item.status),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getItemStatusColor(item.status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_getItemProgress(item.status)}%',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getItemStatusColor(item.status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _getItemProgress(item.status) / 100,
                              backgroundColor:
                                  AppColors.secondary.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getItemStatusColor(item.status),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      _getItemStatusIcon(item.status),
                      color: _getItemStatusColor(item.status),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
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
    )..layout(maxWidth: MediaQuery.of(context).size.width - 120);

    final isTextOverflowing = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          customizationSummary,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.getTextSecondary(context).withValues(alpha: 0.8),
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

  Widget _buildOrderSummary() {
    final totalBeforeRounding = _currentOrder.subtotal + _currentOrder.tip;
    final roundingAmount = _currentOrder.total - totalBeforeRounding;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundSecondary(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de Pago',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', _currentOrder.subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow('Propina', _currentOrder.tip),
          if (_currentOrder.paymentMethod == 'Efectivo' &&
              roundingAmount.abs() > 0.01) ...[
            const SizedBox(height: 8),
            _buildSummaryRow('Redondeo', roundingAmount),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _buildSummaryRow('Total', _currentOrder.total, isTotal: true),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                _currentOrder.isPaid ? Icons.check_circle : Icons.pending,
                size: 16,
                color: _currentOrder.isPaid
                    ? AppColors.success
                    : AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                _currentOrder.isPaid
                    ? 'Pagado con ${_currentOrder.paymentMethod}'
                    : 'Pendiente de pago',
                style: TextStyle(
                  fontSize: 13,
                  color: _currentOrder.isPaid
                      ? AppColors.success
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color:
                isTotal ? AppColors.primary : AppColors.getTextPrimary(context),
          ),
        ),
      ],
    );
  }

  String _getEstimatedTime() {
    if (_currentOrder.status == OrderStatus.ready) {
      return '¡Listo!';
    }
    if (_currentOrder.estimatedReadyAt == null) {
      return '15 min';
    }
    final remaining =
        _currentOrder.estimatedReadyAt!.difference(DateTime.now());
    if (remaining.inMinutes <= 0) {
      return '¡Pronto!';
    }
    return '${remaining.inMinutes} min';
  }

  IconData _getStatusIcon() {
    switch (_currentOrder.status) {
      case OrderStatus.pending:
        return Icons.schedule_rounded;
      case OrderStatus.preparing:
        return Icons.restaurant_rounded;
      case OrderStatus.ready:
        return Icons.check_circle_rounded;
      case OrderStatus.completed:
        return Icons.done_all_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  String _getItemStatusText(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.pending:
        return 'En espera';
      case OrderItemStatus.preparing:
        return 'Preparando...';
      case OrderItemStatus.ready:
        return '¡Listo!';
      case OrderItemStatus.delivered:
        return 'Entregado';
    }
  }

  IconData _getItemStatusIcon(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.pending:
        return Icons.schedule_rounded;
      case OrderItemStatus.preparing:
        return Icons.sync_rounded;
      case OrderItemStatus.ready:
        return Icons.check_circle_rounded;
      case OrderItemStatus.delivered:
        return Icons.done_all_rounded;
    }
  }

  Color _getItemStatusColor(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.pending:
        return AppColors.secondary;
      case OrderItemStatus.preparing:
        return Colors.orange;
      case OrderItemStatus.ready:
        return AppColors.success;
      case OrderItemStatus.delivered:
        return AppColors.primary;
    }
  }

  int _getItemProgress(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.pending:
        return 0;
      case OrderItemStatus.preparing:
        return 50;
      case OrderItemStatus.ready:
        return 100;
      case OrderItemStatus.delivered:
        return 100;
    }
  }
}
