import 'package:flutter/foundation.dart';
import '../domain/models/coffee.dart';
import '../domain/enums/coffee_size.dart';
import '../domain/enums/coffee_type.dart';
import '../domain/enums/milk_type.dart';
import '../domain/enums/sweetener_type.dart';
import '../domain/enums/temperature.dart';
import '../domain/enums/topping_type.dart';
import '../domain/enums/product_category.dart';
import '../domain/enums/bread_type.dart';
import '../domain/enums/vegetable_type.dart';
import '../domain/enums/heating_option.dart';

class CoffeeBuilderState extends ChangeNotifier {
  Coffee _currentCoffee = Coffee.defaultCoffee();
  int _currentStep = 0;
  String? _productImagePath;
  bool _isFromProductSelection = false;
  ProductCategory _productCategory = ProductCategory.coffee;
  String _productName = '';
  double _basePrice = 0.0;

  BreadType _breadType = BreadType.white;
  List<VegetableType> _vegetables = [];
  HeatingOption _heatingOption = HeatingOption.cold;
  int _quantity = 1;

  Coffee get currentCoffee => _currentCoffee;
  int get currentStep => _currentStep;
  int get totalSteps {
    if (!_isFromProductSelection) return 6;
    switch (_productCategory) {
      case ProductCategory.coffee:
        return 5;
      case ProductCategory.bakery:
        return 1;
      case ProductCategory.sandwiches:
        return 2;
      case ProductCategory.extras:
        return 1;
    }
  }

  String? get productImagePath => _productImagePath;
  bool get isFromProductSelection => _isFromProductSelection;
  ProductCategory get productCategory => _productCategory;
  String get productName => _productName;
  double get basePrice => _basePrice;
  BreadType get breadType => _breadType;
  List<VegetableType> get vegetables => _vegetables;
  HeatingOption get heatingOption => _heatingOption;
  int get quantity => _quantity;

  bool get canProceed => _currentCoffee.isValid;
  double get totalPrice {
    switch (_productCategory) {
      case ProductCategory.coffee:
        return _currentCoffee.calculatePrice();
      case ProductCategory.bakery:
        return _basePrice * _quantity;
      case ProductCategory.sandwiches:
        double price = _basePrice;
        price += _breadType.priceModifier;
        for (var veg in _vegetables) {
          price += veg.priceModifier;
        }
        return price * _quantity;
      case ProductCategory.extras:
        return _basePrice * _quantity;
    }
  }

  void updateCoffeeType(CoffeeType type) {
    _currentCoffee = _currentCoffee.copyWith(type: type);

    if (!type.requiresMilk && _currentCoffee.milkType != MilkType.none) {
      _currentCoffee = _currentCoffee.copyWith(milkType: MilkType.none);
    }

    notifyListeners();
  }

  void updateSize(CoffeeSize size) {
    _currentCoffee = _currentCoffee.copyWith(size: size);
    notifyListeners();
  }

  void updateTemperature(Temperature temperature) {
    _currentCoffee = _currentCoffee.copyWith(temperature: temperature);
    notifyListeners();
  }

  void updateMilkType(MilkType milkType) {
    _currentCoffee = _currentCoffee.copyWith(milkType: milkType);
    notifyListeners();
  }

  void updateSweetener(SweetenerType sweetenerType, int level) {
    _currentCoffee = _currentCoffee.copyWith(
      sweetenerType: sweetenerType,
      sweetenerLevel: level,
    );
    notifyListeners();
  }

  void updateEspressoShots(int shots) {
    _currentCoffee = _currentCoffee.copyWith(espressoShots: shots);
    notifyListeners();
  }

  void toggleTopping(ToppingType topping) {
    final currentToppings = List<ToppingType>.from(_currentCoffee.toppings);

    if (currentToppings.contains(topping)) {
      currentToppings.remove(topping);
    } else {
      currentToppings.add(topping);
    }

    _currentCoffee = _currentCoffee.copyWith(toppings: currentToppings);
    notifyListeners();
  }

  void updateSpecialInstructions(String? instructions) {
    _currentCoffee = _currentCoffee.copyWith(specialInstructions: instructions);
    notifyListeners();
  }

  void updateBreadType(BreadType breadType) {
    _breadType = breadType;
    notifyListeners();
  }

  void toggleVegetable(VegetableType vegetable) {
    if (_vegetables.contains(vegetable)) {
      _vegetables.remove(vegetable);
    } else {
      _vegetables.add(vegetable);
    }
    notifyListeners();
  }

  void updateHeatingOption(HeatingOption option) {
    _heatingOption = option;
    notifyListeners();
  }

  void updateQuantity(int quantity) {
    if (quantity > 0) {
      _quantity = quantity;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  void reset() {
    _currentCoffee = Coffee.defaultCoffee();
    _currentStep = 0;
    _productImagePath = null;
    _isFromProductSelection = false;
    _productCategory = ProductCategory.coffee;
    _productName = '';
    _basePrice = 0.0;
    _breadType = BreadType.white;
    _vegetables = [];
    _heatingOption = HeatingOption.cold;
    _quantity = 1;
    notifyListeners();
  }

  void initializeWithProduct(CoffeeType coffeeType, String imagePath) {
    _currentCoffee = Coffee(
      type: coffeeType,
      size: CoffeeSize.medium,
      temperature: Temperature.hot,
      milkType: coffeeType.requiresMilk ? MilkType.whole : MilkType.none,
      sweetenerType: SweetenerType.none,
      sweetenerLevel: 0,
      toppings: const [],
      espressoShots: 2,
    );
    _productImagePath = imagePath;
    _isFromProductSelection = true;
    _productCategory = ProductCategory.coffee;
    _currentStep = 0;
    notifyListeners();
  }

  void initializeWithProductCategory({
    required ProductCategory category,
    required String productName,
    required double basePrice,
    required String imagePath,
  }) {
    _productCategory = category;
    _productName = productName;
    _basePrice = basePrice;
    _productImagePath = imagePath;
    _isFromProductSelection = true;
    _currentStep = 0;
    _breadType = BreadType.white;
    _vegetables = [];
    _heatingOption = HeatingOption.cold;
    _quantity = 1;
    notifyListeners();
  }

  Coffee buildCoffee() {
    return _currentCoffee;
  }
}
