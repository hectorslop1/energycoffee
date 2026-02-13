import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/product.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/enums/coffee_type.dart';
import '../../domain/enums/product_category.dart';
import '../../state/coffee_builder_state.dart';
import '../widgets/coffee_preview/coffee_visual_widget.dart';
import '../widgets/coffee_preview/product_image_preview.dart';
import '../widgets/selectors/coffee_type_selector.dart';
import '../widgets/selectors/size_selector.dart';
import '../widgets/selectors/temperature_selector.dart';
import '../widgets/selectors/milk_selector.dart';
import '../widgets/selectors/sweetener_selector.dart';
import '../widgets/selectors/toppings_selector.dart';
import '../widgets/selectors/bread_type_selector.dart';
import '../widgets/selectors/vegetables_selector.dart';
import '../widgets/selectors/heating_option_selector.dart';
import '../widgets/selectors/quantity_selector.dart';
import '../widgets/selection_summary_panel.dart';

class CoffeeBuilderPage extends StatefulWidget {
  final CoffeeType? initialCoffeeType;
  final String? productImagePath;
  final String? heroTag;
  final VoidCallback? onCoffeeAdded;
  final String? productName;
  final double? basePrice;
  final int? productCategory;

  const CoffeeBuilderPage({
    super.key,
    this.initialCoffeeType,
    this.productImagePath,
    this.heroTag,
    this.onCoffeeAdded,
    this.productName,
    this.basePrice,
    this.productCategory,
  });

  @override
  State<CoffeeBuilderPage> createState() => _CoffeeBuilderPageState();
}

class _CoffeeBuilderPageState extends State<CoffeeBuilderPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.productCategory != null &&
          widget.productName != null &&
          widget.basePrice != null) {
        // Non-coffee product
        final category = widget.productCategory == 1
            ? ProductCategory.bakery
            : widget.productCategory == 2
                ? ProductCategory.sandwiches
                : ProductCategory.extras;

        context.read<CoffeeBuilderState>().initializeWithProductCategory(
              category: category,
              productName: widget.productName!,
              basePrice: widget.basePrice!,
              imagePath: widget.productImagePath ?? '',
            );
      } else if (widget.initialCoffeeType != null &&
          widget.productImagePath != null) {
        // Coffee product
        context.read<CoffeeBuilderState>().initializeWithProduct(
              widget.initialCoffeeType!,
              widget.productImagePath!,
            );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    context.read<CoffeeBuilderState>().goToStep(step);
  }

  void _nextStep() {
    final state = context.read<CoffeeBuilderState>();
    if (state.currentStep < state.totalSteps - 1) {
      _goToStep(state.currentStep + 1);
    }
  }

  void _previousStep() {
    final state = context.read<CoffeeBuilderState>();
    if (state.currentStep > 0) {
      _goToStep(state.currentStep - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Consumer<CoffeeBuilderState>(
          builder: (context, state, child) {
            String title;
            if (state.productCategory == ProductCategory.coffee) {
              title = AppLocalizations.of(context).buildYourCoffee;
            } else {
              title = 'Customize ${state.productName}';
            }
            return Text(
              title,
              style: TextStyle(
                color: AppColors.getTextPrimary(context),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        iconTheme: IconThemeData(color: AppColors.getTextPrimary(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CoffeeBuilderState>().reset();
              _goToStep(0);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          Consumer<CoffeeBuilderState>(
            builder: (context, state, child) {
              if (state.productImagePath != null) {
                return ProductImagePreview(
                  heroTag: widget.heroTag ?? 'coffee_hero',
                );
              }
              return const CoffeeVisualWidget();
            },
          ),
          const SizedBox(height: 8),
          SelectionSummaryPanel(onStepTap: _goToStep),
          const SizedBox(height: 4),
          Consumer<CoffeeBuilderState>(
            builder: (context, state, child) {
              return _StepIndicator(
                currentStep: state.currentStep,
                totalSteps: state.totalSteps,
                onStepTap: _goToStep,
                isFromProductSelection: state.isFromProductSelection,
                productCategory: state.productCategory,
              );
            },
          ),
          _NavigationButtons(
            onPrevious: _previousStep,
            onNext: _nextStep,
            onCoffeeAdded: widget.onCoffeeAdded,
          ),
          Expanded(
            child: Consumer<CoffeeBuilderState>(
              builder: (context, state, child) {
                List<Widget> pages;

                if (!state.isFromProductSelection) {
                  // Normal coffee builder flow
                  pages = const [
                    _StepPage(child: CoffeeTypeSelector()),
                    _StepPage(child: SizeSelector()),
                    _StepPage(child: TemperatureSelector()),
                    _StepPage(child: MilkSelector()),
                    _StepPage(child: SweetenerSelector()),
                    _StepPage(child: ToppingsSelector()),
                  ];
                } else {
                  // Product selection flow
                  switch (state.productCategory) {
                    case ProductCategory.coffee:
                      pages = const [
                        _StepPage(child: SizeSelector()),
                        _StepPage(child: TemperatureSelector()),
                        _StepPage(child: MilkSelector()),
                        _StepPage(child: SweetenerSelector()),
                        _StepPage(child: ToppingsSelector()),
                      ];
                      break;
                    case ProductCategory.bakery:
                      pages = const [
                        _StepPage(child: HeatingOptionSelector()),
                      ];
                      break;
                    case ProductCategory.sandwiches:
                      pages = const [
                        _StepPage(child: BreadTypeSelector()),
                        _StepPage(child: VegetablesSelector()),
                      ];
                      break;
                    case ProductCategory.extras:
                      pages = const [
                        _StepPage(child: QuantitySelector()),
                      ];
                      break;
                  }
                }

                return PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    context.read<CoffeeBuilderState>().goToStep(index);
                  },
                  children: pages,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  final Widget child;

  const _StepPage({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: child,
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Function(int) onStepTap;
  final bool isFromProductSelection;
  final ProductCategory productCategory;

  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.onStepTap,
    this.isFromProductSelection = false,
    this.productCategory = ProductCategory.coffee,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: GestureDetector(
              onTap: () => onStepTap(index),
              child: Container(
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? 6 : 0,
                ),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppColors.primary
                            : (isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getStepLabel(index, productCategory),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.w500,
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.getTextSecondary(context),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _getStepLabel(int step, ProductCategory category) {
    if (!isFromProductSelection) {
      // Normal flow with all steps
      switch (step) {
        case 0:
          return 'Type';
        case 1:
          return 'Size';
        case 2:
          return 'Temp';
        case 3:
          return 'Milk';
        case 4:
          return 'Sweet';
        case 5:
          return 'Extras';
        default:
          return '';
      }
    }

    // Product selection flow - labels depend on category
    switch (category) {
      case ProductCategory.coffee:
        switch (step) {
          case 0:
            return 'Size';
          case 1:
            return 'Temp';
          case 2:
            return 'Milk';
          case 3:
            return 'Sweet';
          case 4:
            return 'Extras';
          default:
            return '';
        }
      case ProductCategory.bakery:
        switch (step) {
          case 0:
            return 'Heating';
          default:
            return '';
        }
      case ProductCategory.sandwiches:
        switch (step) {
          case 0:
            return 'Bread';
          case 1:
            return 'Veggies';
          default:
            return '';
        }
      case ProductCategory.extras:
        switch (step) {
          case 0:
            return 'Quantity';
          default:
            return '';
        }
    }
  }
}

class _NavigationButtons extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback? onCoffeeAdded;

  const _NavigationButtons({
    required this.onPrevious,
    required this.onNext,
    this.onCoffeeAdded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<CoffeeBuilderState>(
      builder: (context, state, child) {
        final isFirstStep = state.currentStep == 0;
        final isLastStep = state.currentStep == state.totalSteps - 1;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1A1A1A).withOpacity(0.95)
                : Colors.white.withOpacity(0.95),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.grey.shade800.withOpacity(0.5)
                    : Colors.grey.shade300.withOpacity(0.5),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                  Text(
                    '\$${state.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (!isFirstStep)
                OutlinedButton(
                  onPressed: onPrevious,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context).back,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed:
                      isLastStep ? () => _finishBuilder(context) : onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isLastStep
                        ? AppLocalizations.of(context).addToCart
                        : AppLocalizations.of(context).next,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _finishBuilder(BuildContext context) {
    final state = context.read<CoffeeBuilderState>();
    final now = DateTime.now();

    Product product;
    Map<String, dynamic> customizations;
    double totalPrice;
    int quantity;
    String? specialInstructions;

    switch (state.productCategory) {
      case ProductCategory.coffee:
        final coffee = state.buildCoffee();
        product = Product(
          id: 'coffee_${coffee.type.name}_${now.millisecondsSinceEpoch}',
          name: coffee.displayName,
          description: _getCoffeeDescription(coffee),
          price: coffee.calculatePrice(),
          categoryIds: ['cafe'],
          imageUrl: state.productImagePath ??
              'assets/images/CoffeeExamples/Latte.png',
          isAvailable: true,
          createdAt: now,
          updatedAt: now,
        );
        customizations = {
          'type': coffee.type.displayName,
          'size': coffee.size.displayName,
          'temperature': coffee.temperature.displayName,
          'milk': coffee.milkType.displayName,
          'sweetener': coffee.sweetenerType.displayName,
          'sweetenerLevel': coffee.sweetenerLevel,
          'espressoShots': coffee.espressoShots,
          'toppings': coffee.toppings.map((t) => t.displayName).toList(),
        };
        totalPrice = coffee.calculatePrice();
        quantity = 1;
        specialInstructions = coffee.specialInstructions;
        break;

      case ProductCategory.bakery:
        product = Product(
          id: 'bakery_${state.productName}_${now.millisecondsSinceEpoch}',
          name: state.productName,
          description: 'Delicious bakery item',
          price: state.basePrice,
          categoryIds: ['bakery'],
          imageUrl: state.productImagePath ?? '',
          isAvailable: true,
          createdAt: now,
          updatedAt: now,
        );
        customizations = {
          'heatingOption': state.heatingOption.displayName,
        };
        totalPrice = state.totalPrice;
        quantity = state.quantity;
        specialInstructions = null;
        break;

      case ProductCategory.sandwiches:
        product = Product(
          id: 'sandwich_${state.productName}_${now.millisecondsSinceEpoch}',
          name: state.productName,
          description: 'Freshly made sandwich',
          price: state.basePrice,
          categoryIds: ['sandwiches'],
          imageUrl: state.productImagePath ?? '',
          isAvailable: true,
          createdAt: now,
          updatedAt: now,
        );
        customizations = {
          'breadType': state.breadType.displayName,
          'vegetables': state.vegetables.map((v) => v.displayName).toList(),
        };
        totalPrice = state.totalPrice;
        quantity = state.quantity;
        specialInstructions = null;
        break;

      case ProductCategory.extras:
        product = Product(
          id: 'extra_${state.productName}_${now.millisecondsSinceEpoch}',
          name: state.productName,
          description: 'Additional item',
          price: state.basePrice,
          categoryIds: ['extras'],
          imageUrl: state.productImagePath ?? '',
          isAvailable: true,
          createdAt: now,
          updatedAt: now,
        );
        customizations = {};
        totalPrice = state.totalPrice;
        quantity = state.quantity;
        specialInstructions = null;
        break;
    }

    // Add product to cart
    context.read<CartProvider>().addItem(
          product: product,
          quantity: quantity,
          customizations: customizations,
          totalPrice: totalPrice,
          specialInstructions: specialInstructions,
        );

    // Reset builder state
    state.reset();

    // Check if we can pop (i.e., if we were pushed onto the navigation stack)
    // If we can't pop, we're in the navbar context and should call the callback
    final canPop = Navigator.canPop(context);

    if (canPop) {
      // We were navigated here with push, so we can pop back
      Navigator.of(context).pop();
    } else if (onCoffeeAdded != null) {
      // We're in the navbar context, call the callback to navigate to home
      onCoffeeAdded!();
    }

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.name} agregado al carrito - \$${totalPrice.toStringAsFixed(2)}',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getCoffeeDescription(coffee) {
    final parts = <String>[];
    parts.add(coffee.size.displayName);
    parts.add(coffee.temperature.displayName);
    if (coffee.milkType.displayName != 'Sin leche') {
      parts.add('con ${coffee.milkType.displayName}');
    }
    if (coffee.sweetenerType.displayName != 'Sin endulzante') {
      parts.add('${coffee.sweetenerType.displayName}');
    }
    return parts.join(', ');
  }
}
