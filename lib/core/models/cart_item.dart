import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final Map<String, dynamic> customizations;
  final double totalPrice;
  final String? specialInstructions;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.customizations,
    required this.totalPrice,
    this.specialInstructions,
  });

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    Map<String, dynamic>? customizations,
    double? totalPrice,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      totalPrice: totalPrice ?? this.totalPrice,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  String getCustomizationSummary() {
    final List<String> summary = [];
    final groups = product.options?.customizationGroups ?? [];
    groups.sort((a, b) => a.type.index.compareTo(b.type.index));

    Map<String, CustomizationGroup> mergedGroups = {};
    for (var group in groups) {
      if (mergedGroups.containsKey(group.id)) {
        final existing = mergedGroups[group.id]!;
        final mergedOptions = [...existing.options, ...group.options];
        mergedGroups[group.id] = CustomizationGroup(
          id: existing.id,
          productId: existing.productId,
          name: existing.name,
          type: existing.type,
          isRequired: existing.isRequired || group.isRequired,
          options: mergedOptions,
          minSelection: existing.minSelection ?? group.minSelection,
          maxSelection: existing.maxSelection ?? group.maxSelection,
          createdAt: existing.createdAt,
          updatedAt: existing.updatedAt,
        );
      } else {
        mergedGroups[group.id] = group;
      }
    }

    for (var group in mergedGroups.values) {
      final selection = customizations[group.id];

      switch (group.type) {
        case CustomizationType.singleChoice:
          if (selection is String) {
            try {
              final option = group.options.firstWhere((o) => o.id == selection);
              summary.add('${group.name}: ${option.name}');
            } catch (e) {
              // Opción no encontrada
            }
          }
          break;

        case CustomizationType.multipleChoice:
          if (selection is Map) {
            final selections = Map<String, bool>.from(selection);
            final enabledItems = <String>[];
            selections.forEach((optionId, isEnabled) {
              if (isEnabled) {
                try {
                  final option = group.options.firstWhere((o) => o.id == optionId);
                  enabledItems.add(option.name);
                } catch (e) {
                  // Opción no encontrada
                }
              }
            });
            if (enabledItems.isNotEmpty) {
              summary.add('${group.name}: ${enabledItems.join(", ")}');
            }
          }
          break;

        case CustomizationType.quantity:
          if (selection is Map) {
            final quantities = Map<String, int>.from(selection);
            final items = <String>[];
            quantities.forEach((optionId, qty) {
              if (qty > 0) {
                try {
                  final option = group.options.firstWhere((o) => o.id == optionId);
                  items.add('${option.name} x$qty');
                } catch (e) {
                  // Opción no encontrada
                }
              }
            });
            if (items.isNotEmpty) {
              summary.add('${group.name}: ${items.join(", ")}');
            }
          } else if (selection is int && selection > 0) {
            summary.add('${group.name}: x$selection');
          }
          break;
      }
    }

    return summary.join(' • ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': product.id,
      'quantity': quantity,
      'customizations': customizations,
      'totalPrice': totalPrice,
      'specialInstructions': specialInstructions,
    };
  }
}
