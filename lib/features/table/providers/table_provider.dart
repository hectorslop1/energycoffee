import 'package:flutter/foundation.dart';
import '../models/table_model.dart';

class TableProvider extends ChangeNotifier {
  TableModel? _currentTable;
  bool _isScanning = false;
  String? _error;

  TableModel? get currentTable => _currentTable;
  bool get isScanning => _isScanning;
  bool get hasTable => _currentTable != null;
  String? get error => _error;

  Future<bool> assignTableByQR(String qrData) async {
    _isScanning = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Parse QR and validate with Hive
      await Future.delayed(const Duration(milliseconds: 500));

      final tableNumber = int.tryParse(qrData);
      if (tableNumber == null) {
        _error = 'Código QR inválido';
        return false;
      }

      final now = DateTime.now();
      _currentTable = TableModel(
        id: qrData,
        establishmentId: 'temp-establishment-id', // TODO: Obtener del contexto
        tableNumber: tableNumber,
        qrCode: qrData,
        createdAt: now,
        updatedAt: now,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<bool> assignTableByNumber(int tableNumber) async {
    _error = null;
    notifyListeners();

    try {
      // TODO: Validate table exists in Hive
      await Future.delayed(const Duration(milliseconds: 300));

      final now = DateTime.now();
      _currentTable = TableModel(
        id: tableNumber.toString(),
        establishmentId: 'temp-establishment-id', // TODO: Obtener del contexto
        tableNumber: tableNumber,
        qrCode: 'QR-TABLE-$tableNumber',
        createdAt: now,
        updatedAt: now,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearTable() {
    _currentTable = null;
    _error = null;
    notifyListeners();
  }
}
