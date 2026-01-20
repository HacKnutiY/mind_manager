import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

class TasksModel {
  TaskService _taskService = TaskService();
  late ValueListenable<Box<Task>> tasksBoxListenable;

  TasksModel() {
    tasksBoxListenable = _taskService.taskBoxlistenable;
  }

  toNewTaskModel(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.taskForm);
  }
}
