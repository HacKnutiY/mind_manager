import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../constants.dart';
import '../../../entities/activity.dart';

class ActivitiesModel extends ChangeNotifier {
  List<Activity> _activities = <Activity>[];
  late Box<Activity> _activitiesBox;
  List<Activity> get activities => _activities.toList();
  ActivitiesModel() {
    _init();
  }
  _init() {
    _activitiesBox = Hive.box<Activity>(Constants.activitiesBoxName);
    _loadActivities();
    _activitiesBox.listenable().addListener(() {
      _loadActivities();
    });
  }

  _loadActivities() {
    _activities = _activitiesBox.values.toList();
    notifyListeners();
  }

  toNewActivityScreen(BuildContext context) =>
      Navigator.pushNamed(context, 'activities/new_activity');

  toActivityScreen(BuildContext context, int activityIndex) {
    final activityKey = _activitiesBox.keyAt(activityIndex) as int;
    Navigator.pushNamed(
      context,
      'activities/activity',
      arguments: activityKey,
    );
  }
}

class ActivitiesProvider extends InheritedNotifier<ActivitiesModel> {
  final ActivitiesModel notifier;
  const ActivitiesProvider(
      {Key? key, required Widget child, required this.notifier})
      : super(key: key, child: child, notifier: notifier);

  static ActivitiesModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ActivitiesProvider>()
        ?.notifier;
  }

  static ActivitiesProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ActivitiesProvider>()
        ?.widget;
    return widget is ActivitiesProvider ? widget : null;
  }
}
