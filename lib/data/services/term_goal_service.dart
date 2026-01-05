import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'dart:math';

import 'package:mind_manager/utils/box_manager.dart';
import 'package:mind_manager/utils/utils.dart';

class TermGoalsService {
  //Поля

  //методы
  //--подгрузка долгосроков с hive для дальнейшей работы со списком активностей . по ключу тк долгосроки
  //зависят от активности (по имени бокса)
  //--удаление долгосрока
  //просто все цели вылить в лист
  Future<List<TermGoal>> getActivityTermsFromBoxByKey(int activityKey) async {
    Box<TermGoal> termGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);
    List<TermGoal> terms = termGoalsBox.values.toList();
    await BoxManager.instance.closeBox(termGoalsBox);
    return terms;
  }

  static ValueNotifier<List<TermGoal>> goalsListener =
      ValueNotifier<List<TermGoal>>([]);

  //------------МЕТОДЫ УДАЛЕНИЯ----------------//
  //метод завершения
  deleteTermFromActualList(String goalId) {
    goalsListener.value =
        goalsListener.value.where((goal) => goal.id != goalId).toList();
  }

  deleteTermFromBoxById(String goalId) {
    Box<TermGoal> termGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);
    for (TermGoal goal in termGoalsBox.values.toList()) {
      if (goal.id == goalId) {
        termGoalsBox.delete(goal.key);
      }
    }
  }

  generateGoalId() {
    final now = DateTime.now();
    final random = Random().nextInt(9999);
    return "$now$random";
  }

  addActualToList(TermGoal goal) {
    goalsListener.value = [...goalsListener.value, goal];
  }

  loadActuals() {
    List<TermGoal> terms = [];
    Box<TermGoal> termGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);

    for (TermGoal goal in termGoalsBox.values.toList()) {
      if (goal.isComplete != true) {
        terms.add(goal);
      }
    }
    goalsListener.value = terms;
  }
}
