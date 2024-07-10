library task_seeds;

import '../../app/task/task_entity.dart';
import '../../constants/assets_file_paths.dart';
import '../../constants/enums/task_enums.dart';
import '../modules/modules_seeds.dart';

part "task_seeds_list.dart";

part "task_seeds_constants.dart";


// sociodemographicInfo - 1
TaskEntity helloHowAreYouTask = TaskEntity(
  taskID: helloHowAreYouTaskId,
  title: helloHowAreYouTaskTitle,
  snakeCaseBriefTranscript: helloHowAreYouTaskSnakeCaseTranscript,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.play,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 1,
);
// sociodemographicInfo - 2
TaskEntity whatsYourNameTask = TaskEntity(
    taskID: whatsYourNameTaskId,
    title: whatsYourNameTaskTitle,
    snakeCaseBriefTranscript: whatsYourNameTaskSnakeCaseTranscript,
    moduleID: sociodemographicInfoId,
    taskMode: TaskMode.record,
    timeForCompletion: 40,
    mayRepeatPrompt: true,
    position: 2);
// sociodemographicInfo - 3
TaskEntity whatsYourDOBTask = TaskEntity(
  taskID: whatsYourDOBTaskId,
  title: whatsYourDOBTaskTitle,
  snakeCaseBriefTranscript: whatsYourDOBTaskSnakeCaseTranscript,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 3,
);
// sociodemographicInfo - 4
TaskEntity whatsYourEducationLevelTask = TaskEntity(
  taskID: whatsYourEducationLevelTaskId,
  title: whatsYourEducationLevelTaskTitle,
  snakeCaseBriefTranscript: whatsYourEducationLevelTaskSnakeCaseTranscript,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 4,
);
// sociodemographicInfo - 5
TaskEntity whatWasYourProfessionTask = TaskEntity(
  taskID: whatWasYourProfessionTaskId,
  title: whatWasYourProfessionTaskTitle,
  snakeCaseBriefTranscript: whatWasYourProfessionTaskSnakeCaseTranscript,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 5,
);
// sociodemographicInfo - 6
TaskEntity whoDoYouLiveWithTask = TaskEntity(
  taskID: whoDoYouLiveWithTaskId,
  title: whoDoYouLiveWithTaskTitle,
  snakeCaseBriefTranscript: whoDoYouLiveWithTaskSnakeCaseTranscript,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 6,
);
// sociodemographicInfo - 7
TaskEntity doYouExerciseFrequentlyTask = TaskEntity(
  taskID: doYouExerciseFrequentlyTaskId,
  title: doYouExerciseFrequentlyTaskTitle,
  snakeCaseBriefTranscript: doYouExerciseFrequentlyTaskSnakeCaseTranscript ,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 7,
);
// sociodemographicInfo - 8
TaskEntity doYouReadFrequentlyTask = TaskEntity(
  taskID: doYouReadFrequentlyTaskId,
  title: doYouReadFrequentlyTaskTitle,
  snakeCaseBriefTranscript: doYouReadFrequentlyTaskSnakeCaseTranscript,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 8,
);
// sociodemographicInfo - 9
TaskEntity doYouPlayPuzzlesOrVideoGamesFrequentlyTask = TaskEntity(
  taskID: doYouPlayPuzzlesOrVideoGamesFrequentlyTaskId,
  title: doYouPlayPuzzlesOrVideoGamesFrequentlyTaskTitle,
  snakeCaseBriefTranscript: doYouPlayPuzzlesOrVideoGamesFrequentlyTaskSnakeCaseTranscript,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 9,
);
// sociodemographicInfo - 10
TaskEntity doYouHaveAnyDiseasesTask = TaskEntity(
  taskID: doYouHaveAnyDiseasesTaskId,
  title: doYouHaveAnyDiseasesTaskTitle,
  snakeCaseBriefTranscript: doYouHaveAnyDiseasesTaskSnakeCaseTranscript,
  moduleID: sociodemographicInfoId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 10,
);
// cognitiveFunctions - 1
TaskEntity payCloseAttentionTask = TaskEntity(
  taskID: payCloseAttentionTaskId,
  title: payCloseAttentionTaskTitle,
  snakeCaseBriefTranscript: payCloseAttentionTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.play,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 1,
);
// cognitiveFunctions - 2
TaskEntity subtracting3AndAgainTask = TaskEntity(
  taskID: subtracting3AndAgainTaskId,
  title: subtracting3AndAgainTaskTitle,
  snakeCaseBriefTranscript: subtracting3AndAgainTaskSnakeCaseTranscript ,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: false,
  position: 2,
);
// cognitiveFunctions - 3
TaskEntity whatYearAreWeInTask = TaskEntity(
  taskID: whatYearAreWeInTaskId,
  title: whatYearAreWeInTaskTitle,
  snakeCaseBriefTranscript: whatYearAreWeInTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 3,
);
// cognitiveFunctions - 4
TaskEntity whatMonthAreWeInTask = TaskEntity(
  taskID: whatMonthAreWeInTaskId,
  title: whatMonthAreWeInTaskTitle,
  snakeCaseBriefTranscript: whatMonthAreWeInTaskSnakeCaseTranscript ,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 4,
);
// cognitiveFunctions - 5
TaskEntity whatDayOfTheMonthIsItTask = TaskEntity(
  taskID: whatDayOfTheMonthIsItTaskId,
  title: whatDayOfTheMonthIsItTaskTitle,
  snakeCaseBriefTranscript: whatDayOfTheMonthIsItTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 5,
);
// cognitiveFunctions - 6
TaskEntity whatDayOfTheWeekIsItTask = TaskEntity(
  taskID: whatDayOfTheWeekIsItTaskId,
  title: whatDayOfTheWeekIsItTaskTitle,
  snakeCaseBriefTranscript: whatDayOfTheWeekIsItTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 6,
);
// cognitiveFunctions - 7
TaskEntity howOldAreYouTask = TaskEntity(
  taskID: howOldAreYouTaskId,
  title: howOldAreYouTaskTitle,
  snakeCaseBriefTranscript: howOldAreYouTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 7,
);
// cognitiveFunctions - 8
TaskEntity whereAreWeNowTask = TaskEntity(
  taskID: whereAreWeNowTaskId,
  title: whereAreWeNowTaskTitle,
  snakeCaseBriefTranscript: whereAreWeNowTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 8,
);
// cognitiveFunctions - 9
TaskEntity currentPresidentOfBrazilTask = TaskEntity(
  taskID: currentPresidentOfBrazilTaskId,
  title: currentPresidentOfBrazilTaskTitle,
  snakeCaseBriefTranscript: currentPresidentOfBrazilTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 9,
);
// cognitiveFunctions - 10
TaskEntity formerPresidentOfBrazilTask = TaskEntity(
  taskID: formerPresidentOfBrazilTaskId,
  title: formerPresidentOfBrazilTaskTitle,
  snakeCaseBriefTranscript: formerPresidentOfBrazilTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 10,
);
// cognitiveFunctions - 11
TaskEntity repeatWordsAfterListeningFirstTimeTask = TaskEntity(
  taskID: repeatWordsAfterListeningFirstTimeTaskId,
  title: repeatWordsAfterListeningFirstTimeTaskTitle,
  snakeCaseBriefTranscript: repeatWordsAfterListeningFirstTimeTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.play,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 11,
);
// cognitiveFunctions - 12
TaskEntity recallWordsFromListFirstTimeTask = TaskEntity(
  taskID: recallWordsFromListFirstTimeTaskId,
  title: recallWordsFromListFirstTimeTaskTitle,
  snakeCaseBriefTranscript: recallWordsFromListFirstTimeTaskSnakeCaseTranscript ,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: false,
  position: 12,
);
// cognitiveFunctions - 13
TaskEntity repeatWordsAfterListeningSecondTimeTask = TaskEntity(
  taskID: repeatWordsAfterListeningSecondTimeTaskId,
  title: repeatWordsAfterListeningSecondTimeTaskTitle,
  snakeCaseBriefTranscript: repeatWordsAfterListeningSecondTimeTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.play,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 13,
);
// cognitiveFunctions - 14
TaskEntity recallWordsFromListSecondTimeTask = TaskEntity(
  taskID: recallWordsFromListSecondTimeTaskId,
  title: recallWordsFromListSecondTimeTaskTitle,
  snakeCaseBriefTranscript: recallWordsFromListSecondTimeTaskSnakeCaseTranscript ,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: false,
  position: 14,
);
// cognitiveFunctions - 15
TaskEntity repeatWordsAfterListeningThirdTimeTask = TaskEntity(
  taskID: repeatWordsAfterListeningThirdTimeTaskId,
  title: repeatWordsAfterListeningThirdTimeTaskTitle,
  snakeCaseBriefTranscript: repeatWordsAfterListeningThirdTimeTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.play,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 15,
);
// cognitiveFunctions - 16
TaskEntity recallWordsFromListThirdTimeTask = TaskEntity(
  taskID: recallWordsFromListThirdTimeTaskId,
  title: recallWordsFromListThirdTimeTaskTitle,
  snakeCaseBriefTranscript: recallWordsFromListThirdTimeTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: false,
  position: 16,
);
// cognitiveFunctions - 17
TaskEntity whatDidYouDoYesterdayTask = TaskEntity(
  taskID: whatDidYouDoYesterdayTaskId,
  title: whatDidYouDoYesterdayTaskTitle,
  snakeCaseBriefTranscript: whatDidYouDoYesterdayTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 17,
);
// cognitiveFunctions - 18
TaskEntity favoriteChildhoodGameTask = TaskEntity(
  taskID: favoriteChildhoodGameTaskId,
  title: favoriteChildhoodGameTaskTitle,
  snakeCaseBriefTranscript: favoriteChildhoodGameTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 18,
);
// cognitiveFunctions - 19
TaskEntity retellWordsHeardBeforeTask = TaskEntity(
  taskID: retellWordsHeardBeforeTaskId,
  title: retellWordsHeardBeforeTaskTitle,
  snakeCaseBriefTranscript: retellWordsHeardBeforeTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 19,
);
// cognitiveFunctions - 20
TaskEntity payCloseAttentionToTheStoryTask = TaskEntity(
  taskID: payCloseAttentionToTheStoryTaskId,
  title: payCloseAttentionToTheStoryTaskTitle,
  snakeCaseBriefTranscript: payCloseAttentionToTheStoryTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.play,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 20,
);
// cognitiveFunctions - 21
TaskEntity anasCatStoryTask = TaskEntity(
  taskID: anasCatStoryTaskId,
  title: anasCatStoryTaskTitle,
  snakeCaseBriefTranscript: anasCatStoryTaskSnakeCaseTranscript ,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: false,
  position: 21,
);
// cognitiveFunctions - 22
TaskEntity howManyAnimalsCanYouThinkOfTask = TaskEntity(
  taskID: howManyAnimalsCanYouThinkOfTaskId,
  title: howManyAnimalsCanYouThinkOfTaskTitle,
  snakeCaseBriefTranscript: howManyAnimalsCanYouThinkOfTaskSnakeCaseTranscript ,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 22,
);
// cognitiveFunctions - 23
TaskEntity wordsStartingWithFTask = TaskEntity(
  taskID: wordsStartingWithFTaskId,
  title: wordsStartingWithFTaskTitle,
  snakeCaseBriefTranscript: wordsStartingWithFTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 23,
);
// cognitiveFunctions - 24
TaskEntity wordsStartingWithATask = TaskEntity(
  taskID: wordsStartingWithATaskId,
  title: wordsStartingWithATaskTitle,
  snakeCaseBriefTranscript: wordsStartingWithATaskSnakeCaseTranscript ,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 24,
);
// cognitiveFunctions - 25
TaskEntity wordsStartingWithSTask = TaskEntity(
  taskID: wordsStartingWithSTaskId,
  title: wordsStartingWithSTaskTitle,
  snakeCaseBriefTranscript: wordsStartingWithSTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 25,
);
// cognitiveFunctions - 26
TaskEntity describeWhatYouSeeTask = TaskEntity(
  taskID: describeWhatYouSeeTaskId,
  title: describeWhatYouSeeTaskTitle,
  snakeCaseBriefTranscript: describeWhatYouSeeTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  imagePath: ImageFilePaths.describe_what_you_see_task,
  position: 26,
);
// cognitiveFunctions - 27
TaskEntity retellStoryTask = TaskEntity(
  taskID: retellStoryTaskId,
  title: retellStoryTaskTitle,
  snakeCaseBriefTranscript: retellStoryTaskSnakeCaseTranscript,
  moduleID: cognitiveFunctionsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 27,
);
// functionality - 1
TaskEntity yesOrNoQuestionsTask = TaskEntity(
  taskID: yesOrNoQuestionsTaskId,
  title: yesOrNoQuestionsTaskTitle,
  snakeCaseBriefTranscript: yesOrNoQuestionsTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.play,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 1,
);
// functionality - 2
TaskEntity canYouBatheAloneTask = TaskEntity(
  taskID: canYouBatheAloneTaskId,
  title: canYouBatheAloneTaskTitle,
  snakeCaseBriefTranscript: canYouBatheAloneTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 2,
);
// functionality - 3
TaskEntity canYouDressAloneTask = TaskEntity(
  taskID: canYouDressAloneTaskId,
  title: canYouDressAloneTaskTitle,
  snakeCaseBriefTranscript: canYouDressAloneTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 3,
);
// functionality - 4
TaskEntity canYouUseToiletAloneTask = TaskEntity(
  taskID: canYouUseToiletAloneTaskId,
  title: canYouUseToiletAloneTaskTitle,
  snakeCaseBriefTranscript: canYouUseToiletAloneTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 4,
);
// functionality - 5
TaskEntity canYouUsePhoneAloneTask = TaskEntity(
  taskID: canYouUsePhoneAloneTaskId,
  title: canYouUsePhoneAloneTaskTitle,
  snakeCaseBriefTranscript: canYouUsePhoneAloneTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 5,
);
// functionality - 6
TaskEntity canYouShopAloneTask = TaskEntity(
  taskID: canYouShopAloneTaskId,
  title: canYouShopAloneTaskTitle,
  snakeCaseBriefTranscript: canYouShopAloneTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 6,
);
// functionality - 7
TaskEntity canYouHandleMoneyAloneTask = TaskEntity(
  taskID: canYouHandleMoneyAloneTaskId,
  title: canYouHandleMoneyAloneTaskTitle,
  snakeCaseBriefTranscript: canYouHandleMoneyAloneTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 7,
);
// functionality - 8
TaskEntity canYouManageMedicationAloneTask = TaskEntity(
  taskID: canYouManageMedicationAloneTaskId,
  title: canYouManageMedicationAloneTaskTitle,
  snakeCaseBriefTranscript: canYouManageMedicationAloneTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 8,
);
// functionality - 9
TaskEntity canYouUseTransportAloneTask = TaskEntity(
  taskID: canYouUseTransportAloneTaskId,
  title: canYouUseTransportAloneTaskTitle,
  snakeCaseBriefTranscript: canYouUseTransportAloneTaskSnakeCaseTranscript,
  moduleID: functionalityId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 9,
);
// depressionSymptoms - 1
TaskEntity feelingsInPastTwoWeeksTask = TaskEntity(
  taskID: feelingsInPastTwoWeeksTaskId,
  title: feelingsInPastTwoWeeksTaskTitle,
  snakeCaseBriefTranscript: feelingsInPastTwoWeeksTaskSnakeCaseTranscript,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 1,
);
// depressionSymptoms - 2
TaskEntity feelingSadFrequentlyTask = TaskEntity(
  taskID: feelingSadFrequentlyTaskId,
  title: feelingSadFrequentlyTaskTitle,
  snakeCaseBriefTranscript: feelingSadFrequentlyTaskSnakeCaseTranscript ,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 2,
);
// depressionSymptoms - 3
TaskEntity feelingTiredOrLackingEnergyTask = TaskEntity(
  taskID: feelingTiredOrLackingEnergyTaskId,
  title: feelingTiredOrLackingEnergyTaskTitle,
  snakeCaseBriefTranscript: feelingTiredOrLackingEnergyTaskSnakeCaseTranscript,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 3,
);
// depressionSymptoms - 4
TaskEntity troubleSleepingTask = TaskEntity(
  taskID: troubleSleepingTaskId,
  title: troubleSleepingTaskTitle,
  snakeCaseBriefTranscript:troubleSleepingTaskSnakeCaseTranscript ,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 4,
);
// depressionSymptoms - 5
TaskEntity preferringToStayHomeTask = TaskEntity(
  taskID: preferringToStayHomeTaskId,
  title: preferringToStayHomeTaskTitle,
  snakeCaseBriefTranscript: preferringToStayHomeTaskSnakeCaseTranscript,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 5,
);
// depressionSymptoms - 6
TaskEntity feelingUselessOrGuiltyTask = TaskEntity(
  taskID: feelingUselessOrGuiltyTaskId,
  title: feelingUselessOrGuiltyTaskTitle,
  snakeCaseBriefTranscript: feelingUselessOrGuiltyTaskSnakeCaseTranscript,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 6,
);
// depressionSymptoms - 7
TaskEntity lostInterestInActivitiesTask = TaskEntity(
  taskID: lostInterestInActivitiesTaskId,
  title: lostInterestInActivitiesTaskTitle,
  snakeCaseBriefTranscript: lostInterestInActivitiesTaskSnakeCaseTranscript ,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 7,
);
// depressionSymptoms - 8
TaskEntity hopefulAboutFutureTask = TaskEntity(
  taskID: hopefulAboutFutureTaskId,
  title: hopefulAboutFutureTaskTitle,
  snakeCaseBriefTranscript: hopefulAboutFutureTaskSnakeCaseTranscript,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 8,
);
// depressionSymptoms - 9
TaskEntity feelingLifeIsWorthLivingTask = TaskEntity(
  taskID: feelingLifeIsWorthLivingTaskId,
  title: feelingLifeIsWorthLivingTaskTitle,
  snakeCaseBriefTranscript: feelingLifeIsWorthLivingTaskSnakeCaseTranscript,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.record,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 9,
);
// depressionSymptoms - 10
TaskEntity thankingForParticipationTask = TaskEntity(
  taskID: thankingForParticipationTaskId,
  title: thankingForParticipationTaskTitle,
  snakeCaseBriefTranscript: thankingForParticipationTaskSnakeCaseTranscript,
  moduleID: depressionSymptomsId,
  taskMode: TaskMode.play,
  timeForCompletion: 40,
  mayRepeatPrompt: true,
  position: 10,
);

////////////////////////////////////////////

// TASKS VERIFICAÇÃO

TaskEntity pressaInimigaTask = TaskEntity(
  taskID: pressaInimigaTaskId,
  title: pressaInimigaTaskTitle,
  snakeCaseBriefTranscript: pressaInimigaTaskSnakeCaseTranscript,
  moduleID: testsModuleId,
  taskMode: TaskMode.play,
  position: 1,
);

TaskEntity conteAte5Task = TaskEntity(
    taskID: conteAte5TaskId,
    moduleID: testsModuleId,
    title: conteAte5TaskTitle,
    snakeCaseBriefTranscript: conteAte5TaskSnakeCaseTranscript,
    taskMode: TaskMode.record,
    position: 2);

