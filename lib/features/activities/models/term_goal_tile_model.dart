import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/data/services/term_goal_service.dart';

/*
последняя задача - убрать termGoal в качестве параметра, чтобы 
в мультипровайдер спокойно его закинуть на экране активностей
*/
class TermGoalTileModel extends ChangeNotifier {
  final TermGoalsService _service = TermGoalsService();

  String getLastDate(String goalId) {
    TermGoal termGoal = _service.getTermById(goalId);
    return DateFormat('dd.MM.yyyy').format(termGoal.lastDate!);
  }

   String geLeftDays(String goalId){
    TermGoal termGoal = _service.getTermById(goalId);
    var leftDays = termGoal.lastDate!.difference(termGoal.firstDate!).inDays;
    return "$leftDays";
  }

  Future<void> deleteTerm(String goalId) async {
    await _service.deleteTermFromBoxById(goalId);
  }

  void completeTerm(String goalId) async {
    TermGoal termGoal = _service.getTermById(goalId);
    termGoal.isComplete = true;
    await termGoal.save();

    notifyListeners();
  }
}
