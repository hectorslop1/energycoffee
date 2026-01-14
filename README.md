# Energy Coffee ☕

Aplicación móvil para clientes de una cafetería, desarrollada en Flutter. Este proyecto forma parte de un sistema de dos aplicaciones:

1. **App Usuario** (este repositorio) - Para clientes de la cafetería
2. **App Meseros** - Para el personal de servicio

## 📋 Descripción

Aplicación móvil moderna e intuitiva que permite a los clientes de la cafetería realizar pedidos, dar seguimiento en tiempo real y gestionar sus pagos de forma ágil.

### Fase Actual
> **Desarrollo Local**: Utilizando **Hive** como base de datos local para simular el funcionamiento completo antes de la integración con backend remoto.

---

## 🎨 Diseño

### Estilo Visual
- **Estilo**: Limpio, moderno y visualmente atractivo
- **Plataformas**: iOS y Android

### Paleta de Colores

| Tipo | Color | Hex |
|------|-------|-----|
| **Primario** | 🟠 | `#C67C4E` |
| **Secundario** | 🟤 | `#4F2C1D` |
| **Fondo Primario** | ⬜ | `#F5F5F5` |
| **Fondo Secundario** | ⬜ | `#FFFFFF` |
| **Texto Primario** | ⬛ | `#2F2D2C` |
| **Texto Secundario** | 🔘 | `#A3A3A3` |
| **Texto Alt. Primario** | ⬜ | `#FFFFFF` |
| **Texto Alt. Secundario** | 🔘 | `#CDC3BF` |
| **Warning** | 🟡 | `#FACC15` |

### Gradiente Principal
```
#C67C4E (0%) → #885535 (32%) → #74482E (50%) → #603C26 (100%)
```

### Público Objetivo
Clientes de cafetería que requieren rapidez y claridad en el proceso de pedido.

---

## 📱 Flujo de Usuario

```
┌─────────────┐     ┌─────────┐     ┌──────────────┐     ┌────────┐
│ Splash/Login│ ──▶ │  Home   │ ──▶ │ Asignar Mesa │ ──▶ │  Menú  │
└─────────────┘     └────┬────┘     └──────────────┘     └───┬────┘
       │                 │                                    │
       │            ┌────┴────┐                          ┌────┴────┐
       │            │ Perfil  │                          │Producto │
       ▼            └─────────┘                          └────┬────┘
  [Geovalla]                                                  │
  Si está fuera                                          ┌────┴────┐
  del radio ──▶ ❌ Bloqueo                               │  Pago   │
                                                         └────┬────┘
                                                              │
                                                         ┌────┴────┐
                                                         │ Orden   │
                                                         │ Activa  │
                                                         └─────────┘
```

### 1. Acceso a la Aplicación

| Paso | Descripción |
|------|-------------|
| **1.1** | El usuario llega al establecimiento y abre la app |
| **1.2** | Se muestra la pantalla de **Login** |
| **1.3** | Opciones de autenticación: Correo/Teléfono + Contraseña, Biométrico, o Crear cuenta |
| **1.4** | **Validación de Geovalla**: Si el usuario está fuera del radio de coordenadas permitido, no puede avanzar más allá del login |

### 2. Home y Navegación Principal

| Elemento | Descripción |
|----------|-------------|
| **Home** | Pantalla principal con información diversa del establecimiento |
| **Menú de navegación** | 3 opciones: Home, Perfil/Usuario, Asignar Mesa |

### 3. Asignación de Mesa

| Paso | Descripción |
|------|-------------|
| **3.1** | El usuario accede a "Asignar Mesa" |
| **3.2** | Escanea el código QR de la mesa **o** ingresa el número manualmente |
| **3.3** | Una vez asignada, se desbloquea el acceso al menú |

### 4. Menú y Categorías

| Categoría | Descripción |
|-----------|-------------|
| **⭐ Star** | Productos estrella definidos por el establecimiento |
| **🔥 Hot** | Los más pedidos por todos los usuarios |
| **❤️ Loved** | Productos marcados como favoritos por el usuario actual |
| **📋 All** | Todos los productos disponibles |
| **Categorías específicas** | Capuccinos, Espressos, Lattes, Sandwiches, etc. |

**Opciones de ordenamiento**: Por votación, por precio, etc.

### 5. Personalización de Producto

| Elemento | Descripción |
|----------|-------------|
| **Información** | Imagen, descripción, precio |
| **Cantidad** | Número de unidades deseadas |
| **Tamaño** | Selección de tamaño disponible |
| **Personalizaciones cuantificables** | Cantidad de: azúcar, stevia, shots de espresso, etc. (valores numéricos) |
| **Personalizaciones de selección única** | Tipo de leche: Regular, Deslactosada, Almendras, Sin leche, etc. |
| **Notas adicionales** | Campo de texto libre para instrucciones especiales |

### 6. Pago

| Elemento | Descripción |
|----------|-------------|
| **Subtotal** | Suma de productos con opción de ver desglose |
| **Propina** | Opciones de propina |
| **Método de pago** | Efectivo, Tarjeta, PayPal, etc. |

### 7. Orden Activa (Seguimiento en Tiempo Real)

| Elemento | Descripción |
|----------|-------------|
| **Número de orden** | Identificador único |
| **Hora de inicio** | Timestamp de cuando se realizó el pedido |
| **Tiempo estimado** | Tiempo aproximado para finalización |
| **Progreso general** | Porcentaje de avance de la orden completa |
| **Lista de productos** | Cada producto con su estado de preparación individual |
| **Modificar producto** | Disponible solo si el producto aún no está siendo preparado |
| **Estado final** | Se marca como "Terminada" cuando todos los productos son entregados |

---

## 🖥️ Pantallas del Sistema

### Estado de Desarrollo

| # | Pantalla | Categoría | Diseño | Código | Estado |
|---|----------|-----------|--------|--------|--------|
| 1 | **Splash Screen** | Autenticación | ✅ | ✅ | Completado |
| 2 | **Login** | Autenticación | ✅ | ✅ | Completado |
| 3 | **Registro** | Autenticación | ❌ | ❌ | Pendiente |
| 4 | **Validación Geovalla** | Autenticación | ✅ | ✅ | Completado |
| 5 | **Home** | Navegación | ✅ | ✅ | Completado |
| 6 | **Perfil** | Navegación | ✅ | ⏳ | Pendiente |
| 7 | **Asignar Mesa (QR)** | Navegación | ✅ | ✅ | Completado |
| 8 | **Menú** | Pedido | ✅ | ✅ | Completado |
| 9 | **Detalle de Producto** | Pedido | ✅ | ✅ | Completado |
| 10 | **Carrito** | Pedido | ✅ | ✅ | Completado |
| 11 | **Editar Item Carrito** | Pedido | ✅ | ✅ | Completado |
| 12 | **Checkout/Pago** | Pedido | ✅ | ✅ | Completado |
| 13 | **Orden Activa** | Pedido | ✅ | ✅ | Completado |
| 14 | **Orden Completada** | Pedido | ✅ | ⏳ | Pendiente |
| 15 | **Configuración** | Perfil | ✅ | ⏳ | Pendiente |

**Leyenda:**
- ✅ Completado
- ⏳ Pendiente
- ❌ No iniciado

---

### A. Autenticación y Acceso

| Pantalla | Descripción |
|----------|-------------|
| **Splash Screen** | Carga inicial de la aplicación |
| **Login** | Correo/Teléfono + Contraseña, Biométrico |
| **Registro** | Creación de nueva cuenta |
| **Alerta Geovalla** | Bloqueo si está fuera del área permitida |

### B. Navegación Principal

| Pantalla | Descripción |
|----------|-------------|
| **Home** | Información del establecimiento, promociones |
| **Perfil** | Datos del usuario, historial, métodos de pago |
| **Asignar Mesa** | Escáner QR + input manual |

### C. Pedido

| Pantalla | Descripción |
|----------|-------------|
| **Menú** | Categorías y listado de productos |
| **Detalle de Producto** | Personalización completa del producto |
| **Pago** | Propina, método de pago, confirmación |
| **Orden Activa** | Seguimiento en tiempo real |
| **Orden Completada** | Resumen final y agradecimiento |

---

## ✨ Funcionalidades Implementadas

### 🎯 Sistema de Personalización de Productos

- **Tipos de personalización soportados:**
  - `singleChoice`: Selección única (ej: tipo de leche)
  - `multipleChoice`: Selección múltiple con límites opcionales (ej: toppings)
  - `toggle`: Activar/desactivar opciones (ej: sin azúcar)
  - `quantity`: Cantidad numérica (ej: shots de espresso)

- **Características:**
  - Sistema genérico y flexible
  - Validación de selecciones requeridas
  - Cálculo automático de precios con extras
  - Grupos de personalización ordenados por tipo
  - UI unificada para todos los tipos

### 🛒 Sistema de Carrito

- **Gestión de items:**
  - Agregar productos con personalizaciones
  - Editar cantidades y personalizaciones
  - Eliminar items con swipe gesture
  - Detección de items duplicados con mismas personalizaciones

- **Visualización:**
  - Resumen de personalizaciones con "Ver más/menos"
  - Precio unitario y total por item
  - Subtotal, impuestos y total general
  - Contador de items en badge del carrito

### 💳 Sistema de Checkout

- **Métodos de pago:**
  - Efectivo con validación y cálculo de cambio
  - Tarjeta (App)
  - Terminal físico
  - PayPal

- **Sistema de propinas:**
  - Monto fijo personalizable
  - Porcentaje (10%, 15%, 20%)
  - Sin propina
  - Validación de entrada

- **Características especiales:**
  - Redondeo automático del total para pagos en efectivo
  - Visualización del concepto de redondeo en resumen
  - Validación de efectivo suficiente
  - Campo de notas especiales para el pedido
  - Resumen detallado con desglose de precios

### 📊 Seguimiento de Orden Activa

- **Timeline visual:**
  - Estados: Recibido → Preparación → Listo
  - Animación de pulso en estado activo
  - Iconos y colores por estado
  - Tiempo estimado de preparación

- **Seguimiento por producto:**
  - Estado individual de cada item
  - Barra de progreso visual (0%, 50%, 100%)
  - Colores dinámicos según estado
  - Personalización legible de cada producto

- **Simulación:**
  - Cambio automático de estados cada 3 segundos
  - Progresión realista del proceso
  - Actualización en tiempo real de la UI

### 🗺️ Sistema de Geolocalización

- **Validación de ubicación:**
  - Verificación de permisos de ubicación
  - Cálculo de distancia al establecimiento
  - Bloqueo si está fuera del radio permitido
  - Mensajes de error claros y acciones sugeridas

### 📱 Asignación de Mesa

- **Métodos de asignación:**
  - Escaneo de código QR
  - Entrada manual de número de mesa
  - Validación de mesa válida

- **Persistencia:**
  - Número de mesa visible en todas las pantallas
  - Almacenado en CartProvider
  - Transferido a la orden al confirmar

### 🎨 UI/UX

- **Diseño consistente:**
  - Paleta de colores unificada
  - Gradientes en elementos principales
  - Animaciones suaves y feedback visual
  - AppBars con formato idéntico

- **Características especiales:**
  - Marquee para textos largos
  - Texto expandible con "Ver más/menos"
  - Bordes redondeados y sombras
  - Estados visuales claros (loading, error, success)

### 🔧 Sistema de Impuestos

- **Configuración flexible:**
  - Activar/desactivar impuestos
  - Tasa de impuesto configurable
  - Etiqueta personalizable
  - Cálculo automático en carrito y checkout

---

## 🔧 Requisitos Técnicos

| Componente | Tecnología/Funcionalidad |
|------------|--------------------------|
| **Base de Datos Local** | Hive (simulación) |
| **RealTime** | Actualización de estado de productos en orden activa |
| **Autenticación** | Biométrica (huella dactilar) |
| **Pagos** | PayPal, Registro de Tarjeta |
| **Hardware** | Lector de QR para asignación de mesa |

---

## 📦 Estructura del Proyecto

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── validators.dart
└── features/
    ├── auth/
    │   ├── models/
    │   │   └── user_model.dart
    │   ├── providers/
    │   │   └── auth_provider.dart
    │   └── pages/
    │       └── login/
    │           ├── login_page.dart
    │           └── widgets/
    │               ├── login_header.dart
    │               └── login_form.dart
    ├── home/
    │   ├── models/
    │   ├── providers/
    │   └── pages/
    │       └── home/
    ├── table/
    │   ├── models/
    │   ├── providers/
    │   └── pages/
    │       └── assign_table/
    ├── menu/
    │   ├── models/
    │   ├── providers/
    │   └── pages/
    │       ├── menu/
    │       └── product_detail/
    ├── order/
    │   ├── models/
    │   ├── providers/
    │   └── pages/
    │       ├── payment/
    │       └── active_order/
    ├── profile/
    │   ├── models/
    │   ├── providers/
    │   └── pages/
    │       └── profile/
    └── location/
        └── providers/
```

---

## 🚀 Instalación

```bash
# Clonar repositorio
git clone <repository-url>

# Instalar dependencias
flutter pub get

# Ejecutar aplicación
flutter run
```

---

## 📊 Entregables del Diseño

- [ ] Wireframes de baja fidelidad (11 pantallas)
- [ ] Mockups de alta fidelidad (UI)
- [ ] Prototipo de interacción (UX)

---

## 🖼️ Pantallas de Ejemplo

Ubicación: `assets/examples/`

| Pantalla | Archivo | Estado |
|----------|---------|--------|
| Splash Screen | `splash_screen.png` | ✅ |
| Validación de Ubicación | `location_validation.png` | ✅ |
| Login | `login.png` | ✅ |
| Escaneo QR (Mesa) | `qr_scan.png` | ✅ |
| Menú | `menu.png` | ✅ |
| Orden Activa | `active_order.png` | ✅ |
| Pago | `payment.png` | ✅ |
| Orden Pagada | `payed.png` | ✅ |
| Perfil de Usuario | `user_profile.png` | ✅ |
| Configuración | `configuration.png` | ✅ |

---

## 📝 Notas de Desarrollo

- La aplicación utiliza **Hive** para persistencia local durante la fase de desarrollo
- El flujo de geovalla requiere permisos de ubicación
- La autenticación biométrica es opcional y configurable por el usuario
- El cálculo de cambio en efectivo se realiza automáticamente

---

## 📄 Licencia

Proyecto privado - Energy Coffee
