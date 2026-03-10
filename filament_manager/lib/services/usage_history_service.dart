import '../models/usage_history.dart';
import 'database_service.dart';

class UsageHistoryService {
  static Future<List<UsageHistory>> getAllHistory() async {
    return await DatabaseService.instance.getAllUsageHistory();
  }

  static Future<List<UsageHistory>> getHistoryBySpool(int spoolId) async {
    return await DatabaseService.instance.getUsageHistoryBySpool(spoolId);
  }

  static Future<int> addHistory(UsageHistory history) async {
    return await DatabaseService.instance.insertUsageHistory(history);
  }

  static Future<int> deleteHistory(int id) async {
    return await DatabaseService.instance.deleteUsageHistory(id);
  }

  static Future<int> deleteHistoryBySpool(int spoolId) async {
    return await DatabaseService.instance.deleteUsageHistoryBySpool(spoolId);
  }
}