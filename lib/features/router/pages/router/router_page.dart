import 'package:energy_coffee/features/home/pages/home/home_page_redesign.dart';
import 'package:energy_coffee/features/coffee_builder/presentation/pages/coffee_builder_page.dart';
import 'package:energy_coffee/features/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/navigation_provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/custom_navbar.dart';

class RouterPage extends StatefulWidget {
  final int initialIndex;

  const RouterPage({super.key, this.initialIndex = 0});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  late int _currentIndex;
  late PageController _pageController;

  List<Widget> get _pages => [
        const HomePageRedesign(),
        CoffeeBuilderPage(
          onCoffeeAdded: () {
            // Navigate to home page after adding coffee to cart
            _onNavTap(0);
          },
        ),
        const ProfilePage(),
      ];

  List<NavBarItem> _getNavItems(BuildContext context) {
    return [
      NavBarItem(
          icon: Icons.home_rounded, label: AppLocalizations.of(context).home),
      NavBarItem(
          icon: Icons.coffee_rounded,
          label: AppLocalizations.of(context).coffeeBuilder),
      NavBarItem(
          icon: Icons.person_rounded,
          label: AppLocalizations.of(context).profile),
    ];
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navProvider =
          Provider.of<NavigationProvider>(context, listen: false);
      navProvider.setIndex(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.setIndex(index);
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, NavigationProvider>(
      builder: (context, themeProvider, navProvider, child) {
        if (navProvider.currentIndex != _currentIndex &&
            _pageController.hasClients) {
          _pageController.animateToPage(
            navProvider.currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        return Scaffold(
          backgroundColor: AppColors.getBackgroundPrimary(context),
          body: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                  }
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: child,
                    ),
                  );
                },
                child: _pages[index],
              );
            },
          ),
          bottomNavigationBar: CustomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
            items: _getNavItems(context),
          ),
        );
      },
    );
  }
}
