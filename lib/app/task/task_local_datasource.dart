import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database_constants.dart';
import '../database_helper.dart';
import 'task_constants.dart';
import 'task_entity.dart';

class TaskLocalDataSource {
  static final TaskLocalDataSource _instance = TaskLocalDataSource._internal();

  factory TaskLocalDataSource() => _instance;

  TaskLocalDataSource._internal();

  final dbHelper = DatabaseHelper();

  Future<Database?> get db async => dbHelper.db;

  // Create a new Task
  Future<int?> create(TaskEntity task) async {
    try {
      final Database? database = await db;
      final map = task.toMap();
      map[MODE] = task.taskMode.numericValue;
      return await database!.insert(TABLE_TASKS, map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  // Update a Task
  Future<int> updateTask(TaskEntity task) async {
    try {
      final Database? database = await db;
      final map = task.toMap();
      map[MODE] = task.taskMode.numericValue;
      return await database!.update(TABLE_TASKS, map,
          where: '$ID_TASK = ?', whereArgs: [task.taskID]);
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  // Delete a Task by ID
  Future<int> deleteTask(int id) async {
    try {
      final Database? database = await db;
      return await database!
          .delete(TABLE_TASKS, where: '$ID_TASK = ?', whereArgs: [id]);
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  // Retrieve a Task by ID with proper casting
  Future<TaskEntity?> getTask(int id) async {
    try {
      final Database? database = await db;
      final maps = await database!
          .query(TABLE_TASKS, where: '$ID_TASK = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        final map = Map<String, dynamic>.from(maps.first);
        return TaskEntity.fromMap(map);
      }
      return null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<List<TaskEntity>> listTasks() async {
    try {
      final Database? database = await db;
      final maps = await database!.query(TABLE_TASKS);
      return maps.map((map) => TaskEntity.fromMap(map)).toList();
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<List<TaskEntity>> listTasksByModuleId(int moduleId) async {
    try {
      final Database? database = await db;
      final maps = await database!.query(
        TABLE_TASKS,
        where: '$MODULE_ID = ?',
        whereArgs: [moduleId],
      );
      return maps.map((map) => TaskEntity.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching tasks for module ID $moduleId: $e');
      return [];
    }
  }
}
