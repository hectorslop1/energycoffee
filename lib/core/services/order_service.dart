import '../../features/order/models/order_model.dart';

abstract class OrderService {
  Future<String> createOrder(OrderModel order);
  Future<OrderModel?> getOrderById(String id);
  Future<List<OrderModel>> getOrdersByUser(String userId);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
}

class MockOrderService implements OrderService {
  final Map<String, OrderModel> _orders = {};

  @override
  Future<String> createOrder(OrderModel order) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _orders[order.id] = order;
    return order.id;
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _orders[id];
  }

  @override
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders.values.where((order) => order.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final order = _orders[orderId];
    if (order != null) {
      _orders[orderId] = order.copyWith(status: status);
    }
  }
}

// Preparado para Supabase
/*
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseOrderService implements OrderService {
  final SupabaseClient _client;

  SupabaseOrderService(this._client);

  @override
  Future<String> createOrder(OrderModel order) async {
    final response = await _client
        .from('orders')
        .insert(order.toJson())
        .select()
        .single();
    
    return response['id'] as String;
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    final response = await _client
        .from('orders')
        .select()
        .eq('id', id)
        .single();
    
    return OrderModel.fromJson(response);
  }

  @override
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    final response = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _client
        .from('orders')
        .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', orderId);
  }
}
*/
