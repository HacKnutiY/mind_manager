import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/box_manager.dart';
import 'package:mind_manager/constants.dart';
import 'package:mind_manager/entities/term_goal.dart';
import 'package:mind_manager/navigation/main_navigation.dart';
import 'package:mind_manager/structures/actual_goals_manager.dart';

import '../../../entities/activity.dart';

class ActivitiesModel extends ChangeNotifier {
  ActualGoalsManager goalsManager = ActualGoalsManager();
  late final Box<Activity> activitiesBox;

  List<Activity> _activities = <Activity>[];
  List<Activity> get activities => _activities.toList();

  ActivitiesModel() {
    init();
  }

  Future<void> loadActualTermGoalsFromActivities() async {
    for (Activity activity in _activities) {
      Box<TermGoal> termGoalsBox =
          await BoxManager.instance.openTermGoalBox(activityKey: activity.key);
      List<TermGoal> termGoalsList = termGoalsBox.values.toList();
      for (TermGoal goal in termGoalsList) {
        goalsManager.addActual(goal);
      }
      // в этот цикл добавить where(goal.isComplete){}
      await BoxManager.instance.closeBox(termGoalsBox);
    }
    notifyListeners();
  }

  init() async {
    activitiesBox = Hive.box<Activity>(Constants.activitiesBoxName);

    _loadActivities();
    activitiesBox.listenable().addListener(() {
      _loadActivities();
    });
    await loadActualTermGoalsFromActivities();
  }

  _loadActivities() async {
    _activities = activitiesBox.values.toList();
    notifyListeners();
  }

  toNewActivityScreen(BuildContext context) =>
      Navigator.pushNamed(context, RouteNames.activityForm);

  toActivityScreen(BuildContext context, int activityIndex) async {
    final activityKey = activitiesBox.keyAt(activityIndex) as int;
    unawaited(
      Navigator.pushNamed(
        context,
        RouteNames.activityInfo,
        arguments: activityKey,
      ),
    );
  }
}

class ActivitiesProvider extends InheritedNotifier<ActivitiesModel> {
  final ActivitiesModel model;
  const ActivitiesProvider(
      {Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static ActivitiesModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ActivitiesProvider>()
        ?.model;
  }

  static ActivitiesProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ActivitiesProvider>()
        ?.widget;
    return widget is ActivitiesProvider ? widget : null;
  }
}
