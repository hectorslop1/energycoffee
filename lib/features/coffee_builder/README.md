# Coffee Builder System

Sistema modular e interactivo para construir cafés personalizados, inspirado en el Domino's Pizza Builder.

## 🏗️ Arquitectura

### 1. **Modelo de Dominio** (`domain/`)
- **Inmutable**: Todos los modelos usan `final` y `copyWith`
- **Enums exhaustivos**: Cada enum tiene propiedades de negocio y UI
- **Sin dependencias de UI**: Lógica pura de negocio

```dart
// Ejemplo de uso
final coffee = Coffee.defaultCoffee();
final updated = coffee.copyWith(size: CoffeeSize.large);
```

### 2. **Estado Central** (`state/`)
- **Provider**: Gestión de estado reactiva
- **Single source of truth**: Un único estado para todo el builder
- **Métodos específicos**: Cada cambio tiene su método dedicado

```dart
// Uso del estado
context.read<CoffeeBuilderState>().updateCoffeeType(CoffeeType.latte);
context.read<CoffeeBuilderState>().updateSize(CoffeeSize.large);
```

### 3. **Preview Visual** (`presentation/widgets/coffee_preview/`)
- **Renderizado por capas**: Stack con múltiples CustomPainters
- **Reactivo al estado**: Cambia automáticamente con el estado
- **Animaciones fluidas**: Transiciones suaves entre cambios

**Capas:**
- `CupLayer`: Taza base (cambia con tamaño y temperatura)
- `LiquidLayer`: Líquido del café (color según tipo y leche)
- `FoamLayer`: Espuma (varía según tipo de café)
- `ToppingsLayer`: Toppings visuales (crema, caramelo, etc.)
- `SteamLayer`: Vapor animado (solo cafés calientes)

### 4. **Selectores** (`presentation/widgets/selectors/`)
Widgets modulares y reutilizables, uno por decisión:

- `CoffeeTypeSelector`: Selección del tipo de café
- `SizeSelector`: Tamaño del café
- `TemperatureSelector`: Temperatura
- `MilkSelector`: Tipo de leche
- `SweetenerSelector`: Endulzante + nivel
- `ToppingsSelector`: Múltiples toppings

### 5. **Flujo Paso a Paso** (`presentation/pages/`)
- **PageView**: Navegación fluida entre pasos
- **Indicador de progreso**: Barra visual del paso actual
- **Navegación controlada**: Botones Atrás/Siguiente
- **Precio en tiempo real**: Actualización automática

### 6. **Animaciones Reactivas**
- **flutter_animate**: Animaciones declarativas
- **Triggers automáticos**: Reaccionan a cambios de estado
- **No manuales**: Sin controladores explícitos

## 🚀 Integración

### Opción 1: Standalone (Demo)
```dart
void main() {
  runApp(const CoffeeBuilderExample());
}
```

### Opción 2: Dentro de tu app existente
```dart
// En tu página de menú o donde quieras abrir el builder
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChangeNotifierProvider(
      create: (_) => CoffeeBuilderState(),
      child: const CoffeeBuilderPage(),
    ),
  ),
).then((coffee) {
  if (coffee != null) {
    // Agregar el café al carrito
    cartProvider.addItem(coffee);
  }
});
```

### Opción 3: Con Provider global
```dart
// En tu main.dart
MultiProvider(
  providers: [
    // ... otros providers
    ChangeNotifierProvider(create: (_) => CoffeeBuilderState()),
  ],
  child: MyApp(),
)

// Luego solo navega
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const CoffeeBuilderPage()),
);
```

## 📁 Estructura de Archivos

```
lib/features/coffee_builder/
├── domain/
│   ├── models/
│   │   └── coffee.dart
│   └── enums/
│       ├── coffee_size.dart
│       ├── coffee_type.dart
│       ├── milk_type.dart
│       ├── sweetener_type.dart
│       ├── topping_type.dart
│       └── temperature.dart
├── state/
│   └── coffee_builder_state.dart
├── presentation/
│   ├── pages/
│   │   └── coffee_builder_page.dart
│   └── widgets/
│       ├── coffee_preview/
│       │   ├── coffee_preview.dart
│       │   ├── animated_coffee_preview.dart
│       │   └── layers/
│       │       ├── cup_layer.dart
│       │       ├── liquid_layer.dart
│       │       ├── foam_layer.dart
│       │       ├── toppings_layer.dart
│       │       └── steam_layer.dart
│       └── selectors/
│           ├── coffee_type_selector.dart
│           ├── size_selector.dart
│           ├── temperature_selector.dart
│           ├── milk_selector.dart
│           ├── sweetener_selector.dart
│           └── toppings_selector.dart
├── coffee_builder_example.dart
└── README.md
```

## 🎨 Personalización

### Cambiar colores del tema
```dart
// En cualquier selector, busca:
const Color(0xFF6D4C41) // Color principal café
// Y reemplázalo por tu color de marca
```

### Agregar nuevos tipos de café
```dart
// 1. Agregar en coffee_type.dart
enum CoffeeType {
  // ... existentes
  cortado,
}

// 2. Agregar propiedades
case CoffeeType.cortado:
  return 'Cortado';
```

### Modificar precios
```dart
// En cada enum, ajusta los métodos:
double get basePrice { ... }
double get additionalPrice { ... }
double get priceMultiplier { ... }
```

## 🔄 Escalabilidad

### Para agregar otras bebidas (té, smoothies, etc.)

1. **Crear nuevo modelo** siguiendo el patrón de `Coffee`
2. **Reutilizar selectores** (muchos son genéricos)
3. **Crear preview específico** con sus propias capas
4. **Usar el mismo estado pattern** con Provider

### Ejemplo: Tea Builder
```dart
class Tea {
  final TeaType type;
  final Temperature temperature;
  final SweetenerType sweetener;
  // ...
}

class TeaBuilderState extends ChangeNotifier {
  Tea _currentTea = Tea.defaultTea();
  // Similar a CoffeeBuilderState
}
```

## 🧪 Testing

```dart
// Test del modelo
test('Coffee calculates price correctly', () {
  final coffee = Coffee(
    type: CoffeeType.latte,
    size: CoffeeSize.medium,
    temperature: Temperature.hot,
  );
  expect(coffee.calculatePrice(), 5.2); // 4.0 * 1.3
});

// Test del estado
test('State updates coffee type', () {
  final state = CoffeeBuilderState();
  state.updateCoffeeType(CoffeeType.espresso);
  expect(state.currentCoffee.type, CoffeeType.espresso);
});
```

## 📝 Mejoras Futuras

1. **Persistencia**: Guardar cafés favoritos con SharedPreferences
2. **Compartir**: Generar link para compartir configuración
3. **Recomendaciones**: Sugerir combinaciones populares
4. **Modo oscuro**: Adaptar colores automáticamente
5. **Accesibilidad**: Mejorar labels para screen readers
6. **Internacionalización**: Soporte multi-idioma con i18n
7. **Animaciones avanzadas**: Lottie para transiciones más complejas
8. **AR Preview**: Vista en realidad aumentada del café

## 🐛 Troubleshooting

**Error: "Provider not found"**
```dart
// Asegúrate de envolver con ChangeNotifierProvider
ChangeNotifierProvider(
  create: (_) => CoffeeBuilderState(),
  child: const CoffeeBuilderPage(),
)
```

**Preview no se actualiza**
```dart
// Usa Consumer o context.watch
Consumer<CoffeeBuilderState>(
  builder: (context, state, child) {
    return YourWidget(coffee: state.currentCoffee);
  },
)
```

**Animaciones no funcionan**
```dart
// Verifica que flutter_animate esté en pubspec.yaml
dependencies:
  flutter_animate: ^4.5.0
```

## 📄 Licencia

Este código es parte del proyecto Energy Coffee y sigue las mismas políticas de licencia del proyecto principal.
