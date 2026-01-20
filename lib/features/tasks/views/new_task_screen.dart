import 'package:flutter/material.dart';
import 'package:mind_manager/features/sprint/models/new_sprint_task_model.dart';
import 'package:mind_manager/features/tasks/models/new_task_model.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({
    super.key,
  });

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    NewTaskModel _model = NewTaskModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Задача"),
        centerTitle: true,
      ),
      body: NewTaskProvider(
        model: _model,
        child: _NewTaskBody(),
      ),
    );
  }
}

class _NewTaskBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NewTaskModel? model = NewTaskProvider.watch(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu<String>(
                hintText: "Направление задачи",
                width: double.infinity,
                dropdownMenuEntries: model!.activitiesSeletion
                    .map((act) => DropdownMenuEntry(label: act, value: act))
                    .toList(),
                onSelected: (activityName) {
                  model.reloadActivityNameValueInField(activityName!);
                }),
            const SizedBox(
              height: 15,
            ),
            TextField(
              onChanged: (value) => {model.taskText = value},
              decoration: InputDecoration(
                errorText: null,
                hintText:
                    "${model.activityType != null ? "${model.activityType}. " : ""}Формулировка задачи на спринт",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              model.errorText,
              style: const TextStyle(
                  fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 20)),
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                ),
                onPressed: () {
                  model.saveTask(
                    context,
                  );
                },
                child: const Text(
                  "Добавить задачу",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
