import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/data/services/sprint_service.dart';
import 'package:mind_manager/data/services/task_service.dart';
import 'package:mind_manager/navigation/main_navigation.dart';
import 'package:mind_manager/utils/utils.dart';

class NewSprintModel extends ChangeNotifier {
  //---fields---/
  DateTime? firstDate;
  DateTime? lastDate;
  String name = "";
  //---errors strings---/
  String? nameFieldErrorMesssage;
  String? firstDateFieldErrorMesssage;
  String? lastDateFieldErrorMesssage;

  List<Task> _sprintTasks = [];
  List<Task> get sprintTasks => _sprintTasks;

  final TaskService _taskService = TaskService();
  final SprintService _sprintService = SprintService();
  final ValueNotifier<List<Task>> createdSprintTasksListener =
      TaskService.createdSprintTasksListener;

  NewSprintModel() {
    clearTasksList();
  }
  //--------методы оставленs для экрана спринта
  loadTasksAndSetListenerToBox() {
    loadSprintTasks();
    setListenerToSprintTasksBox();
  }

  setListenerToSprintTasksBox() =>
      _taskService.sprintTaskBoxlistenable.addListener(loadSprintTasks);

  loadSprintTasks() {
    _sprintTasks = _taskService.allTasks;
    notifyListeners();
  }
  //--------методы оставлен для экрана спринта

  Future<void> addSprint() async {
    if (_isFieldsValid()) {
      Sprint sprint = Sprint(
        name: name,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      //закидываем спринт в бокс + сохраняем ключ
      int sprintKey = await _sprintService.addSprint(sprint);
      //каждую таску связываем со спринтом посредством sprintKey
      List<Task> tasks = await setSprintKeyToTasks(sprintKey);
      //закидываем таски в бокс
      _taskService.addTasksListToBox(tasks);
    }

    /*

    может даже добавить поле id спринтам для той же цели. хотя можно как 
    с направлениями поступить = по ключу
    итак мы можем создать спринт, теперь нужно его открывать - изменять - удалять
    но все еще остается проблема: все сущности направления спринты и таски слабо связаны
    между собой и нет иерархии и по сути никто ни от чего не зависит
    и это просто многослойный crud
     */
  }

  Future<List<Task>> setSprintKeyToTasks(int key) async {
    List<Task> tasksWithKey = [];
    for (Task task in createdSprintTasksListener.value) {
      task.sprintKey = key;
      tasksWithKey.add(task);
    }
    return tasksWithKey;
  }

  //очистить врменный таск лист
  clearTasksList() async {
    createdSprintTasksListener.value = [];
  }

  bool _isFieldsValid() {
    nameFieldErrorMesssage = name.isEmpty ? Constants.emptyFieldsError : null;
    firstDateFieldErrorMesssage =
        firstDate == null ? Constants.emptyFieldsError : null;
    lastDateFieldErrorMesssage =
        lastDate == null ? Constants.emptyFieldsError : null;

    return nameFieldErrorMesssage == null &&
        firstDateFieldErrorMesssage == null &&
        lastDateFieldErrorMesssage == null;
  }

  Future<DateTime?> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await pickDateFromDialog(context);
    if (pickedDate != null) {
      //заполняем поле
      controller.text = formateDateTextFromController(pickedDate);
      return pickedDate;
    }
  }

  Future<DateTime?> pickDateFromDialog(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime(2025, 1, 1),
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
  }

  String formateDateTextFromController(
    DateTime pickedDate,
  ) =>
      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';

  toNewSprintTaskScreen(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      RouteNames.sprintTaskForm,
    );
  }
}

class NewSprintProvider extends InheritedNotifier<NewSprintModel> {
  final NewSprintModel model;
  const NewSprintProvider({
    required this.model,
    super.key,
    required super.child,
  }) : super(notifier: model);
  static NewSprintProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NewSprintProvider>();
  }

  static NewSprintProvider? read(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<NewSprintProvider>()
        ?.widget as NewSprintProvider;
  }

  @override
  bool updateShouldNotify(covariant NewSprintProvider oldWidget) {
    return false;
  }
}
