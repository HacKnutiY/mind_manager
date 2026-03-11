import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/task.dart' show Task;
import 'package:mind_manager/features/tasks/models/tasks_model.dart';
import 'package:mind_manager/features/tasks/views/widgets/task_widget.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<TasksScreen> {
  TasksModel model = TasksModel();

  @override
  Widget build(BuildContext context) {
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
      body: ChangeNotifierProvider(
        create: (context) => TasksModel(),
        child: TasksListenableBuilder(),
      ),
    );
  }
}

class TasksListenableBuilder extends StatefulWidget {
  @override
  State<TasksListenableBuilder> createState() => _TasksListenableBuilderState();
}

class _TasksListenableBuilderState extends State<TasksListenableBuilder> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 850,
      child: ValueListenableBuilder<Box<Task>>(
        builder: (BuildContext context, Box<Task> box, Widget? child) {
          context.read<TasksModel>().setTasksToGroups();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------ Incative tasks -------

              Card(
                child: ExpansionTile(
                  leading: const FlutterLogo(size: 72.0),
                  title: const Text("Неактивные задачи"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: context
                                .watch<TasksModel>()
                                .inactiveTasks
                                .length,
                            itemBuilder: (context, index) => TaskTileWidget(
                              task: context
                                  .read<TasksModel>()
                                  .inactiveTasks[index],
                              onLongPress: () => context
                                  .read<TasksModel>()
                                  .dropTaskToActiveGroup(context
                                      .read<TasksModel>()
                                      .inactiveTasks[index]
                                      .id),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(),
              // -------- Active tasks --------
              Card(
                child: ExpansionTile(
                  leading: const FlutterLogo(size: 72.0),
                  title: const Text("Активные задачи"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount:
                            context.watch<TasksModel>().activeTasks.length,
                        itemBuilder: (context, index) => TaskTileWidget(
                          task: context.read<TasksModel>().activeTasks[index],
                          onLongPress: () => context
                              .read<TasksModel>()
                              .dropTaskToInactiveGroup(context
                                  .read<TasksModel>()
                                  .activeTasks[index]
                                  .id),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        valueListenable: context.read<TasksModel>().tasksBoxListenable,
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: context.watch<TasksModel>().activeTasks.length,
        itemBuilder: (context, index) => TaskTileWidget(
          task: context.read<TasksModel>().activeTasks[index],
          onLongPress: () => context.read<TasksModel>().dropTaskToActiveGroup(
              context.read<TasksModel>().activeTasks[index].id),
        ),
      ),
    );
  }
}

class MyWidget1 extends StatelessWidget {
  const MyWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<TasksModel>().inactiveTasks.length,
      itemBuilder: (context, index) => TaskTileWidget(
        task: context.read<TasksModel>().inactiveTasks[index],
        onLongPress: () => context.read<TasksModel>().dropTaskToActiveGroup(
            context.read<TasksModel>().inactiveTasks[index].id),
      ),
    );
  }
}
