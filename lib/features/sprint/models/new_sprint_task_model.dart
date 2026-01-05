import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mind_manager/data/entities/activity.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/navigation/main_navigation.dart';
import 'package:mind_manager/utils/utils.dart';

class NewSprintTaskModel extends ChangeNotifier {
  late Box<Task> sprintTasksBox;
  String? activityType;
  String? taskText;
  late List<String> activitiesSeletion;
  String errorText = "";

  TaskService _taskService = TaskService();

  NewSprintTaskModel() {
    init();
  }

  init() {
    //заполянем список существующими направлениями
    loadActivitiesTypesForSelection();

    notifyListeners();
  }

  loadActivitiesTypesForSelection() {
    sprintTasksBox = Hive.box<Task>(Constants.sprintTasksBoxName);

    List<Activity> activities =
        Hive.box<Activity>(Constants.activitiesBoxName).values.toList();
    activitiesSeletion = activities.map((act) => act.name).toList();
  }

  reloadActivityNameValueInField(String selectTaskName) {
    activityType = selectTaskName;
    notifyListeners();
  }

  bool isFieldsValid() {
    if (activityType == null || taskText == null) {
      return false;
    } else {
      return true;
    }
  }

  //сначала добавим в локальный список модели
  generateId() {
    final now = DateTime.now();
    final random = Random().nextInt(9999);
    return "$now$random";
  }

  saveTask(BuildContext context, [int? sprintKey]) {
    bool isCreateForNewSprint = sprintKey == null;
    if (isFieldsValid()) {
      errorText = "";
      Task task = Task(
        id: generateId(), //поменять для фичи удаления таска
        text: taskText.toString(),
        activityType: activityType.toString(),
        isComplete: false,
        sprintKey: sprintKey,
      );
      isCreateForNewSprint
          ? _taskService.addTaskToList(task)
          : _taskService.addTaskToBox(task);

      Navigator.pop(context);
    } else {
      errorText = Constants.emptyFieldsError;
      notifyListeners();
    }
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
}

class NewSprintTaskProvider extends InheritedNotifier<NewSprintTaskModel> {
  final NewSprintTaskModel model;
  const NewSprintTaskProvider(
      {Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static NewSprintTaskModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NewSprintTaskProvider>()
        ?.model;
  }

  static NewSprintTaskProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NewSprintTaskProvider>()
        ?.widget;
    return widget is NewSprintTaskProvider ? widget : null;
  }
}
