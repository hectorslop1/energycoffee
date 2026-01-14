enum OrderStatus { pending, preparing, ready, completed, cancelled }

enum OrderItemStatus { pending, preparing, ready, delivered }

class OrderModel {
  final String id;
  final String userId;
  final String establishmentId;
  final String tableId;
  final int tableNumber;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? estimatedReadyAt;
  final double subtotal;
  final double tax;
  final double tip;
  final double total;
  final double? roundingAmount;
  final String? paymentMethod;
  final bool isPaid;
  final String? specialInstructions;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final int? rating;
  final String? review;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.establishmentId,
    required this.tableId,
    required this.tableNumber,
    required this.items,
    this.status = OrderStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedReadyAt,
    required this.subtotal,
    this.tax = 0.0,
    this.tip = 0.0,
    required this.total,
    this.roundingAmount,
    this.paymentMethod,
    this.isPaid = false,
    this.specialInstructions,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.rating,
    this.review,
  });

  double get progress {
    if (items.isEmpty) return 0.0;
    final completedItems = items.where((i) => i.status == OrderItemStatus.delivered).length;
    return completedItems / items.length;
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? establishmentId,
    String? tableId,
    int? tableNumber,
    List<OrderItem>? items,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? estimatedReadyAt,
    double? subtotal,
    double? tax,
    double? tip,
    double? total,
    double? roundingAmount,
    String? paymentMethod,
    bool? isPaid,
    String? specialInstructions,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    int? rating,
    String? review,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      establishmentId: establishmentId ?? this.establishmentId,
      tableId: tableId ?? this.tableId,
      tableNumber: tableNumber ?? this.tableNumber,
      items: items ?? this.items,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      estimatedReadyAt: estimatedReadyAt ?? this.estimatedReadyAt,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      tip: tip ?? this.tip,
      total: total ?? this.total,
      roundingAmount: roundingAmount ?? this.roundingAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'establishment_id': establishmentId,
      'table_id': tableId,
      'table_number': tableNumber,
      'items': items.map((i) => i.toJson()).toList(),
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'estimated_ready_at': estimatedReadyAt?.toIso8601String(),
      'subtotal': subtotal,
      'tax': tax,
      'tip': tip,
      'total': total,
      'rounding_amount': roundingAmount,
      'payment_method': paymentMethod,
      'is_paid': isPaid,
      'special_instructions': specialInstructions,
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancellation_reason': cancellationReason,
      'rating': rating,
      'review': review,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      establishmentId: json['establishment_id'] as String,
      tableId: json['table_id'] as String,
      tableNumber: json['table_number'] as int,
      items: (json['items'] as List<dynamic>).map((i) => OrderItem.fromJson(i)).toList(),
      status: OrderStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      estimatedReadyAt: json['estimated_ready_at'] != null ? DateTime.parse(json['estimated_ready_at'] as String) : null,
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      tip: (json['tip'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num).toDouble(),
      roundingAmount: (json['rounding_amount'] as num?)?.toDouble(),
      paymentMethod: json['payment_method'] as String?,
      isPaid: json['is_paid'] as bool? ?? false,
      specialInstructions: json['special_instructions'] as String?,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at'] as String) : null,
      cancellationReason: json['cancellation_reason'] as String?,
      rating: json['rating'] as int?,
      review: json['review'] as String?,
    );
  }
}

class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String? productImageUrl;
  final int quantity;
  final Map<String, dynamic> customizations;
  final String? customizationSummary;
  final String? notes;
  final double unitPrice;
  final double totalPrice;
  final OrderItemStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.quantity,
    this.customizations = const {},
    this.customizationSummary,
    this.notes,
    required this.unitPrice,
    required this.totalPrice,
    this.status = OrderItemStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canModify => status == OrderItemStatus.pending;

  OrderItem copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? productName,
    String? productImageUrl,
    int? quantity,
    Map<String, dynamic>? customizations,
    String? customizationSummary,
    String? notes,
    double? unitPrice,
    double? totalPrice,
    OrderItemStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      customizationSummary: customizationSummary ?? this.customizationSummary,
      notes: notes ?? this.notes,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_image_url': productImageUrl,
      'quantity': quantity,
      'customizations': customizations,
      'customization_summary': customizationSummary,
      'notes': notes,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productImageUrl: json['product_image_url'] as String?,
      quantity: json['quantity'] as int,
      customizations: json['customizations'] as Map<String, dynamic>? ?? {},
      customizationSummary: json['customization_summary'] as String?,
      notes: json['notes'] as String?,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: OrderItemStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
