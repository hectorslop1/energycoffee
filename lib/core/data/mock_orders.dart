import '../../features/order/models/order_model.dart';

class MockOrders {
  static final List<OrderModel> orders = [
    OrderModel(
      id: 'ORD-001',
      userId: 'user-demo',
      establishmentId: 'est-001',
      tableId: 'table-005',
      tableNumber: 5,
      items: [],
      subtotal: 45.50,
      tax: 4.55,
      tip: 6.83,
      total: 56.88,
      paymentMethod: 'card',
      status: OrderStatus.completed,
      isPaid: true,
      specialInstructions: null,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    OrderModel(
      id: 'ORD-002',
      userId: 'user-demo',
      establishmentId: 'est-001',
      tableId: 'table-003',
      tableNumber: 3,
      items: [],
      subtotal: 28.00,
      tax: 2.80,
      tip: 4.20,
      total: 35.00,
      paymentMethod: 'cash',
      status: OrderStatus.completed,
      isPaid: true,
      specialInstructions: 'Sin azúcar',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      completedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    OrderModel(
      id: 'ORD-003',
      userId: 'user-demo',
      establishmentId: 'est-001',
      tableId: 'table-008',
      tableNumber: 8,
      items: [],
      subtotal: 62.75,
      tax: 6.28,
      tip: 9.41,
      total: 78.44,
      paymentMethod: 'card',
      status: OrderStatus.completed,
      isPaid: true,
      specialInstructions: null,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      completedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    OrderModel(
      id: 'ORD-004',
      userId: 'user-demo',
      establishmentId: 'est-001',
      tableId: 'table-012',
      tableNumber: 12,
      items: [],
      subtotal: 18.50,
      tax: 1.85,
      tip: 2.78,
      total: 23.13,
      paymentMethod: 'terminal',
      status: OrderStatus.completed,
      isPaid: true,
      specialInstructions: 'Para llevar',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      completedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    OrderModel(
      id: 'ORD-005',
      userId: 'user-demo',
      establishmentId: 'est-001',
      tableId: 'table-007',
      tableNumber: 7,
      items: [],
      subtotal: 52.25,
      tax: 5.23,
      tip: 7.84,
      total: 65.32,
      paymentMethod: 'card',
      status: OrderStatus.completed,
      isPaid: true,
      specialInstructions: null,
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      updatedAt: DateTime.now().subtract(const Duration(days: 14)),
      completedAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  static List<OrderModel> getRecentOrders({int limit = 10}) {
    return orders.take(limit).toList();
  }

  static OrderModel? getOrderById(String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}
