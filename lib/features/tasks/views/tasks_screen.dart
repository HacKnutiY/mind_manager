import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/task.dart' show Task;
import 'package:mind_manager/features/tasks/models/tasks_model.dart';
import 'package:mind_manager/features/tasks/views/widgets/task_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    TasksModel model = TasksModel();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          model.toNewTaskModel(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Задачи"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Task>>(
        builder: (BuildContext context, Box<Task> box, Widget? child) {
          return SizedBox(
            height: 550,
            child: ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) => TaskTileWidget(
                task: box.values.toList()[index],
              ),
            ),
          );
        },
        valueListenable: model.tasksBoxListenable, //not work
      ),
    );
  }
}


// ValueListenableBuilder<Box<Task>>(
//               builder: (BuildContext context, Box<Task> a, Widget? child) {
//                 var boxListenerValues = model?.tasksBoxListenable.value.values;
//                 return SizedBox(
//                   height: 150,
//                   child: ListView.builder(
//                     itemCount: boxListenerValues?.length,
//                     itemBuilder: (context, index) => SprintGoalTileWidget(
//                       task: boxListenerValues!.toList()[index],
//                     ),
//                   ),
//                 );
//               },
//               valueListenable: model!.tasksBoxListenable, //бокс.листен
//             ),