class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final bool isStar;
  final int orderCount;
  final double rating;
  final List<ProductCustomization> customizations;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.isStar = false,
    this.orderCount = 0,
    this.rating = 0.0,
    this.customizations = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'isStar': isStar,
      'orderCount': orderCount,
      'rating': rating,
      'customizations': customizations.map((c) => c.toJson()).toList(),
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      categoryId: json['categoryId'] as String,
      isStar: json['isStar'] as bool? ?? false,
      orderCount: json['orderCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      customizations: (json['customizations'] as List<dynamic>?)?.map((c) => ProductCustomization.fromJson(c)).toList() ?? [],
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String? iconUrl;
  final int order;

  const CategoryModel({
    required this.id,
    required this.name,
    this.iconUrl,
    this.order = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
      'order': order,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }
}

enum CustomizationType { quantity, singleSelect }

class ProductCustomization {
  final String id;
  final String name;
  final CustomizationType type;
  final List<CustomizationOption> options;
  final int? minValue;
  final int? maxValue;
  final int? defaultValue;

  const ProductCustomization({
    required this.id,
    required this.name,
    required this.type,
    this.options = const [],
    this.minValue,
    this.maxValue,
    this.defaultValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'options': options.map((o) => o.toJson()).toList(),
      'minValue': minValue,
      'maxValue': maxValue,
      'defaultValue': defaultValue,
    };
  }

  factory ProductCustomization.fromJson(Map<String, dynamic> json) {
    return ProductCustomization(
      id: json['id'] as String,
      name: json['name'] as String,
      type: CustomizationType.values.byName(json['type'] as String),
      options: (json['options'] as List<dynamic>?)?.map((o) => CustomizationOption.fromJson(o)).toList() ?? [],
      minValue: json['minValue'] as int?,
      maxValue: json['maxValue'] as int?,
      defaultValue: json['defaultValue'] as int?,
    );
  }
}

class CustomizationOption {
  final String id;
  final String name;
  final double extraPrice;

  const CustomizationOption({
    required this.id,
    required this.name,
    this.extraPrice = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'extraPrice': extraPrice,
    };
  }

  factory CustomizationOption.fromJson(Map<String, dynamic> json) {
    return CustomizationOption(
      id: json['id'] as String,
      name: json['name'] as String,
      extraPrice: (json['extraPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
