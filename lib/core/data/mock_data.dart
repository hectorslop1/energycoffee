import '../models/product.dart';

/// Datos mock centralizados con todos los modelos correctamente configurados
/// según DATABASE_SCHEMA.md
class MockData {
  static final DateTime _now = DateTime.now();

  // ============================================================================
  // CATEGORIES
  // ============================================================================

  static final List<Category> categories = [
    Category(
      id: 'cat-1',
      name: 'Bebidas Calientes',
      icon: '☕',
      displayOrder: 1,
      isActive: true,
      productCount: 0,
      createdAt: _now,
      updatedAt: _now,
    ),
    Category(
      id: 'cat-2',
      name: 'Bebidas Frías',
      icon: '🧊',
      displayOrder: 2,
      isActive: true,
      productCount: 0,
      createdAt: _now,
      updatedAt: _now,
    ),
    Category(
      id: 'cat-3',
      name: 'Postres',
      icon: '🍰',
      displayOrder: 3,
      isActive: true,
      productCount: 0,
      createdAt: _now,
      updatedAt: _now,
    ),
    Category(
      id: 'cat-4',
      name: 'Alimentos',
      icon: '🍽️',
      displayOrder: 4,
      isActive: true,
      productCount: 0,
      createdAt: _now,
      updatedAt: _now,
    ),
    Category(
      id: 'cat-5',
      name: 'Snacks',
      icon: '🍿',
      displayOrder: 5,
      isActive: true,
      productCount: 0,
      createdAt: _now,
      updatedAt: _now,
    ),
    Category(
      id: 'cat-6',
      name: 'Especiales',
      icon: '⭐',
      displayOrder: 6,
      isActive: true,
      productCount: 0,
      createdAt: _now,
      updatedAt: _now,
    ),
  ];

  // ============================================================================
  // CUSTOMIZATION OPTIONS & GROUPS
  // ============================================================================

  // Opciones de Tamaño
  static List<CustomizationOption> _getSizeOptions(String groupId) => [
        CustomizationOption(
          id: 'opt-size-1',
          groupId: groupId,
          name: 'Chico',
          priceModifier: 0,
          isDefault: false,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-size-2',
          groupId: groupId,
          name: 'Mediano',
          priceModifier: 0,
          isDefault: true,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-size-3',
          groupId: groupId,
          name: 'Grande',
          priceModifier: 10,
          isDefault: false,
          createdAt: _now,
          updatedAt: _now,
        ),
      ];

  // Opciones de Temperatura
  static List<CustomizationOption> _getTemperatureOptions(String groupId) => [
        CustomizationOption(
          id: 'opt-temp-1',
          groupId: groupId,
          name: 'Caliente',
          priceModifier: 0,
          isDefault: true,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-temp-2',
          groupId: groupId,
          name: 'Frío',
          priceModifier: 0,
          isDefault: false,
          createdAt: _now,
          updatedAt: _now,
        ),
      ];

  // Opciones de Leche
  static List<CustomizationOption> _getMilkOptions(String groupId) => [
        CustomizationOption(
          id: 'opt-milk-1',
          groupId: groupId,
          name: 'Leche entera',
          priceModifier: 0,
          isDefault: true,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-milk-2',
          groupId: groupId,
          name: 'Leche deslactosada',
          priceModifier: 5,
          isDefault: false,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-milk-3',
          groupId: groupId,
          name: 'Leche de almendras',
          priceModifier: 10,
          isDefault: false,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-milk-4',
          groupId: groupId,
          name: 'Leche de soya',
          priceModifier: 10,
          isDefault: false,
          createdAt: _now,
          updatedAt: _now,
        ),
      ];

  // Opciones de Extras
  static List<CustomizationOption> _getExtrasOptions(String groupId) => [
        CustomizationOption(
          id: 'opt-extra-1',
          groupId: groupId,
          name: 'Shot extra de espresso',
          priceModifier: 15,
          description: 'Agrega un shot adicional de café',
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-extra-2',
          groupId: groupId,
          name: 'Crema batida',
          priceModifier: 10,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-extra-3',
          groupId: groupId,
          name: 'Caramelo',
          priceModifier: 8,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-extra-4',
          groupId: groupId,
          name: 'Chocolate',
          priceModifier: 8,
          createdAt: _now,
          updatedAt: _now,
        ),
      ];

  // Opciones de Azúcar
  static List<CustomizationOption> _getSugarOptions(String groupId) => [
        CustomizationOption(
          id: 'opt-sugar-1',
          groupId: groupId,
          name: 'Sin azúcar',
          priceModifier: 0,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-sugar-2',
          groupId: groupId,
          name: 'Azúcar estándar',
          priceModifier: 0,
          isDefault: true,
          createdAt: _now,
          updatedAt: _now,
        ),
        CustomizationOption(
          id: 'opt-sugar-3',
          groupId: groupId,
          name: 'Extra azúcar',
          priceModifier: 0,
          createdAt: _now,
          updatedAt: _now,
        ),
      ];

  // Grupos de personalización para bebidas calientes
  static List<CustomizationGroup> getHotDrinkCustomizations(String productId) {
    const groupSizeId = 'group-size-hot';
    const groupTempId = 'group-temp-hot';
    const groupMilkId = 'group-milk-hot';
    const groupExtrasId = 'group-extras-hot';

    return [
      CustomizationGroup(
        id: groupSizeId,
        productId: productId,
        name: 'Tamaño',
        type: CustomizationType.singleChoice,
        isRequired: true,
        displayOrder: 1,
        options: _getSizeOptions(groupSizeId),
        createdAt: _now,
        updatedAt: _now,
      ),
      CustomizationGroup(
        id: groupTempId,
        productId: productId,
        name: 'Temperatura',
        type: CustomizationType.singleChoice,
        isRequired: false,
        displayOrder: 2,
        options: _getTemperatureOptions(groupTempId),
        createdAt: _now,
        updatedAt: _now,
      ),
      CustomizationGroup(
        id: groupMilkId,
        productId: productId,
        name: 'Tipo de leche',
        type: CustomizationType.singleChoice,
        isRequired: false,
        displayOrder: 3,
        options: _getMilkOptions(groupMilkId),
        createdAt: _now,
        updatedAt: _now,
      ),
      CustomizationGroup(
        id: groupExtrasId,
        productId: productId,
        name: 'Extras',
        type: CustomizationType.multipleChoice,
        isRequired: false,
        displayOrder: 4,
        minSelection: 0,
        maxSelection: 4,
        options: _getExtrasOptions(groupExtrasId),
        createdAt: _now,
        updatedAt: _now,
      ),
    ];
  }

  // Grupos de personalización para bebidas frías
  static List<CustomizationGroup> getColdDrinkCustomizations(String productId) {
    const groupSizeId = 'group-size-cold';
    const groupMilkId = 'group-milk-cold';
    const groupSugarId = 'group-sugar-cold';
    const groupExtrasId = 'group-extras-cold';

    return [
      CustomizationGroup(
        id: groupSizeId,
        productId: productId,
        name: 'Tamaño',
        type: CustomizationType.singleChoice,
        isRequired: true,
        displayOrder: 1,
        options: _getSizeOptions(groupSizeId),
        createdAt: _now,
        updatedAt: _now,
      ),
      CustomizationGroup(
        id: groupMilkId,
        productId: productId,
        name: 'Tipo de leche',
        type: CustomizationType.singleChoice,
        isRequired: false,
        displayOrder: 2,
        options: _getMilkOptions(groupMilkId),
        createdAt: _now,
        updatedAt: _now,
      ),
      CustomizationGroup(
        id: groupSugarId,
        productId: productId,
        name: 'Nivel de azúcar',
        type: CustomizationType.singleChoice,
        isRequired: false,
        displayOrder: 3,
        options: _getSugarOptions(groupSugarId),
        createdAt: _now,
        updatedAt: _now,
      ),
      CustomizationGroup(
        id: groupExtrasId,
        productId: productId,
        name: 'Extras',
        type: CustomizationType.multipleChoice,
        isRequired: false,
        displayOrder: 4,
        minSelection: 0,
        maxSelection: 3,
        options: _getExtrasOptions(groupExtrasId),
        createdAt: _now,
        updatedAt: _now,
      ),
    ];
  }

  // Grupos de personalización para postres
  static List<CustomizationGroup> getDessertCustomizations(String productId) {
    const groupExtrasId = 'group-extras-dessert';

    return [
      CustomizationGroup(
        id: groupExtrasId,
        productId: productId,
        name: 'Extras',
        type: CustomizationType.multipleChoice,
        isRequired: false,
        displayOrder: 1,
        minSelection: 0,
        maxSelection: 2,
        options: [
          CustomizationOption(
            id: 'opt-dessert-1',
            groupId: groupExtrasId,
            name: 'Crema batida',
            priceModifier: 10,
            createdAt: _now,
            updatedAt: _now,
          ),
          CustomizationOption(
            id: 'opt-dessert-2',
            groupId: groupExtrasId,
            name: 'Chocolate extra',
            priceModifier: 8,
            createdAt: _now,
            updatedAt: _now,
          ),
        ],
        createdAt: _now,
        updatedAt: _now,
      ),
    ];
  }

  // ============================================================================
  // PRODUCTS
  // ============================================================================

  static final List<Product> products = [
    // Bebidas Calientes
    Product(
      id: 'prod-1',
      name: 'Cappuccino',
      description: 'Espresso con leche vaporizada y espuma cremosa',
      price: 45.0,
      categoryIds: ['cat-1'],
      imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d',
      isAvailable: true,
      isFeatured: true,
      preparationTime: 5,
      rating: 4.8,
      votes: 156,
      totalOrders: 523,
      tags: [],
      options: ProductOptions(
        customizationGroups: getHotDrinkCustomizations('prod-1'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),
    Product(
      id: 'prod-2',
      name: 'Latte',
      description: 'Espresso suave con abundante leche vaporizada',
      price: 42.0,
      categoryIds: ['cat-1'],
      imageUrl: 'https://images.unsplash.com/photo-1561882468-9110e03e0f78',
      isAvailable: true,
      preparationTime: 5,
      rating: 4.7,
      votes: 203,
      totalOrders: 687,
      tags: [],
      options: ProductOptions(
        customizationGroups: getHotDrinkCustomizations('prod-2'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),
    Product(
      id: 'prod-3',
      name: 'Americano',
      description: 'Espresso diluido con agua caliente',
      price: 35.0,
      categoryIds: ['cat-1'],
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd',
      isAvailable: true,
      preparationTime: 3,
      rating: 4.5,
      votes: 98,
      totalOrders: 345,
      tags: [],
      options: ProductOptions(
        customizationGroups: getHotDrinkCustomizations('prod-3'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),
    Product(
      id: 'prod-4',
      name: 'Mocha',
      description: 'Espresso con chocolate y leche vaporizada',
      price: 48.0,
      categoryIds: ['cat-1'],
      imageUrl: 'https://images.unsplash.com/photo-1578374173705-0a5a4c5c41e2',
      isAvailable: true,
      isFeatured: true,
      preparationTime: 6,
      rating: 4.9,
      votes: 234,
      totalOrders: 789,
      tags: [],
      options: ProductOptions(
        customizationGroups: getHotDrinkCustomizations('prod-4'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),

    // Bebidas Frías
    Product(
      id: 'prod-5',
      name: 'Frappé de Caramelo',
      description: 'Bebida helada con café, caramelo y crema batida',
      price: 52.0,
      categoryIds: ['cat-2'],
      imageUrl: 'https://images.unsplash.com/photo-1461023058943-3968b75cc699',
      isAvailable: true,
      isFeatured: true,
      preparationTime: 7,
      rating: 4.9,
      votes: 312,
      totalOrders: 1024,
      tags: [],
      options: ProductOptions(
        customizationGroups: getColdDrinkCustomizations('prod-5'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),
    Product(
      id: 'prod-6',
      name: 'Cold Brew',
      description: 'Café preparado en frío durante 12 horas',
      price: 48.0,
      categoryIds: ['cat-2'],
      imageUrl: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7',
      isAvailable: true,
      preparationTime: 3,
      rating: 4.6,
      votes: 145,
      totalOrders: 456,
      tags: [],
      options: ProductOptions(
        customizationGroups: getColdDrinkCustomizations('prod-6'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),

    // Postres
    Product(
      id: 'prod-7',
      name: 'Croissant de Chocolate',
      description: 'Croissant francés relleno de chocolate belga',
      price: 35.0,
      categoryIds: ['cat-3'],
      imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a',
      isAvailable: true,
      preparationTime: 2,
      rating: 4.7,
      votes: 189,
      totalOrders: 634,
      tags: [],
      options: ProductOptions(
        customizationGroups: getDessertCustomizations('prod-7'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),
    Product(
      id: 'prod-8',
      name: 'Cheesecake',
      description: 'Pastel de queso cremoso con base de galleta',
      price: 45.0,
      categoryIds: ['cat-3'],
      imageUrl: 'https://images.unsplash.com/photo-1533134242820-b4f0d2f7e9a5',
      isAvailable: true,
      isFeatured: true,
      preparationTime: 2,
      rating: 4.8,
      votes: 267,
      totalOrders: 891,
      tags: [],
      options: ProductOptions(
        customizationGroups: getDessertCustomizations('prod-8'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),
    // Producto con múltiples categorías (Bebidas Frías + Especiales)
    Product(
      id: 'prod-9',
      name: 'Frappé Especial',
      description: 'Bebida helada con café, crema y topping especial',
      price: 55.0,
      categoryIds: ['cat-2', 'cat-6'], // Bebidas Frías + Especiales
      imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699',
      isAvailable: true,
      isFeatured: true,
      preparationTime: 7,
      rating: 4.9,
      votes: 189,
      totalOrders: 456,
      tags: [],
      options: ProductOptions(
        customizationGroups: getColdDrinkCustomizations('prod-9'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),
    // Producto con múltiples categorías (Bebidas Calientes + Postres)
    Product(
      id: 'prod-10',
      name: 'Affogato',
      description: 'Helado de vainilla con espresso caliente',
      price: 48.0,
      categoryIds: ['cat-1', 'cat-3'], // Bebidas Calientes + Postres
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd',
      isAvailable: true,
      isFeatured: true,
      preparationTime: 5,
      rating: 4.7,
      votes: 143,
      totalOrders: 378,
      tags: ['premium', 'dulce'],
      options: ProductOptions(
        customizationGroups: getHotDrinkCustomizations('prod-10'),
      ),
      createdAt: _now,
      updatedAt: _now,
    ),
  ];

  // Métodos de utilidad para obtener productos por categoría
  static List<Product> getProductsByCategory(String categoryId) {
    return products.where((p) => p.categoryIds.contains(categoryId)).toList();
  }

  static Product? getProductById(String productId) {
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  static Category? getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }
}
