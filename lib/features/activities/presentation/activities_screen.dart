import 'package:flutter/material.dart';
import 'package:mind_manager/features/activities/models/activities_model.dart';

import '../../../entities/activity.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  ActivitiesModel notifier = ActivitiesModel();

  @override
  Widget build(BuildContext context) {
    return ActivitiesProvider(
      model: notifier,
      child: const _ActivitiesBody(),
    );
  }
}

class _ActivitiesBody extends StatelessWidget {
  const _ActivitiesBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var activities = ActivitiesProvider.watch(context)?.activities;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => ActivitiesProvider.read(context)
            ?.model
            .toNewActivityScreen(context),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Направления"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: activities?.length,
        itemBuilder: (context, index) => ActivityTileWidget(
          activity: Activity(index: index, name: activities?[index].name ?? ""),
        ),
      ),
    );
  }
}

class ActivityTileWidget extends StatelessWidget {
  final Activity activity;

  const ActivityTileWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final model = ActivitiesProvider.read(context)?.model;
    return GestureDetector(
      onTap: () => model!.toActivityScreen(context, activity.index),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue[100], borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "Активная долгосрочная цель: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "Написать проект N, используя технологии Y. Закинуть на GH [Осталось меньше месяца]"),
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
