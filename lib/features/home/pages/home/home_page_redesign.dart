import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/navigation_provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../notifications/pages/notifications_page.dart';
import '../../../coffee_builder/presentation/pages/coffee_builder_page.dart';
import '../../../coffee_builder/domain/enums/coffee_type.dart';
import '../../../cart/pages/cart_page.dart';

class HomePageRedesign extends StatefulWidget {
  const HomePageRedesign({super.key});

  @override
  State<HomePageRedesign> createState() => _HomePageRedesignState();
}

class _HomePageRedesignState extends State<HomePageRedesign>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  List<String> _getCategories(BuildContext context) {
    return ['Coffee', 'Bakery', 'Sandwiches', 'Extras'];
  }

  List<Map<String, dynamic>> _getProductsByCategory(int categoryIndex) {
    switch (categoryIndex) {
      case 0: // Coffee
        return [
          {
            'name': 'Latte',
            'description':
                'A chocolate-flavoured warm beverage based on espresso and hot milk.',
            'price': '12 USD',
            'image': 'assets/images/CoffeeExamples/Latte.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
          {
            'name': 'Espresso',
            'description':
                'A double shot of espresso, made with 19-21 grams of ground coffee.',
            'price': '14 USD',
            'image': 'assets/images/CoffeeExamples/Espresso.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
          {
            'name': 'Frappé',
            'description':
                'A cold coffee drink blended with ice and topped with whipped cream.',
            'price': '15 USD',
            'image': 'assets/images/CoffeeExamples/Frappe.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
        ];
      case 1: // Bakery
        return [
          {
            'name': 'Blueberry Bagel',
            'description':
                'Freshly baked bagel with sweet blueberries, perfect for breakfast.',
            'price': '7 USD',
            'image': 'assets/images/blueberry-bagel.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
          {
            'name': 'Blueberry Muffin',
            'description':
                'Delicious blueberry muffin with a soft and moist texture.',
            'price': '6 USD',
            'image': 'assets/images/blueberry-muffin.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
          {
            'name': 'Chocolate Cake',
            'description':
                'Rich and decadent chocolate cake with creamy frosting.',
            'price': '9 USD',
            'image': 'assets/images/chocolate-cake.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
        ];
      case 2: // Sandwiches
        return [
          {
            'name': 'Bacon & Egg Sandwich',
            'description':
                'Crispy bacon and fluffy scrambled eggs on toasted bread.',
            'price': '12 USD',
            'image': 'assets/images/bacon-egg-sandwich.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
          {
            'name': 'Roast Chicken Toastie',
            'description':
                'Grilled sandwich with tender roast chicken and melted cheese.',
            'price': '14 USD',
            'image': 'assets/images/roast-chicken-toastie.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
          {
            'name': 'Ham & Cheese Croissant',
            'description':
                'Buttery croissant filled with premium ham and Swiss cheese.',
            'price': '13 USD',
            'image': 'assets/images/ham-cheesse-croissant.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
        ];
      case 3: // Extras
        return [
          {
            'name': 'Chocolate Chip Cookie',
            'description':
                'Classic chocolate chip cookie, crispy outside and chewy inside.',
            'price': '4 USD',
            'image': 'assets/images/chocolate-chip-cookie.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
          {
            'name': 'Chocolate Brownie',
            'description':
                'Rich and fudgy chocolate brownie with a dense texture.',
            'price': '7 USD',
            'image': 'assets/images/chocolate-brownie.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
          {
            'name': 'Tumbler',
            'description':
                'Reusable insulated tumbler to keep your drinks hot or cold.',
            'price': '18 USD',
            'image': 'assets/images/tumbler.png',
            'imageSize': 130.0,
            'imageTop': 5.0,
            'imageRight': 15.0,
          },
        ];
      default:
        return [];
    }
  }

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getGreeting(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return l10n.goodMorning;
    } else if (hour >= 12 && hour < 20) {
      return l10n.goodAfternoon;
    } else {
      return l10n.goodEvening;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildSearchBar(context, isDark),
                      const SizedBox(height: 24),
                      _buildCategoryTabs(context, isDark),
                      const SizedBox(height: 24),
                      _buildBestChoiceSection(context, isDark),
                      const SizedBox(height: 32),
                      _buildRewardProgressCard(context, isDark),
                      const SizedBox(height: 32),
                      _buildGiftFlavorSection(context, isDark),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getGreeting(context),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          Row(
            children: [
              // Icono de notificaciones con badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBackgroundCard
                          : AppColors.lightBackgroundSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: AppColors.getTextPrimary(context),
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  // Badge
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBackgroundPrimary
                              : AppColors.lightBackgroundPrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Icono de perfil circular
              GestureDetector(
                onTap: () {
                  final navProvider =
                      Provider.of<NavigationProvider>(context, listen: false);
                  navProvider.setIndex(2);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBackgroundCard
                          : AppColors.lightBackgroundSecondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackgroundCard
                  : AppColors.lightBackgroundSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: AppColors.getTextSecondary(context),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: AppColors.getTextPrimary(context),
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).searchCoffee,
                      hintStyle: TextStyle(
                        color: AppColors.getTextSecondary(context),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Consumer<CartProvider>(
          builder: (context, cart, child) {
            final itemCount = cart.itemCount;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBackgroundPrimary
                              : AppColors.lightBackgroundPrimary,
                          width: 2,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        itemCount > 99 ? '99+' : itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryTabs(BuildContext context, bool isDark) {
    final categories = _getCategories(context);
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                  right: index < categories.length - 1 ? 20 : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    categories[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.getTextPrimary(context)
                          : AppColors.getTextSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isSelected)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBestChoiceSection(BuildContext context, bool isDark) {
    final products = _getProductsByCategory(_selectedCategoryIndex);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Best choice',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            Text(
              'See more',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildCoffeeCard(
                context,
                isDark,
                product['name'] as String,
                product['description'] as String,
                product['price'] as String,
                product['image'] as String,
                imageSize: product['imageSize'] as double,
                imageTop: product['imageTop'] as double,
                imageRight: product['imageRight'] as double,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCoffeeCard(
    BuildContext context,
    bool isDark,
    String name,
    String description,
    String price,
    String imageUrl, {
    double imageSize = 160,
    double imageTop = 0,
    double imageRight = 0,
  }) {
    return GestureDetector(
      onTap: () {
        print('🔥 TAP DETECTED on $name');
        _navigateToProductBuilder(context, name, price, imageUrl);
      },
      child: SizedBox(
        width: 180,
        height: 260,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Card background
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: 180,
                height: 220,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkCardGradient
                      : AppColors.lightCardGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 9,
                          color: isDark
                              ? Colors.white.withOpacity(0.6)
                              : AppColors.lightTextSecondary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Coffee image overlay - positioned on top of card
            Positioned(
              top: imageTop,
              right: imageRight,
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.12),
                      blurRadius: isDark ? 20 : 15,
                      offset: Offset(0, isDark ? 10 : 6),
                    ),
                  ],
                ),
                child: Image.asset(
                  imageUrl,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.coffee,
                        size: 60,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardProgressCard(BuildContext context, bool isDark) {
    const int currentCoffees = 6;
    const int totalCoffees = 8;
    const double progress = currentCoffees / totalCoffees;

    return Container(
      decoration: BoxDecoration(
        gradient:
            isDark ? AppColors.darkCardGradient : AppColors.lightCardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.03),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.08),
                    AppColors.primary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.local_cafe_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Free Coffee',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.getTextPrimary(context),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Text(
                                    'Loyalty Program',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          AppColors.getTextSecondary(context),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '$currentCoffees',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              height: 1,
                            ),
                          ),
                          Text(
                            '/$totalCoffees',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getTextSecondary(context),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE8926F),
                                  AppColors.primary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: (constraints.maxWidth * progress) - 6,
                          top: -2,
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.primary.withOpacity(0.6),
                                        blurRadius: 8,
                                        spreadRadius: 1.5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.primary,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.getTextSecondary(context),
                            fontWeight: FontWeight.w500,
                          ),
                          children: const [
                            TextSpan(text: 'Only '),
                            TextSpan(
                              text:
                                  '${totalCoffees - currentCoffees} more coffees',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: ' for your reward'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftFlavorSection(BuildContext context, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gift flavor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            Text(
              'See more',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.darkCardGradient
                : AppColors.lightCardGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Coffee gift bag image inside the card
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/CoffeeExamples/GiftBag.png',
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.card_giftcard,
                          size: 50,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Coffee Gift Bag',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Premium selection of freshly roasted coffee beans packaged in an elegant gift bag, perfect for coffee lovers and special occasions.',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? Colors.white.withOpacity(0.6)
                                  : AppColors.lightTextSecondary,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '13 USD',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToProductBuilder(
    BuildContext context,
    String productName,
    String priceString,
    String imagePath,
  ) {
    print('🚀 Navigating to Product Builder');
    print('   Product: $productName');
    print('   Image Path: $imagePath');

    // Parse price from string (e.g., "12 USD" -> 12.0)
    final price = double.tryParse(priceString.split(' ').first) ?? 0.0;

    // Determine product category and coffee type based on selected category
    if (_selectedCategoryIndex == 0) {
      // Coffee category
      CoffeeType coffeeType;
      switch (productName.toLowerCase()) {
        case 'latte':
          coffeeType = CoffeeType.latte;
          break;
        case 'espresso':
          coffeeType = CoffeeType.espresso;
          break;
        case 'frappé':
        case 'frappe':
          coffeeType = CoffeeType.latte;
          break;
        default:
          coffeeType = CoffeeType.latte;
      }

      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return CoffeeBuilderPage(
              initialCoffeeType: coffeeType,
              productImagePath: imagePath,
              heroTag: 'coffee_hero_${productName.toLowerCase()}',
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.05);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
              ),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
        ),
      );
    } else {
      // Non-coffee categories (Bakery, Sandwiches, Extras)
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return CoffeeBuilderPage(
              productName: productName,
              basePrice: price,
              productCategory: _selectedCategoryIndex,
              productImagePath: imagePath,
              heroTag: 'product_hero_${productName.toLowerCase()}',
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.05);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
              ),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
        ),
      );
    }
  }
}
