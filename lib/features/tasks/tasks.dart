import 'package:flutter/material.dart';

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
        child: Center(
            child: Text(
          "Tasks",
          style: TextStyle(color: Colors.white, fontSize: 30),
        )),
      ),
    );
  }
}
