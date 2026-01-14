import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

enum MenuFilter { star, hot, loved, all }

enum SortBy { rating, priceAsc, priceDesc, name }

class MenuProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  final Set<String> _lovedProductIds = {};
  MenuFilter _currentFilter = MenuFilter.all;
  String? _selectedCategoryId;
  SortBy _sortBy = SortBy.rating;
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  MenuFilter get currentFilter => _currentFilter;
  String? get selectedCategoryId => _selectedCategoryId;
  SortBy get sortBy => _sortBy;
  bool get isLoading => _isLoading;

  List<ProductModel> get filteredProducts {
    List<ProductModel> result;

    switch (_currentFilter) {
      case MenuFilter.star:
        result = _products.where((p) => p.isStar).toList();
        break;
      case MenuFilter.hot:
        result = _products.toList()
          ..sort((a, b) => b.orderCount.compareTo(a.orderCount));
        result = result.take(10).toList();
        break;
      case MenuFilter.loved:
        result =
            _products.where((p) => _lovedProductIds.contains(p.id)).toList();
        break;
      case MenuFilter.all:
        if (_selectedCategoryId != null) {
          result = _products
              .where((p) => p.categoryId == _selectedCategoryId)
              .toList();
        } else {
          result = _products.toList();
        }
        break;
    }

    switch (_sortBy) {
      case SortBy.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortBy.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortBy.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortBy.name:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return result;
  }

  Future<void> loadMenu() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load from Hive
      await Future.delayed(const Duration(milliseconds: 500));
      _categories = [];
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(MenuFilter filter) {
    _currentFilter = filter;
    _selectedCategoryId = null;
    notifyListeners();
  }

  void setCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    _currentFilter = MenuFilter.all;
    notifyListeners();
  }

  void setSortBy(SortBy sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void toggleLoved(String productId) {
    if (_lovedProductIds.contains(productId)) {
      _lovedProductIds.remove(productId);
    } else {
      _lovedProductIds.add(productId);
    }
    // TODO: Persist to Hive
    notifyListeners();
  }

  bool isLoved(String productId) => _lovedProductIds.contains(productId);
}
