import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../config/app_config.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  int _tableNumber = 0;

  final double _tip = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => AppConfig.hasTax ? subtotal * AppConfig.taxRate : 0.0;

  double get total => subtotal + tax + _tip;

  bool get isEmpty => _items.isEmpty;

  int get tableNumber => _tableNumber;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _tableNumber = prefs.getInt('table_number') ?? 0;
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('table_number', _tableNumber);
    await prefs.setInt('cart_item_count', _items.length);
  }

  void setTableNumber(int tableNumber) {
    _tableNumber = tableNumber;
    _saveCart();
    notifyListeners();
  }

  void addItem({
    required Product product,
    required int quantity,
    required Map<String, dynamic> customizations,
    required double totalPrice,
    String? specialInstructions,
  }) {
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        _areCustomizationsEqual(item.customizations, customizations) &&
        item.specialInstructions == specialInstructions);

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
        totalPrice: _items[existingIndex].totalPrice + totalPrice,
      );
    } else {
      final cartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: quantity,
        customizations: customizations,
        totalPrice: totalPrice,
        specialInstructions: specialInstructions,
      );
      _items.add(cartItem);
    }

    _saveCart();
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final item = _items[index];
      final pricePerUnit = item.totalPrice / item.quantity;
      _items[index] = item.copyWith(
        quantity: newQuantity,
        totalPrice: pricePerUnit * newQuantity,
      );
      _saveCart();
      notifyListeners();
    }
  }

  void updateItemCustomizations({
    required String itemId,
    required Map<String, dynamic> customizations,
    required double totalPrice,
    String? specialInstructions,
  }) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final item = _items[index];
      _items[index] = item.copyWith(
        customizations: customizations,
        totalPrice: totalPrice,
        specialInstructions: specialInstructions,
      );
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool _areCustomizationsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;

    for (var key in a.keys) {
      if (!b.containsKey(key)) return false;

      final valueA = a[key];
      final valueB = b[key];

      if (valueA is List && valueB is List) {
        if (valueA.length != valueB.length) return false;
        for (var i = 0; i < valueA.length; i++) {
          if (valueA[i] != valueB[i]) return false;
        }
      } else if (valueA is Map && valueB is Map) {
        if (!_areCustomizationsEqual(Map<String, dynamic>.from(valueA),
            Map<String, dynamic>.from(valueB))) {
          return false;
        }
      } else if (valueA != valueB) {
        return false;
      }
    }

    return true;
  }
}
