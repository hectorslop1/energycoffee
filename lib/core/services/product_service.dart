import '../models/product.dart';

abstract class ProductService {
  Future<List<Product>> getProducts();
  Future<Product?> getProductById(String id);
  Future<List<Product>> getProductsByCategory(String categoryId);
  Future<List<Product>> searchProducts(String query);
}

class MockProductService implements ProductService {
  final List<Product> _products;

  MockProductService(this._products);

  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products;
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products.where((p) => p.categoryIds.contains(categoryId)).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.description.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

// Preparado para Supabase - descomentar cuando esté listo
/*
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProductService implements ProductService {
  final SupabaseClient _client;

  SupabaseProductService(this._client);

  @override
  Future<List<Product>> getProducts() async {
    final response = await _client
        .from('products')
        .select()
        .eq('is_active', true)
        .order('name');
    
    return (response as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    final response = await _client
        .from('products')
        .select()
        .eq('id', id)
        .single();
    
    return Product.fromJson(response);
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final response = await _client
        .from('products')
        .select()
        .contains('category_ids', [categoryId])
        .eq('is_active', true);
    
    return (response as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final response = await _client
        .from('products')
        .select()
        .or('name.ilike.%$query%,description.ilike.%$query%')
        .eq('is_active', true);
    
    return (response as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
}
*/
