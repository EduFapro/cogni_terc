import 'package:get/get.dart';

import '../../../constants/enums/module_enums.dart';
import 'module_instance_constants.dart';
import '../module/module_repository.dart';
import '../module/module_entity.dart';

class ModuleInstanceEntity {
  int? moduleInstanceID;
  int moduleID;
  int evaluationID;
  ModuleStatus status;
  ModuleEntity? _module;

  ModuleInstanceEntity({
    this.moduleInstanceID,
    required this.moduleID,
    required this.evaluationID,
    this.status = ModuleStatus.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      ID_MODULE_INSTANCE: moduleInstanceID,
      ID_MODULE_FK: moduleID,
      ID_EVALUATION_FK: evaluationID,
      MODULE_INSTANCE_STATUS: status.numericValue,
    };
  }


  static ModuleInstanceEntity fromMap(Map<String, dynamic> map) {
    return ModuleInstanceEntity(
      moduleInstanceID: map[ID_MODULE_INSTANCE] as int?,
      moduleID: map[ID_MODULE_FK] as int,
      evaluationID: map[ID_EVALUATION_FK] as int,
      status: ModuleStatusExtension.fromNumericValue(map[MODULE_INSTANCE_STATUS] as int),
    );
  }


  Future<ModuleEntity?> get module async {
    if (_module == null) {
      _module = await Get.find<ModuleRepository>().getModule(moduleID);
    }
    return _module;
  }
  @override
  String toString() {
    return 'ModuleInstanceEntity{moduleInstanceID: $moduleInstanceID, moduleID: $moduleID, evaluationID: $evaluationID, status: $status}';
  }
}
