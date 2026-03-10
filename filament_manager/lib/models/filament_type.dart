class FilamentType {
  final int? id;
  final String name;
  final String brand;
  final String material;
  final String color;
  final bool isPreset;
  final DateTime createdAt;
  final String? syncId;
  final int? syncStatus;
  final DateTime? syncTime;

  FilamentType({
    this.id,
    required this.name,
    required this.brand,
    required this.material,
    required this.color,
    this.isPreset = false,
    required this.createdAt,
    this.syncId,
    this.syncStatus,
    this.syncTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'material': material,
      'color': color,
      'is_preset': isPreset ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'sync_id': syncId,
      'sync_status': syncStatus,
      'sync_time': syncTime?.toIso8601String(),
    };
  }

  factory FilamentType.fromMap(Map<String, dynamic> map) {
    return FilamentType(
      id: map['id'] as int?,
      name: map['name'] as String,
      brand: map['brand'] as String,
      material: map['material'] as String,
      color: map['color'] as String,
      isPreset: (map['is_preset'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      syncId: map['sync_id'] as String?,
      syncStatus: map['sync_status'] as int?,
      syncTime: map['sync_time'] != null
          ? DateTime.parse(map['sync_time'] as String)
          : null,
    );
  }

  FilamentType copyWith({
    int? id,
    String? name,
    String? brand,
    String? material,
    String? color,
    bool? isPreset,
    DateTime? createdAt,
    String? syncId,
    int? syncStatus,
    DateTime? syncTime,
  }) {
    return FilamentType(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      color: color ?? this.color,
      isPreset: isPreset ?? this.isPreset,
      createdAt: createdAt ?? this.createdAt,
      syncId: syncId ?? this.syncId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncTime: syncTime ?? this.syncTime,
    );
  }
}