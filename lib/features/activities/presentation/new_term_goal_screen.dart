import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_manager/features/activities/models/new_term_goal_model.dart';

class NewTermGoalScreen extends StatefulWidget {
  const NewTermGoalScreen({super.key});

  @override
  State<NewTermGoalScreen> createState() => _NewTermGoalScreenState();
}

class _NewTermGoalScreenState extends State<NewTermGoalScreen> {
  NewTermGoalModel model = NewTermGoalModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NewTermGoalProvider(
          model: model,
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
    final model = NewTermGoalProvider.read(context)?.model;

    return Column(
      children: [
        TextField(
          onChanged: (value) => {},
          decoration: InputDecoration(
            hintText: "Формулировка долосрочной цели",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        //Поля настройки даты долгосрочной цели
        Row(
          children: [
            Expanded(
              child: _DateTextFieldWidget(
                label: "Начальнаая цель",
                controller: firstDateFieldController,
                onTap: () async => {
                  model?.firstDate = await model.parsedSelectedDate(
                      context, firstDateFieldController),
                },
              ),
            ),
            const SizedBox(width: 16),
            /*
            TextButton(
              onPressed: () {
                if (model?.firstDate != null && model?.lastDate != null) {
                  print("EEEEEEEEEEE");
                } else {
                  print("aaaaaaaaaaaaa");
                }
              },
              child: const Text("get a value"),
            ),
            */
            Expanded(
              child: _DateTextFieldWidget(
                label: "Конечная дата",
                controller: lastDateFieldController,
                onTap: () async => {
                  model?.lastDate = await model.parsedSelectedDate(
                      context, firstDateFieldController),
                },
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: const ButtonStyle(
              padding:
                  WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
            onPressed: () {},
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

  const _DateTextFieldWidget({
    super.key,
    required this.label,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
      ),
      readOnly: true,
    );
  }
}
