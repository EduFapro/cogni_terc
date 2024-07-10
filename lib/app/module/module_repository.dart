import '../task/task_local_datasource.dart';
import 'module_entity.dart';
import 'module_local_datasource.dart';

/// A repository class for managing module data.
/// It abstracts the underlying data sources, providing a clean interface for the domain layer.
class ModuleRepository {
  final ModuleLocalDataSource moduleLocalDataSource;
  final TaskLocalDataSource taskLocalDataSource;

  ModuleRepository({
    required this.moduleLocalDataSource,
    required this.taskLocalDataSource,
  });

  /// Creates a new module in the database.
  /// Returns the ID of the newly created module or null in case of failure.
  Future<int?> createModule(ModuleEntity module) async {
    return await moduleLocalDataSource.create(module);
  }

  /// Retrieves a module by its ID, including its associated tasks.
  /// Returns a [ModuleEntity] if found, or null otherwise.
  Future<ModuleEntity?> getModuleWithTasks(int moduleId) async {
    var module = await moduleLocalDataSource.getModuleById(moduleId);
    if (module != null) {
      var tasks = await taskLocalDataSource.listTasksByModuleId(moduleId);
      module = module.copyWith(tasks: tasks);
    }
    return module;
  }

  /// Retrieves all modules from the database.
  /// Returns a list of [ModuleEntity] or an empty list in case of failure or if no modules are found.
  Future<List<ModuleEntity>> getAllModules() async {
    return await moduleLocalDataSource.getAllModules();
  }

  /// Retrieves a module by its name.
  /// Returns a [ModuleEntity] if found, or null otherwise.
  Future<ModuleEntity?> getModuleByName(String name) async {
    return await moduleLocalDataSource.getModuleByName(name);
  }

  /// Deletes a module by its ID.
  /// Returns the number of rows affected (should be 1 if successful, 0 otherwise).
  Future<int> deleteModule(int id) async {
    return await moduleLocalDataSource.deleteModule(id);
  }

  /// Updates an existing module's information in the database.
  /// Returns the number of rows affected (should be 1 if successful, 0 otherwise).
  Future<int> updateModule(ModuleEntity module) async {
    return await moduleLocalDataSource.updateModule(module);
  }

  /// Retrieves the total number of modules in the database.
  /// Returns the count or null in case of failure.
  Future<int?> getNumberOfModules() async {
    return await moduleLocalDataSource.getNumberOfModules();
  }

  // Get a Module by ID
  Future<ModuleEntity?> getModule(int id) async {
    return await moduleLocalDataSource.getModuleById(id);
  }


}
