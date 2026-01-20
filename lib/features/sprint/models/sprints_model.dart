import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/sprint_service.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/features/sprint/views/widgets/sprint_goal_widget.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

class SprintsModel extends ChangeNotifier {
  final SprintService _sprintService = SprintService();
  final TaskService _taskService = TaskService();
  //тут объявить Listeanable бокса и закинуть в листенебл билдер
  late ValueListenable<Box<Task>> tasksBoxListener;

  List<Sprint> _sprints = [];
  List<Sprint> get sprints => _sprints;
  List<SprintGoalTileWidget> sprintTasks = [];
  List<SprintGoalTileWidget> get _sprintTasks => sprintTasks;
  // List<TaskTileWidget> getSprintTasks(int sprintKey) {
  //   return _taskService.allTasks
  //       .where((task) => task.sprintKey == sprintKey)
  //       .map((task) => TaskTileWidget(task: task))
  //       .toList();
  // }

  _loadBoxListenable() {
    tasksBoxListener = _taskService.sprintTaskBoxlistenable;
  }

  void loadSprintTasks(int sprintKey) {
    List<Task> tasks = _taskService.allTasks
        .where((task) => task.sprintKey == sprintKey)
        .toList();
    sprintTasks =
        tasks.map((task) => SprintGoalTileWidget(task: task)).toList();
  }

  SprintsModel() {
    _loadSprintAndSetListenerToBox();
    notifyListeners();
    _loadBoxListenable();
  }

  _loadSprintAndSetListenerToBox() {
    _loadSprints();
    _setListenerToBox();
  }

  _loadSprints() {
    _sprints = _sprintService.getSprints();
    notifyListeners();
  }

  _setListenerToBox() {
    _sprintService.sprintsBoxListenable.addListener(_loadSprints);
  }

  //-----Навигация------//
  toNewSprintScreen(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      RouteNames.sprintForm,
    );
  }

  toSprintScreen(BuildContext context, int sprintKey) {
    Navigator.pushNamed(
      context,
      RouteNames.sprintInfo,
      arguments: sprintKey,
    );
  }
}

class SprintsProvider extends InheritedNotifier<SprintsModel> {
  final SprintsModel model;
  const SprintsProvider({Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static SprintsModel? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SprintsProvider>()?.model;
  }

  static SprintsProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<SprintsProvider>()
        ?.widget;
    return widget is SprintsProvider ? widget : null;
  }
}
