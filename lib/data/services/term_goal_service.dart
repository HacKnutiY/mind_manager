import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'dart:math';

import 'package:mind_manager/utils/const_strings.dart';

class TermGoalsService {
  Future<List<TermGoal>> getActivityTermsFromBoxByKey(int activityKey) async {
    Box<TermGoal> termGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);
    List<TermGoal> terms = termGoalsBox.values.toList();
    return terms;
  }

  TermGoal getTermById(String goalId) {
    Box<TermGoal> termGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);

    TermGoal? goal;
    for (TermGoal term in termGoalsBox.values) {
      if (term.id == goalId) {
        goal = term;
      }
    }
    return goal ??
        TermGoal(
            text: "text",
            firstDate: DateTime(1),
            lastDate: DateTime(1),
            isComplete: false,
            id: "aasdsa",
            activityKey: 4);
  }

  //------------МЕТОД УДАЛЕНИЯ----------------//

  Future<void> deleteTermFromBoxById(String goalId) async {
    TermGoal term = getTermById(goalId);
    Box<TermGoal> termGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);
    await termGoalsBox.delete(term.key);
    // ребилд на билдере
  }

  deleteActivityTerms(int activityKey) {
    Box<TermGoal> _termGoalsBox =
        Hive.box<TermGoal>(Constants.termGoalsBoxName);

    for (TermGoal term in _termGoalsBox.values) {
      if (term.activityKey == activityKey) {
        _termGoalsBox.delete(term.key);
      }
    }
  }

  generateGoalId() {
    final now = DateTime.now();
    final random = Random().nextInt(9999);
    return "$now$random";
  }
}
