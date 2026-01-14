import '../enums/coffee_size.dart';
import '../enums/coffee_type.dart';
import '../enums/milk_type.dart';
import '../enums/sweetener_type.dart';
import '../enums/temperature.dart';
import '../enums/topping_type.dart';

class Coffee {
  final CoffeeType type;
  final CoffeeSize size;
  final Temperature temperature;
  final MilkType milkType;
  final SweetenerType sweetenerType;
  final int sweetenerLevel;
  final List<ToppingType> toppings;
  final int espressoShots;
  final String? specialInstructions;

  const Coffee({
    required this.type,
    required this.size,
    required this.temperature,
    this.milkType = MilkType.none,
    this.sweetenerType = SweetenerType.none,
    this.sweetenerLevel = 0,
    this.toppings = const [],
    this.espressoShots = 1,
    this.specialInstructions,
  })  : assert(sweetenerLevel >= 0 && sweetenerLevel <= 5,
            'Sweetener level must be between 0 and 5'),
        assert(espressoShots >= 1 && espressoShots <= 4,
            'Espresso shots must be between 1 and 4');

  factory Coffee.defaultCoffee() {
    return const Coffee(
      type: CoffeeType.latte,
      size: CoffeeSize.medium,
      temperature: Temperature.hot,
      milkType: MilkType.whole,
      sweetenerType: SweetenerType.none,
      sweetenerLevel: 0,
      toppings: [],
      espressoShots: 2,
    );
  }

  Coffee copyWith({
    CoffeeType? type,
    CoffeeSize? size,
    Temperature? temperature,
    MilkType? milkType,
    SweetenerType? sweetenerType,
    int? sweetenerLevel,
    List<ToppingType>? toppings,
    int? espressoShots,
    String? specialInstructions,
  }) {
    return Coffee(
      type: type ?? this.type,
      size: size ?? this.size,
      temperature: temperature ?? this.temperature,
      milkType: milkType ?? this.milkType,
      sweetenerType: sweetenerType ?? this.sweetenerType,
      sweetenerLevel: sweetenerLevel ?? this.sweetenerLevel,
      toppings: toppings ?? this.toppings,
      espressoShots: espressoShots ?? this.espressoShots,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  double calculatePrice() {
    double price = type.basePrice;

    price *= size.priceMultiplier;

    price += milkType.additionalPrice;

    price += sweetenerType.additionalPrice;

    for (final topping in toppings) {
      price += topping.additionalPrice;
    }

    if (espressoShots > 2) {
      price += (espressoShots - 2) * 0.5;
    }

    return price;
  }

  bool get isValid {
    if (type.requiresMilk && milkType == MilkType.none) {
      return false;
    }

    if (sweetenerType != SweetenerType.none && sweetenerLevel == 0) {
      return false;
    }

    return true;
  }

  String get displayName {
    final buffer = StringBuffer();

    buffer.write(size.displayName);
    buffer.write(' ');
    buffer.write(type.displayName);

    if (temperature == Temperature.iced) {
      buffer.write(' Frío');
    }

    if (milkType != MilkType.none && milkType != MilkType.whole) {
      buffer.write(' con ${milkType.displayName}');
    }

    if (sweetenerType != SweetenerType.none) {
      buffer.write(' + ${sweetenerType.displayName}');
    }

    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'size': size.name,
      'temperature': temperature.name,
      'milkType': milkType.name,
      'sweetenerType': sweetenerType.name,
      'sweetenerLevel': sweetenerLevel,
      'toppings': toppings.map((t) => t.name).toList(),
      'espressoShots': espressoShots,
      'specialInstructions': specialInstructions,
      'price': calculatePrice(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coffee &&
        other.type == type &&
        other.size == size &&
        other.temperature == temperature &&
        other.milkType == milkType &&
        other.sweetenerType == sweetenerType &&
        other.sweetenerLevel == sweetenerLevel &&
        _listEquals(other.toppings, toppings) &&
        other.espressoShots == espressoShots &&
        other.specialInstructions == specialInstructions;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      size,
      temperature,
      milkType,
      sweetenerType,
      sweetenerLevel,
      Object.hashAll(toppings),
      espressoShots,
      specialInstructions,
    );
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
