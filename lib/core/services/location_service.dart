import 'package:geolocator/geolocator.dart';

/// Servicio para manejar la geolocalización y geovalla
class LocationService {
  // Coordenadas del establecimiento (cafetería)
  static const double _cafeLatitude = 32.46767134428074;
  static const double _cafeLongitude = -117.00459868887519;

  // Radio permitido en metros
  static const double _allowedRadiusMeters = 100.0;

  /// Verifica si los servicios de ubicación están habilitados
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Solicita permisos de ubicación
  Future<LocationPermission> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Verifica el estado del permiso
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Obtiene la posición actual del dispositivo
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }

  /// Calcula la distancia entre la ubicación actual y el establecimiento
  double calculateDistanceToStore(Position position) {
    return Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      _cafeLatitude,
      _cafeLongitude,
    );
  }

  /// Verifica si el usuario está dentro del área permitida
  Future<GeofenceResult> checkGeofence() async {
    // Verificar si el servicio de ubicación está habilitado
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return GeofenceResult(
        status: GeofenceStatus.serviceDisabled,
        message: 'El servicio de ubicación está desactivado',
      );
    }

    // Verificar permisos
    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return GeofenceResult(
        status: GeofenceStatus.permissionDenied,
        message: 'Permiso de ubicación denegado',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      return GeofenceResult(
        status: GeofenceStatus.permissionDeniedForever,
        message: 'Los permisos de ubicación están permanentemente denegados',
      );
    }

    // Obtener ubicación actual
    final position = await getCurrentPosition();
    if (position == null) {
      return GeofenceResult(
        status: GeofenceStatus.locationError,
        message: 'No se pudo obtener la ubicación',
      );
    }

    // Calcular distancia al establecimiento
    final distance = calculateDistanceToStore(position);

    if (distance <= _allowedRadiusMeters) {
      return GeofenceResult(
        status: GeofenceStatus.insideArea,
        message: '¡Estás dentro del área de servicio!',
        distanceMeters: distance,
        position: position,
      );
    } else {
      return GeofenceResult(
        status: GeofenceStatus.outsideArea,
        message: 'Te encuentras fuera del área de servicio',
        distanceMeters: distance,
        position: position,
      );
    }
  }

  /// Obtiene las coordenadas del establecimiento
  static (double lat, double lng) get storeCoordinates => (_cafeLatitude, _cafeLongitude);

  /// Obtiene el radio permitido
  static double get allowedRadius => _allowedRadiusMeters;
}

/// Estado del resultado de la geovalla
enum GeofenceStatus {
  insideArea,
  outsideArea,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  locationError,
}

/// Resultado de la verificación de geovalla
class GeofenceResult {
  final GeofenceStatus status;
  final String message;
  final double? distanceMeters;
  final Position? position;

  GeofenceResult({
    required this.status,
    required this.message,
    this.distanceMeters,
    this.position,
  });

  bool get isInsideArea => status == GeofenceStatus.insideArea;
  bool get hasError => status != GeofenceStatus.insideArea && status != GeofenceStatus.outsideArea;
}
