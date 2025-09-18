import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/entities/note.dart';

import '../../../constants.dart';
import '../../../entities/activity.dart';

class ActivityModel extends ChangeNotifier {
  int activityKey;
  Activity? activity;

  List<Note> _activityNotes = <Note>[];
  List<Note> get activityNotes => _activityNotes.toList();

  ActivityModel({required this.activityKey}) {
    setup();
  }

  setup() {
    var activitiesBox = Hive.box<Activity>(Constants.activitiesBoxName);
    activity = activitiesBox.get(activityKey);

    loadNotes();

    Hive.box<Activity>(Constants.activitiesBoxName)
        .listenable(keys: [activityKey]).addListener(() {
      loadNotes();
    });
  }

  loadNotes() {
    _activityNotes = activity?.notes?.toList() ?? <Note>[];
    notifyListeners();
  }

  toNewNoteScreen(BuildContext context,
      {required int activityKey, required bool isNewNote}) {
    Navigator.pushNamed(
      context,
      'activities/activity/new_note',
      arguments: [
        isNewNote,
        activityKey,
      ],
    );
  }

  toNoteScreen(BuildContext context,
      {required int noteIndex, required bool isNewNote}) {
    Navigator.pushNamed(
      context,
      'activities/activity/new_note',
      arguments: [
        isNewNote,
        activityKey,
        noteIndex,
      ],
    );
  }

  notLis() {
    notifyListeners();
  }

  deleteActivity() async {
    var box = Hive.box<Activity>(Constants.activitiesBoxName);
    Activity? activity = box.get(activityKey);
    await activity?.notes?.deleteAllFromHive();
    await box.delete(activityKey);
  }
}

class ActivityProvider extends InheritedNotifier<ActivityModel> {
  final ActivityModel notifier;
  const ActivityProvider(
      {Key? key, required Widget child, required this.notifier})
      : super(key: key, child: child, notifier: notifier);

  static ActivityModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ActivityProvider>()
        ?.notifier;
  }

  static ActivityProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ActivityProvider>()
        ?.widget;
    return widget is ActivityProvider ? widget : null;
  }
}
