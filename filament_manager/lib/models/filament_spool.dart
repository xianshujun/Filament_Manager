class FilamentSpool {
  final int? id;
  final int typeId;
  final int spoolNumber;
  final int initialWeight;
  final int remainingWeight;
  final bool isInUse;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? syncId;
  final int? syncStatus;
  final DateTime? syncTime;

  FilamentSpool({
    this.id,
    required this.typeId,
    required this.spoolNumber,
    this.initialWeight = 1000,
    required this.remainingWeight,
    this.isInUse = false,
    required this.createdAt,
    required this.updatedAt,
    this.syncId,
    this.syncStatus,
    this.syncTime,
  });

  bool get isLowStock => remainingWeight < 10;

  String get displayName {
    return '耗材卷 #$spoolNumber';
  }

  double get usagePercentage {
    if (initialWeight == 0) return 0.0;
    return (remainingWeight / initialWeight) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type_id': typeId,
      'spool_number': spoolNumber,
      'initial_weight': initialWeight,
      'remaining_weight': remainingWeight,
      'is_in_use': isInUse ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sync_id': syncId,
      'sync_status': syncStatus,
      'sync_time': syncTime?.toIso8601String(),
    };
  }

  factory FilamentSpool.fromMap(Map<String, dynamic> map) {
    return FilamentSpool(
      id: map['id'] as int?,
      typeId: map['type_id'] as int,
      spoolNumber: map['spool_number'] as int,
      initialWeight: map['initial_weight'] as int,
      remainingWeight: map['remaining_weight'] as int,
      isInUse: (map['is_in_use'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      syncId: map['sync_id'] as String?,
      syncStatus: map['sync_status'] as int?,
      syncTime: map['sync_time'] != null
          ? DateTime.parse(map['sync_time'] as String)
          : null,
    );
  }

  FilamentSpool copyWith({
    int? id,
    int? typeId,
    int? spoolNumber,
    int? initialWeight,
    int? remainingWeight,
    bool? isInUse,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncId,
    int? syncStatus,
    DateTime? syncTime,
  }) {
    return FilamentSpool(
      id: id ?? this.id,
      typeId: typeId ?? this.typeId,
      spoolNumber: spoolNumber ?? this.spoolNumber,
      initialWeight: initialWeight ?? this.initialWeight,
      remainingWeight: remainingWeight ?? this.remainingWeight,
      isInUse: isInUse ?? this.isInUse,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncTime: syncTime ?? this.syncTime,
    );
  }
}