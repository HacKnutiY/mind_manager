import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/features/sprint/views/widgets/sprint_goal_widget.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

class SprintsBuilderModel extends ChangeNotifier {
  int sprintKey;
  List<SprintGoalTileWidget> sprintTasks = [];
  TaskService _taskService = TaskService();

  SprintsBuilderModel({required this.sprintKey}) {
    loadSprintTasks(sprintKey);
  }

  void loadSprintTasks(int sprintKey) {
    List<Task> tasks = _taskService.allTasks
        .where((task) => task.sprintKey == sprintKey)
        .toList();
    sprintTasks =
        tasks.map((task) => SprintGoalTileWidget(task: task)).toList();
    notifyListeners();
  }

  toSprintScreen(BuildContext context, int sprintKey) {
    Navigator.pushNamed(
      context,
      RouteNames.sprintInfo,
      arguments: sprintKey,
    );
  }
}

class SprintsBuilderProvider extends InheritedNotifier<SprintsBuilderModel> {
  final SprintsBuilderModel model;
  const SprintsBuilderProvider(
      {Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static SprintsBuilderModel? watch(BuildContext context) {
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
