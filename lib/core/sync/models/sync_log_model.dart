enum SyncOperation { insert, update, delete }

enum SyncStatus { pending, synced, failed }

class SyncLogModel {
  final String id;
  final String tableName;
  final String recordId;
  final SyncOperation operation;
  final SyncStatus syncStatus;
  final DateTime localTimestamp;
  final DateTime? remoteTimestamp;
  final String? errorMessage;
  final int retryCount;
  final DateTime createdAt;

  const SyncLogModel({
    required this.id,
    required this.tableName,
    required this.recordId,
    required this.operation,
    this.syncStatus = SyncStatus.pending,
    required this.localTimestamp,
    this.remoteTimestamp,
    this.errorMessage,
    this.retryCount = 0,
    required this.createdAt,
  });

  SyncLogModel copyWith({
    String? id,
    String? tableName,
    String? recordId,
    SyncOperation? operation,
    SyncStatus? syncStatus,
    DateTime? localTimestamp,
    DateTime? remoteTimestamp,
    String? errorMessage,
    int? retryCount,
    DateTime? createdAt,
  }) {
    return SyncLogModel(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      syncStatus: syncStatus ?? this.syncStatus,
      localTimestamp: localTimestamp ?? this.localTimestamp,
      remoteTimestamp: remoteTimestamp ?? this.remoteTimestamp,
      errorMessage: errorMessage ?? this.errorMessage,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_name': tableName,
      'record_id': recordId,
      'operation': operation.name,
      'sync_status': syncStatus.name,
      'local_timestamp': localTimestamp.toIso8601String(),
      'remote_timestamp': remoteTimestamp?.toIso8601String(),
      'error_message': errorMessage,
      'retry_count': retryCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SyncLogModel.fromJson(Map<String, dynamic> json) {
    return SyncLogModel(
      id: json['id'] as String,
      tableName: json['table_name'] as String,
      recordId: json['record_id'] as String,
      operation: SyncOperation.values.byName(json['operation'] as String),
      syncStatus: SyncStatus.values.byName(json['sync_status'] as String),
      localTimestamp: DateTime.parse(json['local_timestamp'] as String),
      remoteTimestamp: json['remote_timestamp'] != null ? DateTime.parse(json['remote_timestamp'] as String) : null,
      errorMessage: json['error_message'] as String?,
      retryCount: json['retry_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
