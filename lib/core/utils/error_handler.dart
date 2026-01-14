import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class ErrorHandler {
  // Show error dialog
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textAltPrimary,
              ),
              child: const Text('Reintentar'),
            ),
        ],
      ),
    );
  }

  // Show error snackbar
  static void showErrorSnackbar(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    CustomSnackbar.show(
      context,
      message: message,
      type: SnackbarType.error,
    );
  }

  // Handle network errors
  static String getNetworkErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'Sin conexión a internet. Verifica tu conexión.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'La conexión tardó demasiado. Intenta de nuevo.';
    } else if (error.toString().contains('FormatException')) {
      return 'Error al procesar los datos. Intenta de nuevo.';
    }
    return 'Ocurrió un error. Por favor intenta de nuevo.';
  }

  // Handle API errors
  static String getApiErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Solicitud inválida. Verifica los datos.';
      case 401:
        return 'No autorizado. Inicia sesión de nuevo.';
      case 403:
        return 'Acceso denegado.';
      case 404:
        return 'Recurso no encontrado.';
      case 500:
        return 'Error del servidor. Intenta más tarde.';
      case 503:
        return 'Servicio no disponible. Intenta más tarde.';
      default:
        return 'Error desconocido. Intenta de nuevo.';
    }
  }

  // Log error (for debugging)
  static void logError(String context, dynamic error,
      [StackTrace? stackTrace]) {
    debugPrint('❌ Error in $context: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }

  // Show loading error state
  static Widget buildErrorState({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textAltPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
