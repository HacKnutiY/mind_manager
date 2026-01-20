import 'package:flutter/material.dart';
import 'package:mind_manager/data/services/task_service.dart';

class TaskTileModel {
  final TaskService _service = TaskService();
  deleteTaskFromBox(String taskId) async {
    await _service.deleteSprintTaskById(taskId);
  }
}
