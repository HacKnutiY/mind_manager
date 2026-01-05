import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/utils/utils.dart';

class TaskService {
  late Box<Task> _sprintTasksBox;
  late ValueListenable<Box<Task>> _sprintTaskBoxListenable;
  ValueListenable<Box<Task>> get sprintTaskBoxlistenable =>
      _sprintTaskBoxListenable;

  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;

  static final ValueNotifier<List<Task>> createdSprintTasksListener =
      ValueNotifier<List<Task>>([]);

  TaskService() {
    init();
  }
  init() {
    _sprintTasksBox = Hive.box<Task>(Constants.sprintTasksBoxName);
    _allTasks = _sprintTasksBox.values.toList();
    _sprintTaskBoxListenable = _sprintTasksBox.listenable();
  }

  deleteSprintTaskFromBoxById(String taskId) async {
    for (Task task in _sprintTasksBox.values.toList()) {
      if (task.id == taskId) {
        await _sprintTasksBox.delete(task.key);
      }
    }
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

  addTaskToList(Task task) {
    createdSprintTasksListener.value = [
      ...createdSprintTasksListener.value,
      task
    ];
  }

  addTaskToBox(Task task) {
    _sprintTasksBox.add(task);
  }

  addTasksListToBox(List<Task> tasks) {
    for (Task task in tasks) {
      addTaskToBox(task);
    }
  }
}
