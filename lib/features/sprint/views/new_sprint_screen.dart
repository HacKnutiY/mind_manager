import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/task.dart';

import 'package:mind_manager/features/sprint/models/new_sprint_model.dart';
import 'package:mind_manager/features/sprint/views/widgets/sprint_goal_widget.dart';

class NewSprintScreen extends StatefulWidget {
  const NewSprintScreen({
    super.key,
  });

  @override
  State<NewSprintScreen> createState() => _NewSprintScreenState();
}

class _NewSprintScreenState extends State<NewSprintScreen> {
  NewSprintModel _model = NewSprintModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _model.toNewSprintTaskScreen(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Новый спринт"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: NewSprintProvider(
          model: _model,
          child: _NewSprintBody(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class _NewSprintBody extends StatefulWidget {
  _NewSprintBody({
    super.key,
  });

  @override
  State<_NewSprintBody> createState() => _NewSprintBodyState();
}

class _NewSprintBodyState extends State<_NewSprintBody> {
  late NewSprintModel? model;
  final TextEditingController firstDateFieldController =
      TextEditingController();

  final TextEditingController lastDateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    model = NewSprintProvider.watch(context)?.model;

    final listener = model?.createdSprintTasksListener;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Настройки спринта",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          onChanged: (value) => {model?.name = value},
          decoration: InputDecoration(
            errorText: model?.nameFieldErrorMesssage,
            hintText: "Имя спринта",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //Поля настройки даты спринта цели
        Row(
          children: [
            Expanded(
              child: _DateTextFieldWidget(
                hintText: "Начальная дата",
                controller: firstDateFieldController,
                fieldErrorMessage: model?.firstDateFieldErrorMesssage,
                onTap: () async {
                  model?.firstDate = await model?.selectDate(
                      context, firstDateFieldController);
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _DateTextFieldWidget(
                hintText: "Конечная дата",
                helperText: "Обычно спринт длится ~30 дней",
                controller: lastDateFieldController,
                fieldErrorMessage: model?.lastDateFieldErrorMesssage,
                onTap: () async {
                  model?.lastDate =
                      await model?.selectDate(context, lastDateFieldController);
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: const ButtonStyle(
              padding:
                  WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
            onPressed: () async {
              await model?.addSprint();
              // if (context.mounted) {
              //   Navigator.pop(context);
              // }
            },
            child: const Text(
              "Добавить спринт",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),

        const Text(
          "Задачи на спринт",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ValueListenableBuilder<List<Task>>(
            builder: (BuildContext context, List<Task> a, Widget? child) {
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: listener.value.length,
                  itemBuilder: (context, index) => SprintGoalTileWidget(
                    task: listener.value[index],
                  ),
                ),
              );
            },
            valueListenable: listener!,
          ),
        ),
      ],
    );
  }
}

class _DateTextFieldWidget extends StatelessWidget {
  final String hintText;
  final Function()? onTap;
  final TextEditingController controller;
  String? fieldErrorMessage;
  String? helperText;

  _DateTextFieldWidget({
    required this.hintText,
    required this.onTap,
    required this.controller,
    required this.fieldErrorMessage,
    this.helperText,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      decoration: InputDecoration(
        hint: Text(hintText),
        helperText: helperText ?? "",
        suffixIcon: const Icon(Icons.calendar_today),
        enabledBorder: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorText: fieldErrorMessage,
      ),
      readOnly: true,
    );
  }
}
