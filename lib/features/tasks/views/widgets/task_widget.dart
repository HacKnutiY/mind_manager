import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/features/tasks/models/tasks_model.dart';
import 'package:provider/provider.dart';

class TaskTileWidget extends StatefulWidget {
  Task task;
  final void Function()? onLongPress;
  TaskTileWidget({required this.task, required this.onLongPress, super.key});

  @override
  State<TaskTileWidget> createState() => _TaskTileWidgetState();
}

class _TaskTileWidgetState extends State<TaskTileWidget> {
  @override
  Widget build(BuildContext context) {
    //TasksModel model = TasksProvider.watch(context)!;
    Task task = widget.task;

    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          await context.read<TasksModel>().deleteTask(task.id);
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: CheckboxListTile(
          value: task.isComplete,
          onChanged: (bool? value) async {
            setState(() {
              task.isComplete = value!;
            });
            await task.save();
          },
          title: Text(
            task.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("[${task.activityType}]"),
          isThreeLine: true,
        ),
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
