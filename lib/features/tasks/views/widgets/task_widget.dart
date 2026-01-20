import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/features/sprint/models/task_tile_model.dart';

class TaskTileWidget extends StatefulWidget {
  Task task;
  TaskTileWidget({required this.task, super.key});

  @override
  State<TaskTileWidget> createState() => _TaskTileWidgetState();
}

class _TaskTileWidgetState extends State<TaskTileWidget> {
  @override
  Widget build(BuildContext context) {
    TaskTileModel model = TaskTileModel();
    Task task = widget.task;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async =>
          {await model.deleteTaskFromBox(task.id)},
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: CheckboxListTile(
        value: widget.task.isComplete,
        onChanged: (bool? value) {
          setState(() {
            task.isComplete = value!;
          });
        },
        title: Text(
          "[${task.activityType}]",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(task.text),
        isThreeLine: true,
      ),
    );
  }
}

/*
Dismissible(
          background: Container(color: Colors.green),
          key: ValueKey<int>(items[index]),
          onDismissed: (DismissDirection direction) {
            setState(() {
              items.removeAt(index);
            });
          },
          child: ListTile(title: Text('Item ${items[index]}')),
        );
Dismissible(
  // Ключ для уникальной идентификации элемента (обязательный)
  key: Key(task.id.toString()),
  // Основной контент карточки цели
  child: ListTile(
    title: Text(task.title),
    leading: Checkbox(...), // Ваш чекбокс
  ),
  // Фон при смахивании вправо (например, для архивации)
  background: Container(
    color: Colors.green,
    alignment: Alignment.centerLeft,
    child: Icon(Icons.archive, color: Colors.white),
  ),
  // Фон при смахивании влево (например, для удаления)
  secondaryBackground: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    child: Icon(Icons.delete, color: Colors.white),
  ),
*/
