import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/utils/new_task.dart';
import 'package:mind_manager/utils/utils.dart';

class NewTaskModel extends NewTask {
  generateId() {
    final now = DateTime.now();
    final random = Random().nextInt(9999);
    return "$now$random";
  }

  @override
  saveTask(BuildContext context, [int? sprintKey]) async {
    if (isFieldsValid()) {
      errorText = "";
      Task task = Task(
        id: generateId(), //поменять для фичи удаления таска
        text: taskText.toString(),
        activityType: activityType.toString(),
        isComplete: false,
      );
      //в бокс добавить для тасков
      await taskService.addTaskToBox(task);

      Navigator.pop(context);
    } else {
      errorText = Constants.emptyFieldsError;
      notifyListeners();
    }
  }
}

class NewTaskProvider extends InheritedNotifier<NewTaskModel> {
  final NewTaskModel model;
  const NewTaskProvider({Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static NewTaskModel? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NewTaskProvider>()?.model;
  }

  static NewTaskProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NewTaskProvider>()
        ?.widget;
    return widget is NewTaskProvider ? widget : null;
  }
}
