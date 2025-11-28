import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'dart:math';

class ActualGoalsService {
  //---данные добавить в случае если список используется на нескольких экранах и необходим синхрон
  //---в данном случае список АКТУАЛЬНЫХ(не с долгосроками работаем) использует только один экран - activities
  //---поэтому нет, список в сервисе не нужен

  //----------конструкторы
  ActualGoalsService._internal(); //извне чтобы не создавали ниче
  factory ActualGoalsService() {
    return _instance;
  }

  //---единственный экземпляр
  static final ActualGoalsService _instance = ActualGoalsService._internal();

  //---поля
  static ValueNotifier<List<TermGoal>> goalsListener =
      ValueNotifier<List<TermGoal>>([]);

  //----------методы
  //---в методах исправим то, что работу с ValueNotifier перенесем в модель экрана
  //---так как это тоже данные, которые синхронизировать нет нужды, они только на одном экране

  //------------МЕТОДЫ УДАЛЕНИЯ----------------//
  deleteActualFromTermBox() {}

   deleteActualFromList(String goalId) {
    goalsListener.value =
        goalsListener.value.where((goal) => goal.id != goalId).toList();
  }

  deleteActual() {

    //удаление цели из списка
    //удаление цели из бокса
  }

  generateGoalId() {
    final now = DateTime.now();
    final random = Random().nextInt(9999);
    return "$now$random";
  }

  addActual(TermGoal goal) {
    goalsListener.value = [...goalsListener.value, goal];
  }
}
