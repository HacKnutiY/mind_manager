import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/sprint_service.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

class SprintModel extends ChangeNotifier {
  SprintModel({required this.sprintKey}) {
    loadSprintData();
    loadSprintTasks();
  }

  int sprintKey;
  //---fields---/
  String _name = "";
  DateTime? _firstDate;
  String get firstDate =>
      "${_firstDate?.day}/${_firstDate?.month}/${_firstDate?.year}";
  DateTime? _lastDate;
  String get lastDate =>
      "${_lastDate?.day}/${_lastDate?.month}/${_lastDate?.year}";
  String viewTitle = "";

  SprintService _sprintService = SprintService();

  List<Task> _sprintTasks = [];
  List<Task> get sprintTasks => _sprintTasks;

  final TaskService _taskService = TaskService();

  //--------методы оставленs для экрана спринта

  loadSprintTasks() {
    _sprintTasks = _taskService.getSprintTasks(sprintKey: sprintKey);
    notifyListeners();
  }

  loadSprintData() {
    Sprint? sprint = _sprintService.getSprintFromKey(sprintKey);
    _name = sprint!.name;
    _firstDate = sprint.firstDate;
    _lastDate = sprint.lastDate;
    viewTitle = "$_name   [$firstDate - $lastDate]";
  }

  deleteSprint() {
    _sprintService.deleteSprint(sprintKey);
    _taskService.deleteSprintTasks(sprintKey);
  }

  toNewSprintTaskScreen(BuildContext context, int sprintKey) {
    Navigator.pushNamed(context, RouteNames.sprintTaskForm,
        arguments: sprintKey);
  }
  //--------методы оставлен для экрана спринта
  /*
  относительно фичи добавления - просто прямо в бокс добавлять +
  слушатель навесить, и все. А то я тут со слушателями игрался
   */
}

class SprintProvider extends InheritedNotifier<SprintModel> {
  final SprintModel model;
  const SprintProvider({
    required this.model,
    super.key,
    required super.child,
  }) : super(notifier: model);
  static SprintProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SprintProvider>();
  }

  static SprintProvider? read(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<SprintProvider>()
        ?.widget as SprintProvider;
  }

  @override
  bool updateShouldNotify(covariant SprintProvider oldWidget) {
    return false;
  }
}
