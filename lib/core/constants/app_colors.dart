import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFFD17842);
  static const Color secondary = Color(0xFF4F2C1D);

  // Light Mode Colors (Café/Marrón theme para consistencia)
  static const Color lightBackgroundPrimary =
      Color(0xFFF5F1E8); // Tono beige muy claro
  static const Color lightBackgroundSecondary =
      Color(0xFFFFFBF5); // Tono crema claro
  static const Color lightBackgroundCard =
      Color(0xFFD5CFAC); // Tono café claro para tarjetas
  static const Color lightBackgroundCardDark =
      Color(0xFFC4BDA0); // Tono café más oscuro para degradados
  static const Color lightTextPrimary =
      Color(0xFF1A1614); // Casi negro para máximo contraste
  static const Color lightTextSecondary =
      Color(0xFF4A3F2A); // Marrón muy oscuro para texto secundario

  // Dark Mode Colors - Tonos más suaves y cálidos
  static const Color darkBackgroundPrimary =
      Color(0xFF1C1917); // Marrón oscuro en lugar de negro puro
  static const Color darkBackgroundSecondary =
      Color(0xFF292524); // Tono marrón más claro
  static const Color darkBackgroundCard =
      Color(0xFF322F2C); // Tarjetas con más calidez
  static const Color darkBackgroundCardLight =
      Color(0xFF44403C); // Tono más claro para degradados
  static const Color darkTextPrimary = Color(0xFFFAFAF9); // Blanco más suave
  static const Color darkTextSecondary = Color(0xFFA8A29E); // Gris cálido

  // Navbar Colors
  static const Color navbarIconUnselected =
      Color(0xFFE0E0E0); // Gris muy claro para mejor visibilidad
  static const Color navbarIconSelected = primary;

  // Text
  static const Color textAltPrimary = Color(0xFFFFFFFF);
  static const Color textAltSecondary = Color(0xFFCDC3BF);

  // Status
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);

  // Gradient
  static const List<Color> gradientColors = [
    Color(0xFFC67C4E),
    Color(0xFF885535),
    Color(0xFF74482E),
    Color(0xFF603C26),
  ];

  static const List<double> gradientStops = [0.0, 0.32, 0.50, 1.0];

  static const LinearGradient primaryGradient = LinearGradient(
    colors: gradientColors,
    stops: gradientStops,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Mode Card Gradient - Degradado elegante y notorio
  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF57534E), // Tono gris-marrón claro para mayor contraste
      Color(0xFF44403C), // Tono intermedio cálido
      Color(0xFF322F2C), // Tono más oscuro
      Color(0xFF292524), // Tono base oscuro
    ],
    stops: [0.0, 0.35, 0.7, 1.0],
  );

  // Light Mode Card Gradient - Degradado elegante que conecta con el fondo
  static const LinearGradient lightCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF0EBD8), // Tono muy claro que conecta con el fondo
      Color(0xFFE5DFBC), // Tono intermedio suave
      Color(0xFFD5CFAC), // Color principal #d5cfac
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Static colors for backward compatibility
  static const Color backgroundPrimary = lightBackgroundPrimary;
  static const Color backgroundSecondary = lightBackgroundSecondary;
  static const Color textPrimary = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;

  // Context-aware methods
  static Color getBackgroundPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackgroundPrimary
        : lightBackgroundPrimary;
  }

  static Color getBackgroundSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackgroundSecondary
        : lightBackgroundSecondary;
  }

  static Color getBackgroundCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackgroundCard
        : lightBackgroundCard;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }
}
