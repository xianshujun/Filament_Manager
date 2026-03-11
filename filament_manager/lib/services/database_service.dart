import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/filament_type.dart';
import '../models/filament_spool.dart';
import '../models/usage_history.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  static Future<Database>? _pendingInit;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _pendingInit ??= _initDB('filament_manager.db');
    final db = await _pendingInit!;
    _database = db;
    return db;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE filament_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        material TEXT NOT NULL,
        color TEXT NOT NULL,
        is_preset INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        sync_id TEXT,
        sync_status INTEGER,
        sync_time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE filament_spools (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type_id INTEGER NOT NULL,
        spool_number INTEGER NOT NULL,
        initial_weight INTEGER NOT NULL DEFAULT 1000,
        remaining_weight INTEGER NOT NULL,
        is_in_use INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_id TEXT,
        sync_status INTEGER,
        sync_time TEXT,
        FOREIGN KEY (type_id) REFERENCES filament_types (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE usage_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        spool_id INTEGER NOT NULL,
        used_weight INTEGER NOT NULL,
        remaining_before INTEGER NOT NULL,
        remaining_after INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        sync_id TEXT,
        sync_status INTEGER,
        sync_time TEXT,
        FOREIGN KEY (spool_id) REFERENCES filament_spools (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_filament_spools_type_id ON filament_spools(type_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_usage_history_spool_id ON usage_history(spool_id)
    ''');
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    _pendingInit = null;
    db.close();
  }

  Future<int> insertFilamentType(FilamentType type) async {
    final db = await instance.database;
    return await db.insert('filament_types', type.toMap());
  }

  Future<List<FilamentType>> getAllFilamentTypes() async {
    final db = await instance.database;
    final result = await db.query(
      'filament_types',
      orderBy: 'created_at DESC',
    );
    return result.map((map) => FilamentType.fromMap(map)).toList();
  }

  Future<FilamentType?> getFilamentTypeById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'filament_types',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return FilamentType.fromMap(result.first);
  }

  Future<int> updateFilamentType(FilamentType type) async {
    final db = await instance.database;
    return await db.update(
      'filament_types',
      type.toMap(),
      where: 'id = ?',
      whereArgs: [type.id],
    );
  }

  Future<int> deleteFilamentType(int id) async {
    final db = await instance.database;
    return await db.delete(
      'filament_types',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertFilamentSpool(FilamentSpool spool) async {
    final db = await instance.database;
    return await db.insert('filament_spools', spool.toMap());
  }

  Future<List<FilamentSpool>> getAllFilamentSpools() async {
    final db = await instance.database;
    final result = await db.query(
      'filament_spools',
      orderBy: 'created_at DESC',
    );
    return result.map((map) => FilamentSpool.fromMap(map)).toList();
  }

  Future<List<FilamentSpool>> getFilamentSpoolsByType(int typeId) async {
    final db = await instance.database;
    final result = await db.query(
      'filament_spools',
      where: 'type_id = ?',
      whereArgs: [typeId],
      orderBy: 'spool_number ASC',
    );
    return result.map((map) => FilamentSpool.fromMap(map)).toList();
  }

  Future<FilamentSpool?> getFilamentSpoolById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'filament_spools',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return FilamentSpool.fromMap(result.first);
  }

  Future<int> getNextSpoolNumber(int typeId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT MAX(spool_number) as max_number FROM filament_spools WHERE type_id = ?',
      [typeId],
    );
    final maxNumber = result.first['max_number'] as int?;
    return (maxNumber ?? 0) + 1;
  }

  Future<int> updateFilamentSpool(FilamentSpool spool) async {
    final db = await instance.database;
    return await db.update(
      'filament_spools',
      spool.toMap(),
      where: 'id = ?',
      whereArgs: [spool.id],
    );
  }

  Future<int> deleteFilamentSpool(int id) async {
    final db = await instance.database;
    return await db.delete(
      'filament_spools',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertUsageHistory(UsageHistory history) async {
    final db = await instance.database;
    return await db.insert('usage_history', history.toMap());
  }

  Future<List<UsageHistory>> getAllUsageHistory() async {
    final db = await instance.database;
    final result = await db.query(
      'usage_history',
      orderBy: 'created_at DESC',
    );
    return result.map((map) => UsageHistory.fromMap(map)).toList();
  }

  Future<List<UsageHistory>> getUsageHistoryBySpool(int spoolId) async {
    final db = await instance.database;
    final result = await db.query(
      'usage_history',
      where: 'spool_id = ?',
      whereArgs: [spoolId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => UsageHistory.fromMap(map)).toList();
  }

  Future<int> deleteUsageHistory(int id) async {
    final db = await instance.database;
    return await db.delete(
      'usage_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUsageHistoryBySpool(int spoolId) async {
    final db = await instance.database;
    return await db.delete(
      'usage_history',
      where: 'spool_id = ?',
      whereArgs: [spoolId],
    );
  }
}