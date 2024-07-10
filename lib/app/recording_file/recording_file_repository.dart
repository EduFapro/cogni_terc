import 'recording_file_datasource.dart';
import 'recording_file_entity.dart';

class RecordingRepository {
  final RecordingLocalDataSource _localDataSource;

  RecordingRepository(this._localDataSource);

  Future<int?> createRecording(RecordingFileEntity recording) async {
    return _localDataSource.create(recording);
  }

  Future<RecordingFileEntity?> getRecordingById(int id) async {
    return _localDataSource.getRecording(id);
  }

  Future<int> deleteRecording(int id) async {
    return _localDataSource.deleteRecording(id);
  }

  Future<int> updateRecording(RecordingFileEntity recording) async {
    return _localDataSource.updateRecording(recording);
  }

  Future<List<RecordingFileEntity>> getAllRecordings() async {
    return _localDataSource.getAllRecordings();
  }

  Future<List<RecordingFileEntity>> getRecordingsByTaskInstanceId(int taskInstanceId) async {
    return _localDataSource.getRecordingsByTaskInstanceID(taskInstanceId);
  }
}
