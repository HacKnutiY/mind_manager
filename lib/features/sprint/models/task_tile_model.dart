import 'package:flutter/material.dart';
import 'package:mind_manager/data/services/task_service.dart';

class TaskTileModel extends ChangeNotifier {
  final TaskService _service = TaskService();
  deleteTaskFromBox(String taskId) {
    _service.deleteSprintTaskFromBoxById(taskId);
  }
}
