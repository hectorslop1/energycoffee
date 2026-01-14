import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderModel? _currentOrder;
  final List<OrderItem> _cart = [];
  bool _isLoading = false;
  String? _error;

  OrderModel? get currentOrder => _currentOrder;
  List<OrderItem> get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveOrder => _currentOrder != null && !_currentOrder!.isPaid;

  double get cartSubtotal =>
      _cart.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addToCart(OrderItem item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _cart.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateCartItem(String itemId, OrderItem updatedItem) {
    final index = _cart.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _cart[index] = updatedItem;
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<bool> createOrder({
    required String tableId,
    required int tableNumber,
    required double tip,
    required String paymentMethod,
  }) async {
    if (_cart.isEmpty) {
      _error = 'El carrito está vacío';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Save to Hive
      await Future.delayed(const Duration(seconds: 1));

      final subtotal = cartSubtotal;
      final total = subtotal + tip;
      final now = DateTime.now();

      _currentOrder = OrderModel(
        id: now.millisecondsSinceEpoch.toString(),
        userId: 'temp-user-id', // TODO: Obtener del auth provider
        establishmentId:
            'temp-establishment-id', // TODO: Configurar establecimiento
        tableId: tableId,
        tableNumber: tableNumber,
        items: List.from(_cart),
        createdAt: now,
        updatedAt: now,
        estimatedReadyAt: now.add(const Duration(minutes: 15)),
        subtotal: subtotal,
        tax: 0.0, // TODO: Calcular impuestos si aplica
        tip: tip,
        total: total,
        paymentMethod: paymentMethod,
        isPaid: true,
      );

      _cart.clear();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> modifyOrderItem(String itemId, OrderItem updatedItem) async {
    if (_currentOrder == null) return false;

    final itemIndex = _currentOrder!.items.indexWhere((i) => i.id == itemId);
    if (itemIndex == -1) return false;

    final item = _currentOrder!.items[itemIndex];
    if (!item.canModify) {
      _error = 'Este producto ya está siendo preparado';
      notifyListeners();
      return false;
    }

    try {
      // TODO: Update in Hive
      final updatedItems = List<OrderItem>.from(_currentOrder!.items);
      updatedItems[itemIndex] = updatedItem;

      _currentOrder = _currentOrder!.copyWith(items: updatedItems);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearOrder() {
    _currentOrder = null;
    _error = null;
    notifyListeners();
  }
}
