class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> categoryIds;
  final String imageUrl;
  final bool isAvailable;
  final bool isFeatured;
  final int preparationTime;
  final double rating;
  final int votes;
  final int totalOrders;
  final List<String> tags;
  final ProductOptions? options;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryIds,
    required this.imageUrl,
    this.isAvailable = true,
    this.isFeatured = false,
    this.preparationTime = 10,
    this.rating = 0.0,
    this.votes = 0,
    this.totalOrders = 0,
    this.tags = const [],
    this.options,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_ids': categoryIds,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'is_featured': isFeatured,
      'preparation_time': preparationTime,
      'rating': rating,
      'votes': votes,
      'total_orders': totalOrders,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryIds: (json['category_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      imageUrl: json['image_url'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      preparationTime: json['preparation_time'] as int? ?? 10,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      votes: json['votes'] as int? ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }
}

class ProductOptions {
  final List<CustomizationGroup> customizationGroups;

  ProductOptions({
    this.customizationGroups = const [],
  });
}

enum CustomizationType {
  singleChoice, // Radio buttons - solo una opción (ej: tamaño, temperatura)
  multipleChoice, // Switch on/off - múltiples opciones activables (ej: ingredientes, extras)
  quantity, // Contador - cantidad variable (ej: shots de espresso)
}

class CustomizationGroup {
  final String id;
  final String productId;
  final String name;
  final CustomizationType type;
  final bool isRequired;
  final int displayOrder;
  final List<CustomizationOption> options;
  final int? minSelection;
  final int? maxSelection;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  CustomizationGroup({
    required this.id,
    required this.productId,
    required this.name,
    required this.type,
    this.isRequired = false,
    this.displayOrder = 0,
    required this.options,
    this.minSelection,
    this.maxSelection,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'type': type.name,
      'is_required': isRequired,
      'display_order': displayOrder,
      'min_selection': minSelection,
      'max_selection': maxSelection,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory CustomizationGroup.fromJson(Map<String, dynamic> json) {
    return CustomizationGroup(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      type: CustomizationType.values.byName(json['type'] as String),
      isRequired: json['is_required'] as bool? ?? false,
      displayOrder: json['display_order'] as int? ?? 0,
      options: [],
      minSelection: json['min_selection'] as int?,
      maxSelection: json['max_selection'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }
}

class CustomizationOption {
  final String id;
  final String groupId;
  final String name;
  final double priceModifier;
  final String? description;
  final bool isDefault;
  final bool isAvailable;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  CustomizationOption({
    required this.id,
    required this.groupId,
    required this.name,
    this.priceModifier = 0,
    this.description,
    this.isDefault = false,
    this.isAvailable = true,
    this.displayOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'name': name,
      'price_modifier': priceModifier,
      'description': description,
      'is_default': isDefault,
      'is_available': isAvailable,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory CustomizationOption.fromJson(Map<String, dynamic> json) {
    return CustomizationOption(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      name: json['name'] as String,
      priceModifier: (json['price_modifier'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String icon;
  final int displayOrder;
  final bool isActive;
  final int productCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.displayOrder = 0,
    this.isActive = true,
    this.productCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'display_order': displayOrder,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      displayOrder: json['display_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      productCount: 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }
}
