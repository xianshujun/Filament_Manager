class UsageHistory {
  final int? id;
  final int spoolId;
  final int usedWeight;
  final int remainingBefore;
  final int remainingAfter;
  final DateTime createdAt;
  final String? syncId;
  final int? syncStatus;
  final DateTime? syncTime;

  UsageHistory({
    this.id,
    required this.spoolId,
    required this.usedWeight,
    required this.remainingBefore,
    required this.remainingAfter,
    required this.createdAt,
    this.syncId,
    this.syncStatus,
    this.syncTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'spool_id': spoolId,
      'used_weight': usedWeight,
      'remaining_before': remainingBefore,
      'remaining_after': remainingAfter,
      'created_at': createdAt.toIso8601String(),
      'sync_id': syncId,
      'sync_status': syncStatus,
      'sync_time': syncTime?.toIso8601String(),
    };
  }

  factory UsageHistory.fromMap(Map<String, dynamic> map) {
    return UsageHistory(
      id: map['id'] as int?,
      spoolId: map['spool_id'] as int,
      usedWeight: map['used_weight'] as int,
      remainingBefore: map['remaining_before'] as int,
      remainingAfter: map['remaining_after'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      syncId: map['sync_id'] as String?,
      syncStatus: map['sync_status'] as int?,
      syncTime: map['sync_time'] != null
          ? DateTime.parse(map['sync_time'] as String)
          : null,
    );
  }

  UsageHistory copyWith({
    int? id,
    int? spoolId,
    int? usedWeight,
    int? remainingBefore,
    int? remainingAfter,
    DateTime? createdAt,
    String? syncId,
    int? syncStatus,
    DateTime? syncTime,
  }) {
    return UsageHistory(
      id: id ?? this.id,
      spoolId: spoolId ?? this.spoolId,
      usedWeight: usedWeight ?? this.usedWeight,
      remainingBefore: remainingBefore ?? this.remainingBefore,
      remainingAfter: remainingAfter ?? this.remainingAfter,
      createdAt: createdAt ?? this.createdAt,
      syncId: syncId ?? this.syncId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncTime: syncTime ?? this.syncTime,
    );
  }
}