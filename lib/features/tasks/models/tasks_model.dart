import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

class TasksModel extends ChangeNotifier {
  TasksModel() {
    tasksBoxListenable = _taskService.taskBoxlistenable;
    notifyListeners();
  }
  TaskService _taskService = TaskService();
  late ValueListenable<Box<Task>> tasksBoxListenable;
  // предбилд метод для нотифаера, который раскдывает таски
  // в момент создания/удаления новой
  setTasksToGroups() {
    final box = _taskService.taskBoxlistenable.value.values;
    activeTasks = box.where((task) => task.isActive == true).toList();
    inactiveTasks = box.where((task) => task.isActive == false).toList();
  }

  // Списки будут показывать содержимое ListViewBuilder для каждого типа таски
  // Слушатель для бокса в корне виджета все равно нельзя убирать.
  // т.к. он будет реагировть на создание/удаление тасков. Перебрасывание между
  // списками - провайдер и списки.
  List<Task> activeTasks = [];
  List<Task> inactiveTasks = [];
  deleteTask(String taskId) async {
    await _taskService.deleteTaskFromBoxById(taskId);
  }

  deleteSprintGoalFromBox(String taskId) async {
    await _taskService.deleteSprintGoal(taskId);
  }

  Future<void> dropTaskToActiveGroup(String taskId) async {
    //получаем элемент по index и меняем его статус
    final indexInInactive =
        inactiveTasks.indexWhere((task) => task.id == taskId);

    Task task = inactiveTasks[indexInInactive];
    task.isActive = true;
    await task.save();
    notifyListeners();
  }

  Future<void> dropTaskToInactiveGroup(String taskId) async {
    // получаем index и элемент по нему
    final indexInActive = activeTasks.indexWhere((task) => task.id == taskId);
    Task task = activeTasks[indexInActive];
    task.isActive = false;
    await task.save();

    notifyListeners();
  }



  toNewTaskModel(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.taskForm);
  }
}

class TasksProvider extends InheritedNotifier<TasksModel> {
  final TasksModel model;
  const TasksProvider({Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static TasksModel? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TasksProvider>()?.model;
  }

  static TasksProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksProvider>()
        ?.widget;
    return widget is TasksProvider ? widget : null;
  }
}
