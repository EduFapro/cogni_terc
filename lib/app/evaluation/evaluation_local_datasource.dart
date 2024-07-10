import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../constants/enums/evaluation_enums.dart';
import '../database_constants.dart';
import '../database_helper.dart';
import 'evaluation_entity.dart';
import 'evaluation_constants.dart';

class EvaluationLocalDataSource {
  static final EvaluationLocalDataSource _instance =
      EvaluationLocalDataSource.internal();

  factory EvaluationLocalDataSource() => _instance;

  EvaluationLocalDataSource.internal();

  final dbHelper = DatabaseHelper();

  Future<Database?> get db async => dbHelper.db;

  Future<int?> create(EvaluationEntity evaluation) async {
    try {
      final Database? database = await db;

      return await database!.insert(
        TABLE_EVALUATIONS,
        evaluation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<EvaluationEntity?> getEvaluation(int id) async {
    final Database? database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      TABLE_EVALUATIONS,
      columns: [
        ID_EVALUATION,
        EVALUATION_DATE,
        ID_EVALUATOR_FK,
        ID_PARTICIPANT_FK,
        EVALUATION_STATUS,
        LANGUAGE
      ],
      where: "$ID_EVALUATION = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return EvaluationEntity.fromMap(maps.first);
    }
    return null;
  }


  Future<int> deleteEvaluation(int id) async {
    final Database? database = await db;

    return await database!.delete(
      TABLE_EVALUATIONS,
      where: "$ID_EVALUATION = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateEvaluation(EvaluationEntity evaluation) async {
    final Database? database = await db;

    return await database!.update(
      TABLE_EVALUATIONS,
      evaluation.toMap(),
      where: "$ID_EVALUATION = ?",
      whereArgs: [evaluation.evaluationID],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<EvaluationEntity>> getAllEvaluations() async {
    final Database? database = await db;

    var result = await database!.query(TABLE_EVALUATIONS);
    List<EvaluationEntity> evaluations = result.isNotEmpty
        ? result
            .map((c) => EvaluationEntity.fromMap(c as Map<String, dynamic>))
            .toList()
        : [];
    return evaluations;
  }

  Future<int?> getNumberOfEvaluations() async {
    final Database? database = await db;
    final List<Map<String, dynamic>> result = await database!
        .rawQuery("SELECT COUNT(*) AS count FROM $TABLE_EVALUATIONS");
    return result.first["count"] as int?;
  }

  Future<List<EvaluationEntity>> getEvaluationsByEvaluatorID(int evaluatorID) async {
    final Database? database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      TABLE_EVALUATIONS,
      columns: [
        ID_EVALUATION,
        EVALUATION_DATE,
        ID_EVALUATOR_FK,
        ID_PARTICIPANT_FK,
        EVALUATION_STATUS,
        LANGUAGE
      ],
      where: "$ID_EVALUATOR_FK = ?",
      whereArgs: [evaluatorID],
    );

    return maps.isNotEmpty ? maps.map((map) => EvaluationEntity.fromMap(map)).toList() : [];
  }


  Future<int> setEvaluationAsCompleted(int evaluationId) async {
    final Database? database = await db;
    return await database!.update(
      TABLE_EVALUATIONS,
      {EVALUATION_STATUS: EvaluationStatus.completed.numericValue},
      where: "$ID_EVALUATION = ?",
      whereArgs: [evaluationId],
    );
  }

  Future<int> setEvaluationAsInProgress(int evaluationId) async {
    final Database? database = await db;
    return await database!.update(
      TABLE_EVALUATIONS,
      {EVALUATION_STATUS: EvaluationStatus.in_progress.numericValue},
      where: "$ID_EVALUATION = ?",
      whereArgs: [evaluationId],
    );
  }


}
