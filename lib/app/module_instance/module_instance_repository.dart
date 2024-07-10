import 'module_instance_entity.dart';
import 'module_instance_local_datasource.dart';

class ModuleInstanceRepository {
  final ModuleInstanceLocalDataSource _moduleInstanceLocalDataSource;

  ModuleInstanceRepository(
      {required ModuleInstanceLocalDataSource moduleInstanceLocalDataSource})
      : _moduleInstanceLocalDataSource = moduleInstanceLocalDataSource;

  // Create a Module Instance
  Future<ModuleInstanceEntity?> createModuleInstance(
      ModuleInstanceEntity moduleInstance) async {
    int? id = await _moduleInstanceLocalDataSource.create(moduleInstance);
    if (id != null) {
      return _moduleInstanceLocalDataSource.getModuleInstanceById(id);
    }
    return null;
  }

  // Get a Module Instance by ID
  Future<ModuleInstanceEntity?> getModuleInstance(int id) async {
    return _moduleInstanceLocalDataSource.getModuleInstanceById(id);
  }

  // Delete a Module Instance by ID
  Future<int> deleteModuleInstance(int id) async {
    return _moduleInstanceLocalDataSource.deleteModuleInstance(id);
  }

  // Update a Module Instance
  Future<int> updateModuleInstance(ModuleInstanceEntity moduleInstance) async {
    return _moduleInstanceLocalDataSource.updateModuleInstance(moduleInstance);
  }

  // Get all Module Instances
  Future<List<ModuleInstanceEntity>> getAllModuleInstances() async {
    return _moduleInstanceLocalDataSource.getAllModuleInstances();
  }

  // Get the number of Module Instances
  Future<int?> getNumberOfModuleInstances() async {
    return _moduleInstanceLocalDataSource.getNumberOfModuleInstances();
  }

  // Get Module Instances by Evaluation ID
  Future<List<ModuleInstanceEntity>> getModuleInstancesByEvaluationId(
      int evaluationId) async {
    return _moduleInstanceLocalDataSource
        .getModuleInstancesByEvaluationId(evaluationId);
  }

  Future<int> setModuleInstanceAsCompleted(int moduleInstanceId) async {
    return _moduleInstanceLocalDataSource
        .setModuleInstanceAsCompleted(moduleInstanceId);
  }

  Future<int> setModuleInstanceAsInProgress(int moduleInstanceId) {
    return _moduleInstanceLocalDataSource
        .setModuleInstanceAsInProgress(moduleInstanceId);
  }
}
