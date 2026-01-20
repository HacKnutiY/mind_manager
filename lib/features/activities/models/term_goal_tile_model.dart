import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/data/services/term_goal_service.dart';

class TermGoalTileModel {
  TermGoal termGoal;
  TermGoalTileModel({required this.termGoal}) {
    lastDate =
        "${termGoal.lastDate?.day}/${termGoal.lastDate?.month}/${termGoal.lastDate?.year}";
  }

  late String lastDate;
  TermGoalsService _service = TermGoalsService();

  deleteTermGoal(String goalId) {
    _service.deleteTermFromBoxById(goalId);
  }

  finishTermGoal(String goalId) {
    _service.deleteTermFromActualList(goalId);
  }
}
