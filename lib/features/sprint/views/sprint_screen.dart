import 'package:flutter/material.dart';

import 'package:mind_manager/features/sprint/models/sprint_model.dart';
import 'package:mind_manager/features/sprint/views/widgets/task_widget.dart';

//а отсюда sprintKey должен вылететь
class SprintScreen extends StatefulWidget {
  final int sprintKey;
  const SprintScreen({
    super.key,
    required this.sprintKey,
  });

  @override
  State<SprintScreen> createState() => _SprintScreenState();
}

class _SprintScreenState extends State<SprintScreen> {
  late SprintModel _model;
  @override
  void didChangeDependencies() {
    _model = SprintModel(sprintKey: widget.sprintKey);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_model.viewTitle),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //экран создания таска спринта
          _model.toNewSprintTaskScreen(context, widget.sprintKey);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SprintProvider(
          model: _model,
          child: _SprintBody(),
        ),
      ),
    );
  }

//тут слушатель собирался убирать, но езе подумаю над этим
  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
}

class _SprintBody extends StatefulWidget {
  _SprintBody({
    super.key,
  });

  @override
  State<_SprintBody> createState() => _SprintBodyState();
}

class _SprintBodyState extends State<_SprintBody> {
  late SprintModel? model;
  final TextEditingController firstDateFieldController =
      TextEditingController();

  final TextEditingController lastDateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    model = SprintProvider.watch(context)?.model;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Задачи на спринт",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: model?.sprintTasks.length,
              itemBuilder: (context, index) => TaskTileWidget(
                task: model!.sprintTasks[index],
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: const ButtonStyle(
                padding:
                    WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              onPressed: () {
                model?.deleteSprint();
                Navigator.pop(context);
              },
              child: const Text(
                "Удалить спринт",
                style: TextStyle(color: Colors.white),
              ),
            ),
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
