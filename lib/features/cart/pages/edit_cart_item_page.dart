import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/cart_item.dart';
import '../../../core/models/product.dart';
import '../../../core/providers/cart_provider.dart';

class EditCartItemPage extends StatefulWidget {
  final CartItem cartItem;

  const EditCartItemPage({super.key, required this.cartItem});

  @override
  State<EditCartItemPage> createState() => _EditCartItemPageState();
}

class _EditCartItemPageState extends State<EditCartItemPage> {
  late Map<String, dynamic> _selections;
  late TextEditingController _specialInstructionsController;

  double get _totalPrice {
    double basePrice = widget.cartItem.product.price;
    final groups = widget.cartItem.product.options?.customizationGroups ?? [];

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
      switch (group.type) {
        case CustomizationType.singleChoice:
          String? selectedId = _selections[group.id];
          if (selectedId != null) {
            final option = group.options.firstWhere(
              (o) => o.id == selectedId,
              orElse: () => group.options.first,
            );
            basePrice += option.priceModifier;
          }
          break;

        case CustomizationType.multipleChoice:
          Map<String, bool> selections = _selections[group.id] ?? {};
          selections.forEach((optionId, isEnabled) {
            if (isEnabled) {
              try {
                final option =
                    group.options.firstWhere((o) => o.id == optionId);
                basePrice += option.priceModifier;
              } catch (e) {
                // Opción no encontrada, ignorar
              }
            }
          });
          break;

        case CustomizationType.quantity:
          final storedValue = _selections[group.id];
          if (storedValue is Map) {
            Map<String, int> quantities = Map<String, int>.from(storedValue);
            quantities.forEach((optionId, quantity) {
              if (quantity > 0) {
                try {
                  final option =
                      group.options.firstWhere((o) => o.id == optionId);
                  basePrice += option.priceModifier * quantity;
                } catch (e) {
                  // Opción no encontrada, ignorar
                }
              }
            });
          } else if (storedValue is int &&
              storedValue > 0 &&
              group.options.isNotEmpty) {
            basePrice += group.options.first.priceModifier * storedValue;
          }
          break;
      }
    }

    return basePrice * widget.cartItem.quantity;
  }

  @override
  void initState() {
    super.initState();
    _selections = Map<String, dynamic>.from(widget.cartItem.customizations);
    _specialInstructionsController = TextEditingController(
      text: widget.cartItem.specialInstructions ?? '',
    );
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductInfo(),
                ..._buildCustomizationGroups(),
                _buildSpecialInstructions(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.getBackgroundSecondary(context),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.backgroundSecondary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.secondary.withValues(alpha: 0.1),
          child: Center(
            child: Icon(
              Icons.coffee_rounded,
              size: 120,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.cartItem.product.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.cartItem.product.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Editando ${widget.cartItem.quantity} ${widget.cartItem.quantity == 1 ? "unidad" : "unidades"}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCustomizationGroups() {
    final groups = widget.cartItem.product.options?.customizationGroups ?? [];
    if (groups.isEmpty) return [];

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

    final mergedGroupsList = mergedGroups.values.toList();
    final List<Widget> sections = [];

    mergedGroupsList
        .where((group) => group.type == CustomizationType.singleChoice)
        .forEach((group) {
      sections.add(_buildSingleChoiceGroup(group));
    });
    mergedGroupsList
        .where((group) => group.type == CustomizationType.multipleChoice)
        .forEach((group) {
      sections.add(_buildMultipleChoiceGroup(group));
    });
    mergedGroupsList
        .where((group) => group.type == CustomizationType.quantity)
        .forEach((group) {
      sections.add(_buildQuantityGroup(group));
    });

    return sections;
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSingleChoiceGroup(CustomizationGroup group) {
    String? selectedId = _selections[group.id];
    return _buildSection(
      title: group.name + (group.isRequired ? ' *' : ''),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: group.options.map((option) {
          final isSelected = selectedId == option.id;
          return GestureDetector(
            onTap: () => setState(() {
              log('value: ${group.name} - ${option.name}');
              _selections[group.id] = option.id;
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? AppColors.textAltPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (option.priceModifier > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      '+\$${option.priceModifier.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.textAltPrimary.withValues(alpha: 0.8)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMultipleChoiceGroup(CustomizationGroup group) {
    final storedValue = _selections[group.id];
    Map<String, bool> selections = {};

    if (storedValue is Map) {
      selections = Map<String, bool>.from(storedValue);
    }

    return _buildSection(
      title: group.name + (group.isRequired ? ' *' : ''),
      child: Column(
        children: group.options.map((option) {
          final isEnabled = selections[option.id] ?? false;
          return Container(
            height: 60,
            padding: const EdgeInsets.all(12),
            margin: option.id != group.options.last.id
                ? const EdgeInsets.only(bottom: 12)
                : null,
            decoration: BoxDecoration(
              gradient: isEnabled ? AppColors.primaryGradient : null,
              color: isEnabled ? null : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: isEnabled
                  ? null
                  : Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isEnabled
                              ? AppColors.textAltPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (option.priceModifier > 0)
                        Text(
                          '+\$${option.priceModifier.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isEnabled
                                ? AppColors.textAltPrimary
                                    .withValues(alpha: 0.8)
                                : AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: (value) {
                    log('value: ${group.name} - ${option.name} - $value');
                    setState(() {
                      final updatedSelections =
                          Map<String, bool>.from(selections);
                      if (value == true) {
                        final enabledCount =
                            updatedSelections.values.where((v) => v).length;
                        if (group.maxSelection == null ||
                            enabledCount < group.maxSelection!) {
                          updatedSelections[option.id] = value;
                        }
                      } else {
                        updatedSelections[option.id] = value;
                      }
                      _selections[group.id] = updatedSelections;
                    });
                  },
                  activeThumbColor: AppColors.textAltPrimary,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuantityGroup(CustomizationGroup group) {
    Map<String, int> quantities = {};
    final storedValue = _selections[group.id];

    if (storedValue is Map) {
      quantities = Map<String, int>.from(storedValue);
    } else if (storedValue is int && group.options.isNotEmpty) {
      quantities[group.options.first.id] = storedValue;
    }

    return _buildSection(
      title: group.name,
      child: Column(
        children: group.options.map((option) {
          final quantity = quantities[option.id] ?? 0;
          return Container(
            height: 60,
            padding: const EdgeInsets.all(12),
            margin: option.id != group.options.last.id
                ? const EdgeInsets.only(bottom: 12)
                : null,
            decoration: BoxDecoration(
              gradient: quantity > 0 ? AppColors.primaryGradient : null,
              color: quantity > 0 ? null : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: quantity > 0
                  ? null
                  : Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: quantity > 0
                              ? AppColors.textAltPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (option.priceModifier > 0)
                        Text(
                          '+\$${option.priceModifier.toStringAsFixed(0)} c/u',
                          style: TextStyle(
                            fontSize: 12,
                            color: quantity > 0
                                ? AppColors.textAltPrimary
                                    .withValues(alpha: 0.8)
                                : AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: quantity > 0
                        ? AppColors.textAltPrimary.withValues(alpha: 0.2)
                        : AppColors.backgroundPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: quantity > 0
                            ? () {
                                setState(() {
                                  final updatedQuantities =
                                      Map<String, int>.from(quantities);
                                  updatedQuantities[option.id] = quantity - 1;
                                  _selections[group.id] = updatedQuantities;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_rounded, size: 18),
                        color: quantity > 0
                            ? AppColors.textAltPrimary
                            : AppColors.textSecondary,
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$quantity',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: quantity > 0
                                ? AppColors.textAltPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            final updatedQuantities =
                                Map<String, int>.from(quantities);
                            updatedQuantities[option.id] = quantity + 1;
                            _selections[group.id] = updatedQuantities;
                          });
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        color: quantity > 0
                            ? AppColors.textAltPrimary
                            : AppColors.primary,
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpecialInstructions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instrucciones Especiales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _specialInstructionsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Ej: Sin azúcar, extra caliente...',
              hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.5)),
              filled: true,
              fillColor: AppColors.backgroundSecondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textAltPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_rounded),
                const SizedBox(width: 8),
                Text(
                  'Guardar Cambios \$${_totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    cartProvider.updateItemCustomizations(
      itemId: widget.cartItem.id,
      customizations: Map<String, dynamic>.from(_selections),
      totalPrice: _totalPrice,
      specialInstructions: _specialInstructionsController.text.isNotEmpty
          ? _specialInstructionsController.text
          : null,
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personalización actualizada'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
