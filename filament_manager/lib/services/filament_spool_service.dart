import '../models/filament_spool.dart';
import '../models/usage_history.dart';
import 'database_service.dart';

class FilamentSpoolService {
  static Future<List<FilamentSpool>> getAllSpools() async {
    return await DatabaseService.instance.getAllFilamentSpools();
  }

  static Future<List<FilamentSpool>> getSpoolsByType(int typeId) async {
    return await DatabaseService.instance.getFilamentSpoolsByType(typeId);
  }

  static Future<FilamentSpool?> getSpoolById(int id) async {
    return await DatabaseService.instance.getFilamentSpoolById(id);
  }

  static Future<FilamentSpool> addSpool({
    required int typeId,
    int initialWeight = 1000,
    int remainingWeight = 1000,
    bool isInUse = false,
  }) async {
    final spoolNumber = await DatabaseService.instance.getNextSpoolNumber(typeId);
    
    final spool = FilamentSpool(
      typeId: typeId,
      spoolNumber: spoolNumber,
      initialWeight: initialWeight,
      remainingWeight: remainingWeight,
      isInUse: isInUse,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final id = await DatabaseService.instance.insertFilamentSpool(spool);
    return spool.copyWith(id: id);
  }

  static Future<int> updateSpool(FilamentSpool spool) async {
    return await DatabaseService.instance.updateFilamentSpool(
      spool.copyWith(updatedAt: DateTime.now()),
    );
  }

  static Future<void> updateRemainingWeight({
    required int spoolId,
    required int newRemainingWeight,
  }) async {
    final spool = await getSpoolById(spoolId);
    if (spool == null) return;

    final usedWeight = spool.remainingWeight - newRemainingWeight;
    
    if (usedWeight > 0) {
      final history = UsageHistory(
        spoolId: spoolId,
        usedWeight: usedWeight,
        remainingBefore: spool.remainingWeight,
        remainingAfter: newRemainingWeight,
        createdAt: DateTime.now(),
      );
      await DatabaseService.instance.insertUsageHistory(history);
    }

    await updateSpool(
      spool.copyWith(remainingWeight: newRemainingWeight),
    );
  }

  static Future<int> deleteSpool(int id) async {
    await DatabaseService.instance.deleteUsageHistoryBySpool(id);
    return await DatabaseService.instance.deleteFilamentSpool(id);
  }

  static Future<List<FilamentSpool>> getInUseSpools() async {
    final allSpools = await getAllSpools();
    return allSpools.where((spool) => spool.isInUse).toList();
  }

  static Future<List<FilamentSpool>> getLowStockSpools() async {
    final allSpools = await getAllSpools();
    return allSpools.where((spool) => spool.isLowStock).toList();
  }
}