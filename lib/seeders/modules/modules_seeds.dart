library module_seeds;

import '../../app/module/module_entity.dart';

part "modules_seeds_constants.dart";


ModuleEntity sociodemographicInfoModule = ModuleEntity(
    moduleID: sociodemographicInfoId,
    title: sociodemographicInfo);


ModuleEntity cognitiveFunctionsModule = ModuleEntity(
    moduleID: cognitiveFunctionsId,
    title: cognitiveFunctions
);

ModuleEntity functionalityModule = ModuleEntity(
    moduleID: functionalityId,
    title: functionality
);

ModuleEntity depressionSymptomsModule = ModuleEntity(
    moduleID: depressionSymptomsId,
    title: depressionSymptoms
);


ModuleEntity testsModule = ModuleEntity(
    moduleID: testsModuleId,
    title: testsModuleTitle);


List<ModuleEntity> modulesList = [
  testsModule,
  sociodemographicInfoModule,
  cognitiveFunctionsModule,
  functionalityModule,
  depressionSymptomsModule,
];

void printModules() {
  for (var i = 1; i < modulesList.length; i++) {
    print('Module $i: ${modulesList[i].title}');
  }
}