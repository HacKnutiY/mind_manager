import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/activity.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/utils/utils.dart';

abstract class NewTask extends ChangeNotifier {
  late Box<Task> sprintTasksBox;
  String? activityType;
  String? taskText;
  late List<String> activitiesSeletion;
  String errorText = "";

  TaskService _taskService = TaskService();
  TaskService get taskService => _taskService;

  NewTask() {
    init();
  }
  //обеспечить загрузку данных
  //конструктора в наследнике тоже

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



  saveTask(BuildContext context, [int? sprintKey]) {}
}

