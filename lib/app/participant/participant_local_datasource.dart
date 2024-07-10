import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../constants/enums/person_enums/person_enums.dart';
import '../database_constants.dart';
import '../database_helper.dart';
import '../evaluation/evaluation_constants.dart';
import 'participant_entity.dart';
import 'participant_constants.dart';

class ParticipantLocalDataSource {

  static final ParticipantLocalDataSource _instance = ParticipantLocalDataSource._internal();
  factory ParticipantLocalDataSource() => _instance;
  ParticipantLocalDataSource._internal();

  final dbHelper = DatabaseHelper();

  Future<Database?> get db async => dbHelper.db;

  Future<int?> create(ParticipantEntity participant) async {
    try {
      final Database? database = await db;

      // Use the enum's numeric value directly
      final sexValue = participant.sex.numericValue;
      final educationLevelValue = participant.educationLevel.numericValue;
      // final handednessValue = participant.handedness.numericValue;

      return await database!.insert(
        TABLE_PARTICIPANTS,
        {
          PARTICIPANT_NAME: participant.name,
          PARTICIPANT_SURNAME: participant.surname,
          BIRTH_DATE_PARTICIPANT: participant.birthDate.toIso8601String(),
          PARTICIPANT_SEX: sexValue,
          PARTICIPANT_EDUCATION_LEVEL: educationLevelValue,
          // PARTICIPANT_HANDEDNESS: handednessValue,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print(ex);
      return null;
    }
  }


  Future<ParticipantEntity?> getParticipant(int id) async {
    try {
      final Database? database = await db;

      final List<Map<String, dynamic>> maps = await database!.query(
        TABLE_PARTICIPANTS,
        where: '$ID_PARTICIPANT = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return ParticipantEntity.fromMap(maps.first);
      }

      return null;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<int> deleteParticipant(int id) async {
    try {
      final Database? database = await db;

      return await database!.delete(
        TABLE_PARTICIPANTS,
        where: "$ID_PARTICIPANT = ?",
        whereArgs: [id],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  Future<int> updateParticipant(ParticipantEntity participant) async {
    try {
      final Database? database = await db;

      return await database!.update(
        TABLE_PARTICIPANTS,
        participant.toMap(),
        where: "$ID_PARTICIPANT = ?",
        whereArgs: [participant.participantID],
      );
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  Future<List<ParticipantEntity>> getAllParticipants() async {
    try {
      final Database? database = await db;
      final List<Map<String, dynamic>> maps = await database!.query(TABLE_PARTICIPANTS);

      return List.generate(maps.length, (i) {
        return ParticipantEntity.fromMap(maps[i]);
      });
    } catch (ex) {
      print(ex);
      return [];
    }
  }
  Future<ParticipantEntity?> getParticipantByEvaluation(int evaluationId) async {
    final Database? database = await db;
    final List<Map<String, dynamic>> maps = await database!.query(
      TABLE_EVALUATIONS,
      columns: [ID_PARTICIPANT_FK],
      where: '$ID_EVALUATION = ?',
      whereArgs: [evaluationId],
    );

    if (maps.isNotEmpty) {
      int participantId = maps.first[ID_PARTICIPANT_FK];
      return await getParticipant(participantId);
    }
    return null;
  }

  Future<int?> getNumberOfParticipants() async {
    final Database? database = await db;
    final List<Map<String, dynamic>> result = await database!.rawQuery("SELECT COUNT(*) AS count FROM $TABLE_PARTICIPANTS");
    return result.first["count"] as int?;
  }

  Future<void> closeDatabase() async {
    final Database? database = await db;
    return database!.close();
  }
}
