class AppConfig {
  static String language = 'es';

  static const double taxRate = 0;
  static const String currencySymbol = '\$';

  static bool get hasTax => taxRate > 0;

  static String get taxLabel => 'Impuestos (${(taxRate * 100).toStringAsFixed(0)}%)';

  static String formatCurrency(double amount) {
    return '$currencySymbol${amount.toStringAsFixed(2)}';
  }

  static String formatTax(double tax) {
    return formatCurrency(tax);
  }
}
