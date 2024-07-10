import 'participant_local_datasource.dart';
import 'participant_entity.dart';

/// A repository class for managing participant data.
/// It abstracts the underlying data source, providing a clean interface for the domain layer.
class ParticipantRepository {
  final ParticipantLocalDataSource localDataSource;

  ParticipantRepository({required this.localDataSource});

  /// Creates a new participant in the database.
  /// Returns the ID of the newly created participant or null in case of failure.
  Future<int?> createParticipant(ParticipantEntity participant) async {
    return await localDataSource.create(participant);
  }

  /// Retrieves a participant by their ID.
  /// Returns a [ParticipantEntity] if found, or null otherwise.
  Future<ParticipantEntity?> getParticipant(int id) async {
    return await localDataSource.getParticipant(id);
  }

  /// Deletes a participant by their ID.
  /// Returns the number of rows affected (should be 1 if successful, 0 otherwise).
  Future<int> deleteParticipant(int id) async {
    return await localDataSource.deleteParticipant(id);
  }

  /// Updates an existing participant's information in the database.
  /// Returns the number of rows affected (should be 1 if successful, 0 otherwise).
  Future<int> updateParticipant(ParticipantEntity participant) async {
    return await localDataSource.updateParticipant(participant);
  }

  /// Retrieves all participants from the database.
  /// Returns a list of [ParticipantEntity] or an empty list in case of failure or if no participants are found.
  Future<List<ParticipantEntity>> getAllParticipants() async {
    try {
      return await localDataSource.getAllParticipants();
    } catch (e) {
      print('Error fetching all participants: $e');
      return [];
    }
  }

  /// Retrieves a participant by their associated evaluation ID.
  /// Useful for fetching participant details from an evaluation context.
  /// Returns a [ParticipantEntity] if found, or null otherwise.
  Future<ParticipantEntity?> getParticipantByEvaluation(int evaluationId) async {
    return await localDataSource.getParticipantByEvaluation(evaluationId);
  }

  /// Retrieves the total number of participants in the database.
  /// Returns the count or null in case of failure.
  Future<int?> getNumberOfParticipants() async {
    return await localDataSource.getNumberOfParticipants();
  }
}
