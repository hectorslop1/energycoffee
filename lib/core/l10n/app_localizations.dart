import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // App
  String get appName;

  // Auth
  String get login;
  String get register;
  String get email;
  String get phone;
  String get password;
  String get rememberMe;
  String get forgotPassword;
  String get biometricLogin;
  String get welcomeBack;
  String get continueWithEmail;
  String get continueWithPhone;
  String get orContinueWith;

  // Location
  String get locationRequired;
  String get outsideArea;
  String get enableLocation;
  String get locationPermissionRequired;

  // Home
  String get home;
  String get profile;
  String get assignTable;
  String get welcomeMessage;
  String get findYourFavorite;

  // Menu
  String get menu;
  String get star;
  String get hot;
  String get loved;
  String get all;
  String get search;
  String get categories;

  // Product
  String get addToOrder;
  String get customize;
  String get quantity;
  String get size;
  String get notes;
  String get small;
  String get medium;
  String get large;
  String get extraLarge;

  // Cart
  String get cart;
  String get emptyCart;
  String get addItems;
  String get checkout;
  String get removeItem;

  // Payment
  String get payment;
  String get subtotal;
  String get tip;
  String get total;
  String get pay;
  String get paymentMethod;
  String get addCard;
  String get confirmPayment;

  // Order
  String get activeOrder;
  String get orderNumber;
  String get estimatedTime;
  String get orderCompleted;
  String get orderHistory;
  String get reorder;
  String get trackOrder;

  // Settings
  String get settings;
  String get general;
  String get theme;
  String get lightMode;
  String get darkMode;
  String get systemMode;
  String get language;
  String get notifications;
  String get manageNotifications;
  String get security;
  String get biometricLoginSetting;
  String get biometricLoginDescription;
  String get notAvailable;
  String get account;
  String get editProfile;
  String get paymentMethods;
  String get manageCards;
  String get history;
  String get viewOrderHistory;
  String get support;
  String get help;
  String get faq;
  String get about;
  String get version;
  String get privacy;
  String get privacyPolicy;
  String get session;
  String get logout;
  String get logoutConfirm;
  String get cancel;
  String get confirm;
  String get demoMode;
  String get useDemoData;
  String get appearance;
  String get preferences;
  String get information;
  String get visualTheme;

  // Greetings
  String get goodMorning;
  String get goodAfternoon;
  String get goodEvening;

  // Search
  String get searchCoffee;

  // Help
  String get helpCenter;
  String get comingSoon;

  // Coffee Builder
  String get coffeeBuilder;
  String get buildYourCoffee;
  String get selectBase;
  String get selectSize;
  String get addExtras;
  String get milkType;
  String get shots;
  String get temperature;
  String get sweetness;
  String get toppings;

  // Common
  String get save;
  String get delete;
  String get edit;
  String get done;
  String get next;
  String get back;
  String get skip;
  String get loading;
  String get error;
  String get retry;
  String get success;
  String get warning;
  String get yes;
  String get no;
  String get close;
  String get apply;
  String get clear;
  String get viewMore;
  String get viewLess;
  String get each;

  // Auth Extended
  String get invalidCredentials;
  String get biometricAuthFailed;
  String get authenticating;
  String get useBiometric;
  String get dontHaveAccount;
  String get pleaseEnterEmail;
  String get pleaseEnterPassword;
  String get enterValidEmail;
  String get passwordMinLength;

  // Home Extended
  String get hello;
  String get enjoyFavoriteCoffee;
  String get quickActions;
  String get promotions;
  String get recentOrders;
  String get viewMenu;
  String get scanQR;
  String get myOrders;

  // Cart Extended
  String get myCart;
  String get table;
  String get emptyCartMessage;
  String get addProductsFromMenu;
  String get proceedToPayment;
  String get clearCart;
  String get clearCartConfirm;
  String get itemRemoved;
  String get specialInstructions;
  String get pricePerUnit;

  // Checkout Extended
  String get orderSummary;
  String get deliveryInfo;
  String get tableNumber;
  String get customerName;
  String get phoneNumber;
  String get paymentInfo;
  String get cardNumber;
  String get expiryDate;
  String get cvv;
  String get tipAmount;
  String get noTip;
  String get customTip;
  String get placeOrder;
  String get processing;
  String get orderPlaced;
  String get thankYou;
  String get orderConfirmed;
  String get preparingOrder;
  String get estimatedTimeMinutes;
  String get viewOrderDetails;
  String get continueShopping;

  // Product Extended
  String get selectYourSize;
  String get addToCart;
  String get updateCart;
  String get productDetails;
  String get ingredients;
  String get nutritionInfo;
  String get calories;
  String get customizeYourDrink;

  // Coffee Builder Extended
  String get selectYourCoffee;
  String get sweetener;
  String get selectAll;
  String get iced;
  String get espresso;
  String get milk;
  String get syrup;
  String get whippedCream;
  String get extraShot;
  String get sugarLevel;
  String get iceLevel;
  String get none;
  String get light;
  String get regular;
  String get extra;

  // Order Extended
  String get orderStatus;
  String get pending;
  String get preparing;
  String get ready;
  String get delivered;
  String get cancelled;
  String get orderDetails;
  String get items;
  String get orderDate;
  String get orderTime;
  String get totalAmount;
  String get paymentStatus;
  String get paid;
  String get unpaid;
  String get cancelOrder;
  String get cancelOrderConfirm;
  String get repeatOrder;
  String get noOrders;
  String get noActiveOrders;
  String get startOrdering;

  // Profile Extended
  String get myProfile;
  String get personalInfo;
  String get name;
  String get emailAddress;
  String get phoneNum;
  String get address;
  String get editInfo;
  String get changePassword;
  String get currentPassword;
  String get newPassword;
  String get confirmPassword;
  String get saveChanges;
  String get discardChanges;

  // Errors & Validation
  String get requiredField;
  String get invalidEmail;
  String get invalidPhone;
  String get passwordMismatch;
  String get somethingWentWrong;
  String get tryAgain;
  String get noInternetConnection;
  String get serverError;
  String get sessionExpired;
  String get pleaseLoginAgain;

  // Location Extended
  String get selectLocation;
  String get currentLocation;
  String get searchLocation;
  String get nearbyStores;
  String get storeDetails;
  String get openNow;
  String get closed;
  String get openingHours;
  String get getDirections;

  // Onboarding
  String get welcome;
  String get getStarted;
  String get onboardingTitle1;
  String get onboardingDesc1;
  String get onboardingTitle2;
  String get onboardingDesc2;
  String get onboardingTitle3;
  String get onboardingDesc3;

  // Biometric Extended
  String get enableBiometricTitle;
  String get enableBiometricMessageIOS;
  String get enableBiometricMessageAndroid;
  String get loginWithFaceID;
  String get loginWithFingerprint;

  // Product Customization - Bread Types
  String get selectBreadType;
  String get whiteBread;
  String get wheatBread;
  String get multigrain;
  String get sourdough;
  String get ciabatta;

  // Product Customization - Vegetables
  String get selectVegetables;
  String get selectMultipleOptions;
  String get lettuce;
  String get tomato;
  String get onion;
  String get cucumber;
  String get pickles;
  String get peppers;
  String get avocado;

  // Product Customization - Heating Options
  String get heatingPreference;
  String get coldOption;
  String get warmOption;
  String get hotOption;

  // Product Customization - Quantity
  String get selectQuantity;
  String get unitPrice;

  // Coffee Types
  String get coffeeEspresso;
  String get coffeeAmericano;
  String get coffeeLatte;
  String get coffeeCappuccino;
  String get coffeeMocha;
  String get coffeeFlatWhite;
  String get coffeeMacchiato;
  String get coffeeColdBrew;

  // Coffee Sizes
  String get sizeSmall;
  String get sizeMedium;
  String get sizeLarge;
  String get sizeExtraLarge;

  // Milk Types
  String get noMilk;
  String get wholeMilk;
  String get skimMilk;
  String get almondMilk;
  String get oatMilk;
  String get soyMilk;
  String get coconutMilk;

  // Sweeteners
  String get noSweetener;
  String get sugar;
  String get honey;
  String get stevia;
  String get agave;
  String get vanilla;
  String get caramel;
  String get hazelnut;

  // Temperatures
  String get tempIced;
  String get tempWarm;
  String get tempHot;
  String get tempExtraHot;

  // Toppings
  String get toppingWhippedCream;
  String get toppingCinnamon;
  String get toppingCocoa;
  String get toppingCaramelDrizzle;
  String get toppingChocolateChips;
  String get toppingNutmeg;
  String get toppingMarshmallows;

  // Coffee Selector Labels
  String get selectYourCoffeeType;
  String get selectTemperature;
  String get selectMilkType;
  String get selectSweetener;
  String get selectToppings;
  String get sweetenerLevel;
}
