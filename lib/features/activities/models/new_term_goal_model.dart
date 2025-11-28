//обычный инхерит, можно и без notify обойтись

import 'package:flutter/material.dart';

import 'package:mind_manager/utils/box_manager.dart';
import 'package:mind_manager/utils/utils.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/data/services/actual_goals_manager.dart';

class NewTermGoalModel extends ChangeNotifier {
  String text = "";

  DateTime? firstDate;
  DateTime? lastDate;
  //errors strings
  String? nameFieldErrorMesssage;
  String? firstDateFieldErrorMesssage;
  String? lastDateFieldErrorMesssage;

  int activityKey;

  NewTermGoalModel({required this.activityKey});
/*
слушатель на бокс целей направления
  directionBox.watch().listen((event) {
  if (event.deleted) {
    // Когда удаляем из основного - автоматически удаляем из активных
    activeBox.delete('direction1_${event.key}');
  }
});
*/
  ActualGoalsService actualManager = ActualGoalsService();

  saveTermGoal(BuildContext context) async {
    if (_isFieldsValid()) {
      String termGoalBoxName = BoxManager.instance.getBoxName(
          activityKey: activityKey, boxName: Constants.actualTermGoalBoxName);
      TermGoal goal = TermGoal(
        text: text,
        firstDate: firstDate,
        lastDate: lastDate,
        id: actualManager.generateGoalId(),
        isComplete: false,
      );

      var termGoalsBox =
          BoxManager.instance.openTermGoalBox(activityKey: activityKey);
      await (await termGoalsBox).add(goal);

      if (context.mounted) {
        Navigator.pop(context);
      }
      actualManager.addActual(goal);
    } else {
      notifyListeners();
    }
  }

  bool _isFieldsValid() {
    nameFieldErrorMesssage = text.isEmpty ? Constants.emptyFieldError : null;
    firstDateFieldErrorMesssage =
        firstDate == null ? Constants.emptyFieldError : null;
    lastDateFieldErrorMesssage =
        lastDate == null ? Constants.emptyFieldError : null;

    return nameFieldErrorMesssage == null &&
        firstDateFieldErrorMesssage == null &&
        lastDateFieldErrorMesssage == null;
  }

  Future<DateTime?> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await pickDateFromDialog(context);
    if (pickedDate != null) {
      //заполняем поле
      controller.text = formateDateTextFromController(pickedDate);
      return pickedDate;
    }
  }

  Future<DateTime?> pickDateFromDialog(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
  }

  String formateDateTextFromController(
    DateTime pickedDate,
  ) =>
      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
}

class NewTermGoalProvider extends InheritedNotifier<NewTermGoalModel> {
  final NewTermGoalModel model;
  const NewTermGoalProvider({
    required this.model,
    super.key,
    required super.child,
  }) : super(notifier: model);

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
