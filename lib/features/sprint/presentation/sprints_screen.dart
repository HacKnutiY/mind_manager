import 'dart:math' show Random;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/features/activities/presentation/activity_screen.dart';
import 'package:mind_manager/data/services/actual_goals_manager.dart';
import 'package:mind_manager/features/activities/presentation/widgets/term_goal_widget.dart';

/// Flutter code sample for [ValueListenableBuilder].

class ValueListenableBuilderExampleApp extends StatelessWidget {
  const ValueListenableBuilderExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ValueListenableBuilderExample());
  }
}

class ValueListenableBuilderExample extends StatefulWidget {
  const ValueListenableBuilderExample({super.key});

  @override
  State<ValueListenableBuilderExample> createState() =>
      _ValueListenableBuilderExampleState();
}

class _ValueListenableBuilderExampleState
    extends State<ValueListenableBuilderExample> {
  ValueNotifier<List<TermGoal>> listener = ActualGoalsService.goalsListener;
  ActualGoalsService goalsManager = ActualGoalsService();
  @override
  Widget build(BuildContext context) {
    TermGoal goal = TermGoal(
      isComplete: false,
      id: goalsManager.generateGoalId(),
      text: "text",
      firstDate: DateTime(1, 1, 1),
      lastDate: DateTime(
        1,
        1,
        1,
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<List<TermGoal>>(
              builder: (BuildContext context, List<TermGoal> a, Widget? child) {
                //valueListenable поменялся - builder вызвался

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
              //значение при смене которого перестрится билдер
              valueListenable: listener,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.plus_one),
          //меняем как раз valueNotifier
          onPressed: () {
            goal = TermGoal(
                text: "text",
                firstDate: DateTime(1, 1, 1),
                lastDate: DateTime(1, 1, 1),
                id: goalsManager.generateGoalId(),
                isComplete: false);
            goalsManager.addActual(goal);
          }),
    );
  }
}

class CountDisplay extends StatelessWidget {
  const CountDisplay({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsetsDirectional.all(10),
      child: Text('$count', style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
