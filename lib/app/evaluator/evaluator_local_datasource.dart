import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../constants/enums/person_enums/person_enums.dart';
import '../database_constants.dart';
import '../database_helper.dart';
import 'evaluator_entity.dart';
import 'evaluator_constants.dart';

class EvaluatorLocalDataSource {
  static final EvaluatorLocalDataSource _instance =
  EvaluatorLocalDataSource.internal();

  factory EvaluatorLocalDataSource() => _instance;

  EvaluatorLocalDataSource.internal();

  final dbHelper = DatabaseHelper();

  Future<Database?> get db async => dbHelper.db;

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(await getDatabasesPath(), DATABASE_NAME);
    print(path);

    return await openDatabase(path, version: DATABASE_VERSION,
        onCreate: (Database db, int newestVersion) async {
          await db.execute(SCRIPT_CREATE_TABLE_EVALUATORS);
        });
  }

  Future<int?> create(EvaluatorEntity evaluator) async {
    try {
      final Database? database = await db;

      // final sexValue = evaluator.sex.toInt();

      return await database!.insert(
        TABLE_EVALUATORS,
        {
          EVALUATOR_NAME: evaluator.name,
          EVALUATOR_SURNAME: evaluator.surname,
          BIRTH_DATE_EVALUATOR: evaluator.birthDate.toIso8601String(),
          // EVALUATOR_SEX: sexValue,
          CPF_EVALUATOR: evaluator.cpfOrNif,
          USERNAME_EVALUATOR: evaluator.username,
          SPECIALTY_EVALUATOR: evaluator.specialty,
          PASSWORD_EVALUATOR: evaluator.password,
          FIRST_LOGIN: 1,
          IS_ADMIN: evaluator.isAdmin ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print(ex);
      return null;
    }
  }


  Future<EvaluatorEntity?> getEvaluator(int id) async {
    try {
      final Database? database = await db;

      final List<Map<String, dynamic>> maps = await database!.query(
        TABLE_EVALUATORS,
        where: '$ID_EVALUATOR = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return EvaluatorEntity.fromMap(maps.first);
      }

      return null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<int> deleteEvaluator(int id) async {
    try {
      final Database? database = await db;

      return await database!.delete(
        TABLE_EVALUATORS,
        where: "$ID_EVALUATOR = ?",
        whereArgs: [id],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  Future<int> updateEvaluator(EvaluatorEntity evaluator) async {
    try {
      final Database? database = await db;

      return await database!.update(
        TABLE_EVALUATORS,
        evaluator.toMap(),
        where: "$ID_EVALUATOR = ?",
        whereArgs: [evaluator.evaluatorID],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  Future<List<EvaluatorEntity>> getAllEvaluators() async {
    try {
      final Database? database = await db;
      final List<Map<String, dynamic>> maps = await database!.query(TABLE_EVALUATORS);

      return List.generate(maps.length, (i) {
        return EvaluatorEntity.fromMap(maps[i]);
      });
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<int?> getNumberOfEvaluators() async {
    final Database? database = await db;
    final List<Map<String, dynamic>> result = await database!.rawQuery("SELECT COUNT(*) AS count FROM $TABLE_EVALUATORS");
    return result.first["count"] as int?;
  }

  Future<void> closeDatabase() async {
    final Database? database = await db;
    return database!.close();
  }

  Future<EvaluatorEntity?> getEvaluatorByUsername(String username) async {
    try {
      final Database? database = await db;

      final List<Map<String, dynamic>> maps = await database!.query(
        TABLE_EVALUATORS,
        where: '$USERNAME_EVALUATOR = ?',
        whereArgs: [username],
      );

      if (maps.isNotEmpty) {
        return EvaluatorEntity.fromMap(maps.first);
      }

      return null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<bool> evaluatorCpfExists(String cpf) async {
    final Database? database = await db;
    final List<Map<String, dynamic>> maps = await database!.query(
      TABLE_EVALUATORS,
      where: '$CPF_EVALUATOR = ?',
      whereArgs: [cpf],
    );
    return maps.isNotEmpty;
  }


  Future<bool> evaluatorCpfExistsForOther(int currentEvaluatorId, String cpf) async {
    final Database? database = await db;
    final List<Map<String, dynamic>> maps = await database!.query(
      TABLE_EVALUATORS,
      where: '$CPF_EVALUATOR = ? AND $ID_EVALUATOR != ?',
      whereArgs: [cpf, currentEvaluatorId],
    );
    return maps.isNotEmpty;
  }


}
