import '../task/task_entity.dart';
import 'module_constants.dart';

class ModuleEntity {
  final int? moduleID;
  final String? title;
  final List<TaskEntity> tasks;

  ModuleEntity({
    this.moduleID,
    this.title,
    this.tasks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      ID_MODULE: moduleID,
      TITLE: title,
    };
  }

  static ModuleEntity fromMap(Map<String, dynamic> map) {
    return ModuleEntity(
      moduleID: map[ID_MODULE] as int?,
      title: map[TITLE] as String?,
    );
  }

  ModuleEntity copyWith({
    int? moduleID,
    String? title,
    List<TaskEntity>? tasks,
  }) {
    return ModuleEntity(
      moduleID: moduleID ?? this.moduleID,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }


  @override
  String toString() {
    return 'ModuleEntity{moduleID: $moduleID, title: $title, tasks: $tasks}';
  }
}
