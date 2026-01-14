import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  int get count => _favoriteIds.length;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_products') ?? [];
    _favoriteIds.addAll(favorites);
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_products', _favoriteIds.toList());
    notifyListeners();
  }

  Future<void> addFavorite(String productId) async {
    if (!_favoriteIds.contains(productId)) {
      _favoriteIds.add(productId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_products', _favoriteIds.toList());
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_products', _favoriteIds.toList());
      notifyListeners();
    }
  }

  List<Product> getFavoriteProducts(List<Product> allProducts) {
    return allProducts
        .where((product) => _favoriteIds.contains(product.id))
        .toList();
  }

  Future<void> clear() async {
    _favoriteIds.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorite_products');
    notifyListeners();
  }
}
