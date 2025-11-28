import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/features/activities/models/activities_model.dart';
import 'package:mind_manager/features/activities/presentation/activity_screen.dart';
import 'package:mind_manager/data/services/actual_goals_manager.dart';
import 'package:mind_manager/features/activities/presentation/widgets/term_goal_widget.dart';

import '../../../data/entities/activity.dart';

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
      child: const ActivitiesBody(),
    );
  }
}

class ActivitiesBody extends StatefulWidget {
  const ActivitiesBody({
    super.key,
  });

  @override
  State<ActivitiesBody> createState() => _ActivitiesBodyState();
}

class _ActivitiesBodyState extends State<ActivitiesBody> {
  ValueNotifier<List<TermGoal>> listener = ActualGoalsService.goalsListener;
  @override
  Widget build(BuildContext context) {
    ActivitiesModel? model = ActivitiesProvider.watch(context);

    List<Activity>? activities = model?.activities;
    //List<TermGoal>? actualGoals = model?.actualGoals;

    //Возможная проблема 1: создание нового ValueNotifier

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
      body: Column(
        children: [
          // 1. Горизонтальный список актуальных целей
          ValueListenableBuilder<List<TermGoal>>(
            builder: (BuildContext context, List<TermGoal> a, Widget? child) {
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listener.value.length,
                  itemBuilder: (context, index) => TermGoalTileWidget(
                    goal: listener.value[index],
                    goalIndexInList: index,
                    
                  ),
                ),
              );
            },
            valueListenable: listener,
          ),

          // 2. Вертикальный список направлений
          Expanded(
            child: ListView.builder(
              itemCount: activities?.length,
              itemBuilder: (context, index) => ActivityTileWidget(
                activity:
                    Activity(index: index, name: activities?[index].name ?? ""),
              ),
            ),
          ),
        ],
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
