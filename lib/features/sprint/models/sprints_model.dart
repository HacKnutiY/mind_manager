import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/sprint_service.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/navigation/main_navigation.dart';
import 'package:mind_manager/utils/const_strings.dart';

class SprintsModel extends ChangeNotifier {
  final SprintService _sprintService = SprintService();
  final TaskService _taskService = TaskService();
  late ValueListenable<Box<Task>> sprintGoalsBoxListenable;
  late ValueListenable<Box<Sprint>> sprintsBoxListenable;

  //короче сепарировать модель SprintGoalModel
  List<Task> sprintGoals = [];

  SprintsModel() {
    _loadBoxListenable();
  }

  _loadBoxListenable() {
    sprintGoalsBoxListenable = _taskService.sprintGoalsBoxListenable;
    sprintsBoxListenable = _sprintService.sprintsBoxListenable;
  }

  //-----Навигация------//
  toNewSprintScreen(
    BuildContext context,
  ) {
    if (_sprintService.isActiveSprintExist) {
      showSnackBar(context);
    } else {
      Navigator.pushNamed(
        context,
        RouteNames.sprintForm,
      );
    }
  }

  showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text(Constants.activeSprintAlreadyExistError),
      action: SnackBarAction(
        label: 'Хорошо!',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
