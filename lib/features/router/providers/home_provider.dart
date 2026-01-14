import 'package:flutter/foundation.dart';
import '../models/home_model.dart';

class HomeProvider extends ChangeNotifier {
  List<Promotion> _promotions = [];
  bool _isLoading = false;

  List<Promotion> get promotions => _promotions;
  bool get isLoading => _isLoading;

  Future<void> loadPromotions() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load from Hive
      await Future.delayed(const Duration(milliseconds: 500));
      _promotions = [
        const Promotion(
          id: '1',
          title: 'Café del día',
          description: '20% de descuento en tu primer café',
          imageUrl: '',
          discountPercent: 20,
        ),
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
