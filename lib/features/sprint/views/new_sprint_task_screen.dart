import 'package:flutter/material.dart';
import 'package:mind_manager/features/sprint/models/new_sprint_task_model.dart';

//сюда должен прилететь sprintKey
class NewSprintTaskScreen extends StatefulWidget {
  const NewSprintTaskScreen({
    super.key,
  });

  @override
  State<NewSprintTaskScreen> createState() => _NewSprintTaskScreenState();
}

class _NewSprintTaskScreenState extends State<NewSprintTaskScreen> {
  int? sprintKey;
  @override
  void didChangeDependencies() {
    sprintKey = ModalRoute.of(context)?.settings.arguments as int?;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    NewSprintTaskModel _model = NewSprintTaskModel();

    return NewSprintTaskProvider(
      model: _model,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Задача на спринт"),
          centerTitle: true,
        ),
        body: NewSprintTaskProvider(
          model: _model,
          child: _NewSprintTaskBody(
            sprintKey: sprintKey,
          ),
        ),
      ),
    );
  }
}

class _NewSprintTaskBody extends StatelessWidget {
  final int? sprintKey;
  const _NewSprintTaskBody({required this.sprintKey});

  @override
  Widget build(BuildContext context) {
    NewSprintTaskModel? model = NewSprintTaskProvider.watch(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu<String>(
                hintText: "Направление цели",
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
                    "${model.activityType != null ? "${model.activityType}. " : ""}Формулировка цели на спринт",
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
                  model.saveTask(context, sprintKey);
                },
                child: const Text(
                  "Добавить цель",
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
