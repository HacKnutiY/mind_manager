import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/navigation/main_navigation.dart';
import 'package:intl/intl.dart';

class SprintTileModel extends ChangeNotifier {
  /*
- методы для форматирования дат
*/
  SprintTileModel({
    required this.sprintKey,
    required this.startDate,
    required this.endDate,
  }) {
    sprintGoalsBoxListenable = _taskService.sprintGoalsBoxListenable;
  }
  DateTime startDate;
  DateTime endDate;
  int sprintKey;
  String get formattedStartDate => DateFormat('dd.MM.yyyy').format(startDate);
  String get formattedEndDate => DateFormat('dd.MM.yyyy').format(endDate);
  final TaskService _taskService = TaskService();
  late ValueListenable<Box<Task>> sprintGoalsBoxListenable;

  List<Task> getActualSprintGoals(int sprintKey) {
    return _taskService.getCurrentSprintGoals(sprintKey: sprintKey);
  }

  //-------------навигация--------------//
  toSprintScreen(BuildContext context, int sprintKey) {
    Navigator.pushNamed(
      context,
      RouteNames.sprintInfo,
      arguments: sprintKey,
    );
  }
}

class SprintsBuilderProvider extends InheritedNotifier<SprintTileModel> {
  final SprintTileModel model;
  const SprintsBuilderProvider(
      {Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static SprintTileModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SprintsBuilderProvider>()
        ?.model;
  }

  static SprintsBuilderProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<SprintsBuilderProvider>()
        ?.widget;
    return widget is SprintsBuilderProvider ? widget : null;
  }
}

/*
model!
        .sprintTasks(sprint.key as int)
        .map((task) => TaskTileWidget(task: task))
        .toList();

        преобразование в виджет моделька занимается?
 */
