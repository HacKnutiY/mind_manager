import 'package:flutter/material.dart';
import 'package:mind_manager/features/activities/models/new_activity_model.dart';

class NewActivityScreen extends StatefulWidget {
  const NewActivityScreen({super.key});

  @override
  State<NewActivityScreen> createState() => _NewActivityConstructorState();
}

class _NewActivityConstructorState extends State<NewActivityScreen> {
  NewActivityModel model = NewActivityModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Новое направление"),
      ),
      body: NewActivityProvider(
        model: model,
        child: const _NewActivityBody(),
      ),
    );
  }
}

class _NewActivityBody extends StatelessWidget {
  const _NewActivityBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NewActivityProvider.read(context)?.model;

    return Column(
      children: [
        const ActivityNameFieldWidget(),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: const ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 20)),
                backgroundColor: WidgetStatePropertyAll(Colors.blue),),
            onPressed: () {
              model?.saveActivity();
              Navigator.pop(context);
            },
            child: const Text(
              "Добавить направление",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class ActivityNameFieldWidget extends StatelessWidget {
  const ActivityNameFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) =>
          NewActivityProvider.watch(context)?.model.name = value,
      decoration: InputDecoration(
        hintText: "Название",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
