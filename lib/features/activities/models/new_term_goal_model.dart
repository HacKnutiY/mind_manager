//обычный инхерит, можно и без notify обойтись
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTermGoalModel {
  String text = "";
  String id = "";
  DateTime? firstDate;
  DateTime? lastDate;


/*
  Future<int> saveGoal(TermGoal goal) {
    //Создать объект долгосрока. Генерация id -> ("activityId_")
    final key = await goalsBox.add(goal); // Hive сам генерирует ключ
    
    goal.id = key.toString(); // "0", "1", "2"...
    goalsBox.put(key, goal); // обновляем с ID
    return key;
  }
*/
  Future<DateTime> parsedSelectedDate(
      BuildContext context, TextEditingController controller) async {
    return selectDate(context, controller).then(
      (value) => DateFormat('dd.MM.yyyy').parse(controller.text),
    );
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('dd.MM.yyyy').format(picked);
    }
  }
}

class NewTermGoalProvider extends InheritedWidget {
  final NewTermGoalModel model;
  const NewTermGoalProvider({
    required this.model,
    super.key,
    required super.child,
  });
//По сути след 2 метода прописаны для дочерних элементов инхерита для быстрого поиска его по дереву
//В один конкретный момент модельку объявленную выше использует один конкретный виджет
  static NewTermGoalProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NewTermGoalProvider>();
  }

  static NewTermGoalProvider? read(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<NewTermGoalProvider>()
        ?.widget as NewTermGoalProvider;
  }

  @override
  bool updateShouldNotify(covariant NewTermGoalProvider oldWidget) {
    return false;
  }
}
