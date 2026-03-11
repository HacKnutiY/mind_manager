import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/features/activities/models/activities_model.dart';
import 'package:mind_manager/features/activities/models/term_goal_tile_model.dart';
import 'package:mind_manager/features/activities/views/widgets/term_goal_tile_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/entities/activity.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => ActivitiesModel().toNewActivityScreen(context),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Направления"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => ActivitiesModel(),
            ),
            // Отдельная модель, тк вью цели используется на неск. экранах
            // ChangeNotifierProvider(
            //   create: (context) => TermGoalTileModel(),
            // ),
          ],
          child: const _ActivitiesBody(),
        ),
      ),
    );
  }
}

class _ActivitiesBody extends StatelessWidget {
  const _ActivitiesBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Актуальные долгосрочные цели",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // 1. Горизонтальный список актуальных целей
        ActualGoalsListWidget(),

        Padding(
          padding: EdgeInsetsGeometry.only(top: 30, bottom: 10),
          child: Text(
            "Направления",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),

        // 2. Вертикальный список направлений
        ActivitiesListWidget(),
      ],
    );
  }
}

//--------------ActualGoals Widgets----------------------//
class ActualGoalsListWidget extends StatelessWidget {
  const ActualGoalsListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<TermGoal>>(
      builder: (BuildContext context, Box<TermGoal> actualsBox, Widget? child) {
        context.watch<TermGoalTileModel>();
        final actuals = actualsBox.values.toList();
        final List<TermGoal> filteredActuals =
            actuals.where((term) => term.isComplete == false).toList();
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredActuals.length,
            itemBuilder: (context, index) => TermGoalTileWidget(
              goal: filteredActuals[index],
            ),
          ),
        );
      },
      valueListenable: context.read<ActivitiesModel>().termGoalsListenable,
    );
  }
}

//--------------Activity Widgets----------------------//

class ActivitiesListWidget extends StatelessWidget {
  const ActivitiesListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<Box<Activity>>(
        builder:
            (BuildContext context, Box<Activity> actualsBox, Widget? child) {
          return ListView.builder(
            itemCount: actualsBox.length,
            itemBuilder: (context, index) => ActivityTileWidget(
              activity: Activity(
                  index: index, name: actualsBox.values.toList()[index].name),
            ),
          );
        },
        valueListenable: context.read<ActivitiesModel>().activitiesListenable,
      ),
    );
  }
}

class ActivityTileWidget extends StatelessWidget {
  final Activity activity;

  const ActivityTileWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<ActivitiesModel>()
          .toActivityScreen(context, activity.index),
      child: Card(
        child: ListTile(
          title: Text(activity.name),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
