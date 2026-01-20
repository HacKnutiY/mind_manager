import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/utils/utils.dart';

class TaskService {
  late Box<Task> _sprintTasksBox;
  late Box<Task> _tasksBox;

  late ValueListenable<Box<Task>> _sprintTaskBoxListenable;
  ValueListenable<Box<Task>> get sprintTaskBoxlistenable =>
      _sprintTaskBoxListenable;

  late ValueListenable<Box<Task>> _taskBoxListenable;
  ValueListenable<Box<Task>> get taskBoxlistenable => _taskBoxListenable;

  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;

  static final ValueNotifier<List<Task>> createdSprintTasksListener =
      ValueNotifier<List<Task>>([]);

  addTaskToBox(Task task) async {
    await _tasksBox.add(task);
  }

  clearCreatedSprintTasksList() {
    createdSprintTasksListener.value.clear();
  }

  TaskService() {
    init();
  }
  init() {
    _sprintTasksBox = Hive.box<Task>(Constants.sprintTasksBoxName);
    _tasksBox = Hive.box<Task>(Constants.tasksBoxName);
    _allTasks = _sprintTasksBox.values.toList();
    _sprintTaskBoxListenable = _sprintTasksBox.listenable();
    _taskBoxListenable = _tasksBox.listenable();
  }

  deleteSprintTaskById(String taskId) async {
    //удаляется спринт таска из врменного списка при создании спринта
    if (_deleteSprintTaskFromListById(taskId)) {
      _deleteSprintTaskFromListById(taskId);
      return;
    }
    // в случае если удаляется обычная таска
    else if ((await _deleteTaskFromBoxById(taskId))) {
      _deleteTaskFromBoxById(taskId);
      return;
    }
    //удаляется спринт таска из БОКСА
    else {
      _deleteSprintTaskFromBoxById(taskId);
    }
  }

  Future<bool> _deleteTaskFromBoxById(String taskId) async {
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

  Future<bool> _deleteSprintTaskFromBoxById(String taskId) async {
    bool hasItem = false;
    for (Task task in _sprintTasksBox.values.toList()) {
      if (task.id == taskId) {
        await _sprintTasksBox.delete(task.key);
        hasItem = true;
        return hasItem;
      }
    }
    return hasItem;
  }

  bool _deleteSprintTaskFromListById(String taskId) {
    bool hasItem = false;

    List<Task> newTasks = createdSprintTasksListener.value.toList();
    for (int index = 0; index < newTasks.length; index++) {
      if (newTasks[index].id == taskId) {
        newTasks.removeAt(index);
        createdSprintTasksListener.value = newTasks;
        hasItem = true;
        return hasItem;
      }
    }

    return hasItem;
  }

  List<Task> getSprintTasks({required int sprintKey}) {
    List<Task> sprintTasks =
        _allTasks.where((task) => task.sprintKey == sprintKey).toList();
    return sprintTasks;
  }

  deleteSprintTasks(int key) async {
    for (Task task in _sprintTasksBox.values) {
      if (task.sprintKey == key) {
        await _sprintTasksBox.delete(key);
      }
    }
  }

  addSprintTaskToList(Task task) {
    createdSprintTasksListener.value = [
      ...createdSprintTasksListener.value,
      task
    ];
  }

  addSprintTaskToBox(Task task) {
    _sprintTasksBox.add(task);
  }

  addSprintTasksListToBox(List<Task> tasks) {
    for (Task task in tasks) {
      addSprintTaskToBox(task);
    }
  }
}
