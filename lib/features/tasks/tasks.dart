import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/features/sprint/views/widgets/sprint_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Задачи"),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xCC284852),
        child: ListView(children: []),
      ),
    );
  }
}
