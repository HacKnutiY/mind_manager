import 'package:flutter/widgets.dart';
import 'package:mind_manager/entities/term_goal.dart';

class ActualGoalsManager {
  //----------конструкторы
  ActualGoalsManager._internal(); //извне чтобы не создавали ниче
  factory ActualGoalsManager() {
    return _instance;
  }

  //----------единственный экземпляр
  static final ActualGoalsManager _instance = ActualGoalsManager._internal();

  //----------поля
  static List<TermGoal> _actualGoals = [];
  static List<TermGoal> get goals => _actualGoals;

  //----------методы
  static ValueNotifier<List<TermGoal>> goalsListener =
      ValueNotifier<List<TermGoal>>(_actualGoals);
  addActual(TermGoal goal) {
    goalsListener.value = [...goalsListener.value, goal];
  }
}
