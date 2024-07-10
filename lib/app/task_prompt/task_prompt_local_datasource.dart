import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'task_prompt_entity.dart';
import '../database_constants.dart';
import 'task_prompt_constants.dart';
import '../database_helper.dart';

class TaskPromptLocalDataSource {
  static final TaskPromptLocalDataSource _instance = TaskPromptLocalDataSource.internal();

  factory TaskPromptLocalDataSource() => _instance;

  TaskPromptLocalDataSource.internal();

  final dbHelper = DatabaseHelper();

  Future<Database?> get db async => dbHelper.db;

  // Create a Task Audio File
  Future<int?> create(TaskPromptEntity taskPrompt) async {
    try {
      final Database? database = await db;
      return await database!.insert(
        TABLE_TASK_PROMPTS,
        taskPrompt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  // Get a Task Audio File by ID
  Future<TaskPromptEntity?> getTaskPrompt(int id) async {
    try {
      final Database? database = await db;
      final List<Map<String, dynamic>> maps = await database!.query(
        TABLE_TASK_PROMPTS,
        where: '$ID_TASK_PROMPT = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return TaskPromptEntity.fromMap(maps.first);
      }
      return null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  // Update a Task Audio File
  Future<int> updateTaskPrompt(TaskPromptEntity taskPrompt) async {
    try {
      final Database? database = await db;
      return await database!.update(
        TABLE_TASK_PROMPTS,
        taskPrompt.toMap(),
        where: "$ID_TASK_PROMPT = ?",
        whereArgs: [taskPrompt.promptID],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  // Delete a Task Audio File
  Future<int> deleteTaskPrompt(int id) async {
    try {
      final Database? database = await db;
      return await database!.delete(
        TABLE_TASK_PROMPTS,
        where: "$ID_TASK_PROMPT = ?",
        whereArgs: [id],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  // Get all Task Audio Files
  Future<List<TaskPromptEntity>> getAllTaskPrompts() async {
    try {
      final Database? database = await db;
      final List<Map<String, dynamic>> maps = await database!.query(TABLE_TASK_PROMPTS);
      return List.generate(maps.length, (i) {
        return TaskPromptEntity.fromMap(maps[i]);
      });
    } catch (ex) {
      print(ex);
      return [];
    }
  }
  Future<TaskPromptEntity?> getTaskPromptByTaskID(int taskID) async {
    try {
      final Database? database = await db;
      final List<Map<String, dynamic>> maps = await database!.query(
        TABLE_TASK_PROMPTS,
        where: '$ID_TASK_FK = ?',
        whereArgs: [taskID],
      );
      if (maps.isNotEmpty) {
        return TaskPromptEntity.fromMap(maps.first);
      }
      return null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

}
