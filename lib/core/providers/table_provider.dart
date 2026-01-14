import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableProvider with ChangeNotifier {
  int? _tableNumber;
  DateTime? _assignedAt;

  int? get tableNumber => _tableNumber;
  DateTime? get assignedAt => _assignedAt;
  bool get hasTable => _tableNumber != null;

  Duration? get sessionDuration {
    if (_assignedAt == null) return null;
    return DateTime.now().difference(_assignedAt!);
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _tableNumber = prefs.getInt('table_number');
    final timestamp = prefs.getInt('table_assigned_at');
    if (timestamp != null) {
      _assignedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    notifyListeners();
  }

  Future<void> assignTable(int tableNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('table_number', tableNumber);
    await prefs.setInt(
        'table_assigned_at', DateTime.now().millisecondsSinceEpoch);

    _tableNumber = tableNumber;
    _assignedAt = DateTime.now();
    notifyListeners();
  }

  Future<void> unassignTable() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('table_number');
    await prefs.remove('table_assigned_at');

    _tableNumber = null;
    _assignedAt = null;
    notifyListeners();
  }

  String getFormattedDuration() {
    final duration = sessionDuration;
    if (duration == null) return '0m';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
