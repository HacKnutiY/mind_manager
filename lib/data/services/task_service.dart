import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/utils/const_strings.dart';

class TaskService {
  late Box<Task> _sprintGoalsBox;
  late Box<Task> _tasksBox;

  late ValueListenable<Box<Task>> _sprintGoalsBoxListenable;
  ValueListenable<Box<Task>> get sprintGoalsBoxListenable =>
      _sprintGoalsBoxListenable;

  late ValueListenable<Box<Task>> _taskBoxListenable;
  ValueListenable<Box<Task>> get taskBoxlistenable => _taskBoxListenable;

  static final ValueNotifier<List<Task>> templateSprintGoalsListener =
      ValueNotifier<List<Task>>([]);

  addTaskToBox(Task task) async {
    await _tasksBox.add(task);
  }

  clearCreatedSprintTasksList() {
    templateSprintGoalsListener.value.clear();
  }

  TaskService() {
    init();
  }
  init() {
    _sprintGoalsBox = Hive.box<Task>(Constants.sprintTasksBoxName);
    _tasksBox = Hive.box<Task>(Constants.tasksBoxName);

    _sprintGoalsBoxListenable = _sprintGoalsBox.listenable();
    _taskBoxListenable = _tasksBox.listenable();
  }

  deleteSprintGoal(String taskId) async {
    //удаляется спринт-таска из временного списка при создании спринта
    if (_deleteSprintGoalFromListById(taskId)) {
      _deleteSprintGoalFromListById(taskId);
      return;
    }

    //удаляется спринт-таска из БОКСА
    else {
      _deleteSprintGoalFromBoxById(taskId);
    }
  }

  Future<bool> deleteTaskFromBoxById(String taskId) async {
    bool hasItem = false;
    for (Task task in _tasksBox.values.toList()) {
      if (task.id == taskId) {
        await _tasksBox.delete(task.key);
        hasItem = true;
        return hasItem;
      }
    }
    return hasItem;
  }

  Future<bool> _deleteSprintGoalFromBoxById(String taskId) async {
    bool hasItem = false;
    for (Task task in _sprintGoalsBox.values.toList()) {
      if (task.id == taskId) {
        await _sprintGoalsBox.delete(task.key);
        hasItem = true;
        return hasItem;
      }
    }
    return hasItem;
  }

  bool _deleteSprintGoalFromListById(String taskId) {
    bool hasItem = false;

    List<Task> newTasks = templateSprintGoalsListener.value.toList();
    for (int index = 0; index < newTasks.length; index++) {
      if (newTasks[index].id == taskId) {
        newTasks.removeAt(index);
        templateSprintGoalsListener.value = newTasks;
        hasItem = true;
        return hasItem;
      }
    }

    return hasItem;
  }

  List<Task> getCurrentSprintGoals({required int sprintKey}) {
    List<Task> sprintGoals = _sprintGoalsBox.values
        .where((task) => task.sprintKey == sprintKey)
        .toList();
    return sprintGoals;
  }

  List<Task> getAllGoals() {
    return _sprintGoalsBox.values.toList();
  }

  deleteSprintGoals(int key) async {
    //очистить цели из общего бокса
    for (Task task in _sprintGoalsBox.values) {
      if (task.sprintKey == key) {
        await _sprintGoalsBox.delete(key);
      }
    }
    //очистить временный список
    templateSprintGoalsListener.value = [];
  }

  addSprintTaskToList(Task task) {
    templateSprintGoalsListener.value = [
      ...templateSprintGoalsListener.value,
      task
    ];
  }

  addSprintTaskToBox(Task task) {
    _sprintGoalsBox.add(task);
  }

  addSprintGoalsToBox(List<Task> tasks) {
    for (Task task in tasks) {
      addSprintTaskToBox(task);
    }
  }
}
