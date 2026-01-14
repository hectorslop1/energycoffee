enum ProductCategory {
  coffee,
  bakery,
  sandwiches,
  extras;

  String get displayName {
    switch (this) {
      case ProductCategory.coffee:
        return 'Coffee';
      case ProductCategory.bakery:
        return 'Bakery';
      case ProductCategory.sandwiches:
        return 'Sandwiches';
      case ProductCategory.extras:
        return 'Extras';
    }
  }
}
