import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/box_manager.dart';
import 'package:mind_manager/entities/note.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

import '../../../constants.dart';
import '../../../entities/activity.dart';

class ActivityScreenConfiguration {
  bool isNewNote;
  int activityKey;
  int? noteIndex;
  ActivityScreenConfiguration({
    required this.isNewNote,
    required this.activityKey,
    this.noteIndex,
  });
}

class ActivityModel extends ChangeNotifier {
  int activityKey;
  Activity? activity;

  List<Note> _notes = <Note>[];
  List<Note> get activityNotes => _notes.toList();

  late Future<Box<Note>> _notesBox;

  ActivityModel({required this.activityKey}) {
    setup();
  }

  setup() async {
    _notesBox = BoxManager.instance.openNoteBox(activityIndex: activityKey);

    loadNotes();

    (await _notesBox).listenable().addListener(() {
      loadNotes();
    });
  }

  loadNotes() async {
    _notes = (await _notesBox).values.toList();
    notifyListeners();
  }

  toNewNoteScreen(BuildContext context,
      {required int activityKey, required bool isNewNote}) {
    Navigator.pushNamed(
      context,
      'activities/activity/new_note',
      arguments: ActivityScreenConfiguration(
        isNewNote: isNewNote,
        activityKey: activityKey,
      ),
    );
  }

  toNoteScreen(BuildContext context,
      {required int noteIndex, required bool isNewNote}) {
    Navigator.pushNamed(
      context,
      'activities/activity/new_note',
      arguments: ActivityScreenConfiguration(
        isNewNote: isNewNote,
        activityKey: activityKey,
        noteIndex: noteIndex,
      ),
    );
  }

  toNewTermGoal(BuildContext context) async {
    Navigator.pushNamed(context, RouteNames.termGoalForm);
  }

  toNewTermGoalScreen(BuildContext context,
      {required int activityKey, required bool isNewNote}) {
    Navigator.pushNamed(
      context,
      'activities/activity/new_note',
      arguments: ActivityScreenConfiguration(
        isNewNote: isNewNote,
        activityKey: activityKey,
      ),
    );
  }

  Future<void> closeBoxes() async {
    BoxManager.instance.closeBox((await _notesBox));
  }

  deleteActivity() async {
    var box = Hive.box<Activity>(Constants.activitiesBoxName);
    await box.delete(activityKey);
  }

  @override
  Future<void> dispose() async {
    await closeBoxes();
    super.dispose();
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
