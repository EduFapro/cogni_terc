import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../constants/enums/module_enums.dart';
import '../database_constants.dart';
import '../database_helper.dart';
import 'module_instance_entity.dart';
import 'module_instance_constants.dart';

class ModuleInstanceLocalDataSource {
  static final ModuleInstanceLocalDataSource _instance = ModuleInstanceLocalDataSource.internal();

  factory ModuleInstanceLocalDataSource() => _instance;
  ModuleInstanceLocalDataSource.internal();

  final dbHelper = DatabaseHelper();

  Future<Database?> get db async => dbHelper.db;

  Future<int?> create(ModuleInstanceEntity moduleInstance) async {
    try {
      final Database? database = await db;

      return await database!.insert(
        TABLE_MODULE_INSTANCES,
        moduleInstance.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<ModuleInstanceEntity?> getModuleInstanceById(int id) async {
    try {
      final Database? database = await db;

      final List<Map<String, dynamic>> maps = await database!.query(
        TABLE_MODULE_INSTANCES,
        where: '$ID_MODULE_INSTANCE = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return ModuleInstanceEntity.fromMap(maps.first);
      }

      return null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<int> deleteModuleInstance(int id) async {
    try {
      final Database? database = await db;

      return await database!.delete(
        TABLE_MODULE_INSTANCES,
        where: "$ID_MODULE_INSTANCE = ?",
        whereArgs: [id],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  Future<int> updateModuleInstance(ModuleInstanceEntity moduleInstance) async {
    try {
      final Database? database = await db;

      return await database!.update(
        TABLE_MODULE_INSTANCES,
        moduleInstance.toMap(),
        where: "$ID_MODULE_INSTANCE = ?",
        whereArgs: [moduleInstance.moduleInstanceID],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  Future<List<ModuleInstanceEntity>> getAllModuleInstances() async {
    try {
      final Database? database = await db;
      final List<Map<String, dynamic>> maps = await database!.query(TABLE_MODULE_INSTANCES);

      return List.generate(maps.length, (i) {
        return ModuleInstanceEntity.fromMap(maps[i]);
      });
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<int?> getNumberOfModuleInstances() async {
    final Database? database = await db;
    final List<Map<String, dynamic>> result = await database!.rawQuery("SELECT COUNT(*) AS count FROM $TABLE_MODULE_INSTANCES");
    return result.first["count"] as int?;
  }

  Future<List<ModuleInstanceEntity>> getModuleInstancesByEvaluationId(int evaluationId) async {
    try {
      final Database? database = await db;
      final List<Map<String, dynamic>> maps = await database!.query(
        TABLE_MODULE_INSTANCES,
        where: '$ID_EVALUATION_FK = ?',
        whereArgs: [evaluationId],
      );

      return List.generate(maps.length, (i) {
        return ModuleInstanceEntity.fromMap(maps[i]);
      });
    } catch (ex) {
      print(ex);
      return [];
    }
  }
  Future<int> setModuleInstanceAsCompleted(int moduleInstanceId) async {
    try {
      final Database? database = await db;
      int statusCompleted = ModuleStatus.completed.numericValue;

      return await database!.update(
        TABLE_MODULE_INSTANCES,
        { MODULE_INSTANCE_STATUS: statusCompleted },
        where: "$ID_MODULE_INSTANCE = ?",
        whereArgs: [moduleInstanceId],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  Future<int> setModuleInstanceAsInProgress(int moduleInstanceId) async {
    try {
      final Database? database = await db;
      int statusInProgress = ModuleStatus.in_progress.numericValue;

      return await database!.update(
        TABLE_MODULE_INSTANCES,
        { MODULE_INSTANCE_STATUS: statusInProgress },
        where: "$ID_MODULE_INSTANCE = ?",
        whereArgs: [moduleInstanceId],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }
}
