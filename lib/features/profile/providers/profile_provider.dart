import 'package:flutter/foundation.dart';
import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  List<PaymentMethodModel> _paymentMethods = [];
  List<OrderHistoryItem> _orderHistory = [];
  bool _isLoading = false;

  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  List<OrderHistoryItem> get orderHistory => _orderHistory;
  bool get isLoading => _isLoading;

  Future<void> loadPaymentMethods() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load from Hive
      await Future.delayed(const Duration(milliseconds: 300));
      _paymentMethods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrderHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load from Hive
      await Future.delayed(const Duration(milliseconds: 300));
      _orderHistory = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPaymentMethod(PaymentMethodModel method) async {
    try {
      // TODO: Save to Hive
      _paymentMethods.add(method);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removePaymentMethod(String methodId) async {
    try {
      // TODO: Remove from Hive
      _paymentMethods.removeWhere((m) => m.id == methodId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setDefaultPaymentMethod(String methodId) async {
    try {
      // TODO: Update in Hive
      _paymentMethods = _paymentMethods.map((m) {
        return PaymentMethodModel(
          id: m.id,
          type: m.type,
          cardLastFour: m.cardLastFour,
          cardBrand: m.cardBrand,
          paypalEmail: m.paypalEmail,
          isDefault: m.id == methodId,
        );
      }).toList();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
