import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/evaluator/evaluator_entity.dart';
import '../../app/evaluator/evaluator_local_datasource.dart';
import '../../app/evaluator/evaluator_repository.dart';

class EvaluatorsController extends GetxController {
  var evaluatorsList = <EvaluatorEntity>[].obs;
  var filteredEvaluatorsList = <EvaluatorEntity>[].obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchEvaluators();

    // Add listener to searchController
    searchController.addListener(() {
      performSearch(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void fetchEvaluators() async {
    var evaluators = await EvaluatorRepository(
        localDataSource: EvaluatorLocalDataSource()).getAllEvaluators();
    evaluatorsList.assignAll(evaluators);
    filteredEvaluatorsList.assignAll(
        evaluators);

  }

  void performSearch(String query) {
    if (query.isEmpty) {
      filteredEvaluatorsList.assignAll(evaluatorsList);
    } else {
      filteredEvaluatorsList.assignAll(
        evaluatorsList.where((evaluator) {
          return evaluator.name.toLowerCase().contains(query.toLowerCase()) ||
              evaluator.surname.toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    }
    update();
  }

  void addEvaluator(EvaluatorEntity newEvaluator) {
    evaluatorsList.add(newEvaluator);
    // performSearch(searchController.text);

    // Refresh the filtered list
    performSearch('');
   

    update();
  }
}

