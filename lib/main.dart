import 'package:energy_coffee/features/router/pages/router/router_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/cart_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/app_state_provider.dart';
import 'core/providers/biometric_provider.dart';
import 'core/providers/navigation_provider.dart';
import 'core/l10n/app_localizations_delegate.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/pages/splash/splash_page.dart';
import 'features/auth/pages/login/login_page.dart';
import 'features/coffee_builder/state/coffee_builder_state.dart';
import 'features/table/providers/table_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: EnergyCoffeeApp(),
    ),
  );
}

class EnergyCoffeeApp extends StatelessWidget {
  const EnergyCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => ThemeProvider()),
        provider.ChangeNotifierProvider(create: (_) => LocaleProvider()),
        provider.ChangeNotifierProvider(create: (_) => CartProvider()),
        provider.ChangeNotifierProvider(create: (_) => CoffeeBuilderState()),
        provider.ChangeNotifierProvider(create: (_) => AppStateProvider()),
        provider.ChangeNotifierProvider(create: (_) => AuthProvider()),
        provider.ChangeNotifierProvider(create: (_) => BiometricProvider()),
        provider.ChangeNotifierProvider(create: (_) => NavigationProvider()),
        provider.ChangeNotifierProvider(create: (_) => TableProvider()),
      ],
      child: provider.Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          final isDark = themeProvider.themeMode == ThemeMode.dark;

          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            ),
          );

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
            ],
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: _AppNavigator(),
          );
        },
      ),
    );
  }
}

/// Navegador principal que maneja el flujo de pantallas
class _AppNavigator extends StatefulWidget {
  _AppNavigator();

  @override
  State<_AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<_AppNavigator> {
  bool _splashCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final appStateProvider =
        provider.Provider.of<AppStateProvider>(context, listen: false);
    final authProvider =
        provider.Provider.of<AuthProvider>(context, listen: false);
    final themeProvider =
        provider.Provider.of<ThemeProvider>(context, listen: false);
    final localeProvider =
        provider.Provider.of<LocaleProvider>(context, listen: false);

    await Future.wait([
      appStateProvider.initialize(),
      authProvider.initialize(),
      themeProvider.initialize(),
      localeProvider.initialize(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print(
            '🔄 [AppNavigator] Consumer build - isAuthenticated: ${authProvider.isAuthenticated}, status: ${authProvider.status}');
        print(
            '🔄 [AppNavigator] Consumer build - _splashCompleted: $_splashCompleted');

        Widget currentScreen;

        if (!_splashCompleted) {
          currentScreen = SplashPage(
            key: const ValueKey('splash'),
            onComplete: () {
              setState(() {
                _splashCompleted = true;
              });
            },
          );
        } else if (authProvider.isAuthenticated) {
          print('✅ [AppNavigator] Construyendo RouterPage (Home)');
          currentScreen = const RouterPage(
            key: ValueKey('home'),
          );
        } else {
          print('🔐 [AppNavigator] Construyendo LoginPage');
          currentScreen = const LoginPage(
            key: ValueKey('login'),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 1200),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: currentScreen,
        );
      },
    );
  }
}
