import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database_constants.dart';
import '../database_helper.dart';
import 'recording_file_constants.dart';
import 'recording_file_entity.dart';

class RecordingLocalDataSource {
  static final RecordingLocalDataSource _instance =
  RecordingLocalDataSource.internal();

  factory RecordingLocalDataSource() => _instance;

  RecordingLocalDataSource.internal();

  final dbHelper = DatabaseHelper();

  Future<Database?> get db async => dbHelper.db;

  Future<int?> create(RecordingFileEntity recording) async {
    try {
      final Database? database = await db;
      final map = recording.toMap();

      // Use your constants for table and column names
      return await database!.insert(
        TABLE_RECORDINGS,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print('Error when creating recording: $ex');
      return null;
    }
  }

  Future<RecordingFileEntity?> getRecording(int id) async {
    final Database? database = await db;
    final List<Map<String, dynamic>> maps = await database!.query(
      TABLE_TASK_PROMPTS,
      columns: [ID_RECORDING, ID_TASK_INSTANCE_FK, FILE_PATH],
      where: "$ID_RECORDING = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      // Ensure a mutable copy is used
      final editableMap = Map<String, dynamic>.from(maps.first);
      return RecordingFileEntity.fromMap(editableMap);
    }
    return null;
  }

  Future<int> deleteRecording(int id) async {
    final Database? database = await db;
    return await database!.delete(
      TABLE_TASK_PROMPTS,
      where: "$ID_RECORDING = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateRecording(RecordingFileEntity recording) async {
    final Database? database = await db;
    final updatedMap = recording.toMap();

    return await database!.update(
      TABLE_TASK_PROMPTS,
      updatedMap,
      where: "$ID_RECORDING = ?",
      whereArgs: [recording.recordingId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecordingFileEntity>> getAllRecordings() async {
    final Database? database = await db;
    final result = await database!.query(TABLE_TASK_PROMPTS);

    return result.isNotEmpty
        ? result
        .map((c) => RecordingFileEntity.fromMap(Map<String, dynamic>.from(c)))
        .toList()
        : [];
  }

  Future<List<RecordingFileEntity>> getRecordingsByTaskInstanceID(
      int taskInstanceId) async {
    final Database? database = await db;
    final List<Map<String, dynamic>> maps = await database!.query(
      TABLE_RECORDINGS,
      columns: [ID_RECORDING, ID_TASK_INSTANCE_FK, FILE_PATH],
      where: "$ID_TASK_INSTANCE_FK = ?",
      whereArgs: [taskInstanceId],
    );

    if (maps.isNotEmpty) {
      return maps.map((map) =>
          RecordingFileEntity.fromMap(Map<String, dynamic>.from(map))).toList();
    }
    return [];
  }

}