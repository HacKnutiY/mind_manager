import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/features/activities/models/activities_model.dart';
import 'package:mind_manager/data/services/term_goal_service.dart';
import 'package:mind_manager/features/activities/views/widgets/term_goal_widget.dart';

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
  ValueNotifier<List<TermGoal>> listener = TermGoalsService.goalsListener;
  @override
  Widget build(BuildContext context) {
    ActivitiesModel? model = ActivitiesProvider.watch(context);

    List<Activity>? activities = model?.activities;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Актуальные долгосрочные цели",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                  ),
                ),
              );
            },
            valueListenable: listener,
          ),

          const SizedBox(
            height: 30,
          ),
          const Text(
            "Направления",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
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
      child: Card(
        child: ListTile(
          title: Text(activity.name),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
