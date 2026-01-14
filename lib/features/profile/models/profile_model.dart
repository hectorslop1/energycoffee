class PaymentMethodModel {
  final String id;
  final PaymentType type;
  final String? cardLastFour;
  final String? cardBrand;
  final String? paypalEmail;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    this.cardLastFour,
    this.cardBrand,
    this.paypalEmail,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'cardLastFour': cardLastFour,
      'cardBrand': cardBrand,
      'paypalEmail': paypalEmail,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      type: PaymentType.values.byName(json['type'] as String),
      cardLastFour: json['cardLastFour'] as String?,
      cardBrand: json['cardBrand'] as String?,
      paypalEmail: json['paypalEmail'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
}

enum PaymentType { cash, card, paypal, terminal }

class OrderHistoryItem {
  final String orderId;
  final DateTime date;
  final double total;
  final int itemCount;
  final String status;

  const OrderHistoryItem({
    required this.orderId,
    required this.date,
    required this.total,
    required this.itemCount,
    required this.status,
  });
}
