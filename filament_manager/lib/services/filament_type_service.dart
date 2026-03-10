import '../models/filament_type.dart';
import 'database_service.dart';

class FilamentTypeService {
  static Future<List<FilamentType>> getAllTypes() async {
    return await DatabaseService.instance.getAllFilamentTypes();
  }

  static Future<FilamentType?> getTypeById(int id) async {
    return await DatabaseService.instance.getFilamentTypeById(id);
  }

  static Future<int> addType(FilamentType type) async {
    return await DatabaseService.instance.insertFilamentType(type);
  }

  static Future<int> updateType(FilamentType type) async {
    return await DatabaseService.instance.updateFilamentType(type);
  }

  static Future<int> deleteType(int id) async {
    return await DatabaseService.instance.deleteFilamentType(id);
  }

  static Future<List<FilamentType>> searchTypes(String query) async {
    final allTypes = await getAllTypes();
    if (query.isEmpty) return allTypes;
    
    final lowerQuery = query.toLowerCase();
    return allTypes.where((type) {
      return type.name.toLowerCase().contains(lowerQuery) ||
          type.brand.toLowerCase().contains(lowerQuery) ||
          type.material.toLowerCase().contains(lowerQuery) ||
          type.color.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static Future<List<FilamentType>> getPresetTypes() async {
    final allTypes = await getAllTypes();
    return allTypes.where((type) => type.isPreset).toList();
  }

  static Future<List<FilamentType>> getCustomTypes() async {
    final allTypes = await getAllTypes();
    return allTypes.where((type) => !type.isPreset).toList();
  }
}