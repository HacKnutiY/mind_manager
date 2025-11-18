import 'package:flutter/material.dart';

import 'package:mind_manager/features/activities/models/new_term_goal_model.dart';

class NewTermGoalScreen extends StatefulWidget {
  final int activityKey;
  const NewTermGoalScreen({super.key, required this.activityKey});

  @override
  State<NewTermGoalScreen> createState() => _NewTermGoalScreenState();
}

class _NewTermGoalScreenState extends State<NewTermGoalScreen> {
  late NewTermGoalModel _model;
  @override
  void initState() {
    _model = NewTermGoalModel(activityKey: widget.activityKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Новая долгосрочная цель"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: NewTermGoalProvider(
          model: _model,
          child: NewTermGoalBody(),
        ),
      ),
    );
  }
}

class NewTermGoalBody extends StatelessWidget {
  NewTermGoalBody({
    super.key,
  });

  final TextEditingController firstDateFieldController =
      TextEditingController();
  final TextEditingController lastDateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model = NewTermGoalProvider.watch(context)?.model;

    return Column(
      children: [
        TextField(
          onChanged: (value) => {model?.text = value},
          decoration: InputDecoration(
            errorText: model?.nameFieldErrorMesssage,
            hintText: "Формулировка долосрочной цели",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //Поля настройки даты долгосрочной цели
        Row(
          children: [
            Expanded(
              child: _DateTextFieldWidget(
                label: "Начальнаая дата",
                controller: firstDateFieldController,
                fieldErrorMessage: model?.firstDateFieldErrorMesssage,
                onTap: () async {
                  model?.firstDate =
                      await model.selectDate(context, firstDateFieldController);
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _DateTextFieldWidget(
                label: "Конечная дата",
                controller: lastDateFieldController,
                fieldErrorMessage: model?.lastDateFieldErrorMesssage,
                onTap: () async {
                  model?.lastDate =
                      await model.selectDate(context, lastDateFieldController);
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
            onPressed: () {
              model?.saveTermGoal(context);
            },
            child: const Text(
              "Добавить долгосрочную цель",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateTextFieldWidget extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final TextEditingController controller;
  String? fieldErrorMessage;

  _DateTextFieldWidget({
    required this.label,
    required this.onTap,
    required this.controller,
    required this.fieldErrorMessage,
  });
  @override
  Widget build(BuildContext context) {
    final model = NewTermGoalProvider.watch(context)?.model;

    return TextField(
      controller: controller,
      onTap: onTap,
      decoration: InputDecoration(
        hint: Text(label),
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
