class TableModel {
  final String id;
  final String establishmentId;
  final int tableNumber;
  final String qrCode;
  final int capacity;
  final String? locationDescription;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const TableModel({
    required this.id,
    required this.establishmentId,
    required this.tableNumber,
    required this.qrCode,
    this.capacity = 4,
    this.locationDescription,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  TableModel copyWith({
    String? id,
    String? establishmentId,
    int? tableNumber,
    String? qrCode,
    int? capacity,
    String? locationDescription,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return TableModel(
      id: id ?? this.id,
      establishmentId: establishmentId ?? this.establishmentId,
      tableNumber: tableNumber ?? this.tableNumber,
      qrCode: qrCode ?? this.qrCode,
      capacity: capacity ?? this.capacity,
      locationDescription: locationDescription ?? this.locationDescription,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'establishment_id': establishmentId,
      'table_number': tableNumber,
      'qr_code': qrCode,
      'capacity': capacity,
      'location_description': locationDescription,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] as String,
      establishmentId: json['establishment_id'] as String,
      tableNumber: json['table_number'] as int,
      qrCode: json['qr_code'] as String,
      capacity: json['capacity'] as int? ?? 4,
      locationDescription: json['location_description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }
}
