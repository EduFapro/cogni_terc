import 'evaluation_local_datasource.dart';
import 'evaluation_entity.dart';

/// A repository class for managing evaluation data.
/// It abstracts the underlying data source, providing a clean interface for the domain layer.
class EvaluationRepository {
  final EvaluationLocalDataSource localDataSource;

  EvaluationRepository({required this.localDataSource});

  /// Creates a new evaluation in the database.
  /// Returns the ID of the newly created evaluation or null in case of failure.
  Future<int?> createEvaluation(EvaluationEntity evaluation) async {
    return await localDataSource.create(evaluation);
  }

  /// Retrieves an evaluation by its ID.
  /// Returns an [EvaluationEntity] if found, or null otherwise.
  Future<EvaluationEntity?> getEvaluation(int id) async {
    return await localDataSource.getEvaluation(id);
  }

  /// Deletes an evaluation by its ID.
  /// Returns the number of rows affected (should be 1 if successful, 0 otherwise).
  Future<int> deleteEvaluation(int id) async {
    return await localDataSource.deleteEvaluation(id);
  }

  /// Updates an existing evaluation's information in the database.
  /// Returns the number of rows affected (should be 1 if successful, 0 otherwise).
  Future<int> updateEvaluation(EvaluationEntity evaluation) async {
    return await localDataSource.updateEvaluation(evaluation);
  }

  /// Retrieves all evaluations from the database.
  /// Returns a list of [EvaluationEntity] or an empty list in case of failure or if no evaluations are found.
  Future<List<EvaluationEntity>> getAllEvaluations() async {
    try {
      return await localDataSource.getAllEvaluations();
    } catch (e) {
      print('Error fetching all evaluations: $e');
      return [];
    }
  }

  /// Retrieves the total number of evaluations in the database.
  /// Returns the count or null in case of failure.
  Future<int?> getNumberOfEvaluations() async {
    return await localDataSource.getNumberOfEvaluations();
  }

  /// Retrieves evaluations associated with a specific evaluator ID.
  /// Useful for fetching all evaluations conducted by a specific evaluator.
  /// Returns a list of [EvaluationEntity] or an empty list if no evaluations are found for the evaluator.
  Future<List<EvaluationEntity>> getEvaluationsByEvaluatorID(
      int evaluatorID) async {
    var evaluations =
        await localDataSource.getEvaluationsByEvaluatorID(evaluatorID);
    return evaluations;
  }

  Future<void> setEvaluationAsCompleted(int evaluationId) async {
    await localDataSource.setEvaluationAsCompleted(evaluationId);
  }

  Future<void> setEvaluationAsInProgress(int evaluationId) async {
    await localDataSource.setEvaluationAsInProgress(evaluationId);
  }

}
