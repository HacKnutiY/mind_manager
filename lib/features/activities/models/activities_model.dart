import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/box_manager.dart';
import 'package:mind_manager/constants.dart';

import '../../../entities/activity.dart';

class ActivitiesModel extends ChangeNotifier {
  late final Box<Activity> activitiesBox;

  List<Activity> _activities = <Activity>[];
  List<Activity> get activities => _activities.toList();

  ActivitiesModel() {
    init();
  }

  init() async {
    activitiesBox = Hive.box<Activity>(Constants.activitiesBoxName);
    _loadActivities();
    activitiesBox.listenable().addListener(() {
      _loadActivities();
    });
  }

  _loadActivities() async {
    _activities = activitiesBox.values.toList();
    notifyListeners();
  }

  toNewActivityScreen(BuildContext context) =>
      Navigator.pushNamed(context, 'activities/new_activity');

  toActivityScreen(BuildContext context, int activityIndex) async {
    final activityKey = activitiesBox.keyAt(activityIndex) as int;
    unawaited(
      Navigator.pushNamed(
        context,
        'activities/activity',
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
