import '../../coffee_builder/domain/enums/coffee_type.dart';

class CoffeeProduct {
  final String id;
  final String name;
  final String imagePath;
  final double basePrice;
  final double rating;
  final CoffeeType coffeeType;
  final String description;

  const CoffeeProduct({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.basePrice,
    required this.rating,
    required this.coffeeType,
    required this.description,
  });

  static List<CoffeeProduct> getFeaturedProducts() {
    return [
      const CoffeeProduct(
        id: 'cappuccino_1',
        name: 'Cappuccino',
        imagePath: 'assets/images/CoffeeExamples/Cappuccino.png',
        basePrice: 4.0,
        rating: 4.8,
        coffeeType: CoffeeType.cappuccino,
        description: 'Espresso con leche y espuma',
      ),
      const CoffeeProduct(
        id: 'latte_1',
        name: 'Latte',
        imagePath: 'assets/images/CoffeeExamples/Latte.png',
        basePrice: 4.0,
        rating: 4.9,
        coffeeType: CoffeeType.latte,
        description: 'Espresso con leche vaporizada',
      ),
      const CoffeeProduct(
        id: 'espresso_1',
        name: 'Espresso',
        imagePath: 'assets/images/CoffeeExamples/Espresso.png',
        basePrice: 2.5,
        rating: 4.7,
        coffeeType: CoffeeType.espresso,
        description: 'Café concentrado y fuerte',
      ),
    ];
  }
}
