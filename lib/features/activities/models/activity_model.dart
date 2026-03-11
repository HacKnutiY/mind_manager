import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/data/entities/note.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/data/services/note_service.dart';
import 'package:mind_manager/data/services/term_goal_service.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

import '../../../utils/const_strings.dart';
import '../../../data/entities/activity.dart';

class ActivityScreenConfiguration {
  bool isNewNote;
  int activityKey;
  Note? note;
  ActivityScreenConfiguration({
    required this.isNewNote,
    required this.activityKey,
    this.note,
  });
}

class ActivityModel extends ChangeNotifier {
  NoteService _noteService = NoteService();
  TermGoalsService _termService = TermGoalsService();

  int activityKey;
  Activity? activity;

  late Box<TermGoal> _termGoalsBox;
  late final ValueListenable<Box<TermGoal>> termGoalsListenable;
  late Box<Note> _notesBox;
  late final ValueListenable<Box<Note>> notesListenable;

  ActivityModel({required this.activityKey}) {
    setup();
  }

  setup() async {
    _termGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);
    termGoalsListenable = _termGoalsBox.listenable();
    _notesBox = Hive.box<Note>(Constants.notesBoxName);
    notesListenable = _notesBox.listenable();
    Box<Activity> activitiesBox = Hive.box(Constants.activitiesBoxName);
    activity = activitiesBox.get(activityKey) as Activity;

    notifyListeners();
  }

//-----------------------МЕТОДЫ ДОЛГОСРОКОВ----------------------//
  List<TermGoal> getFilteredTerms(int activityKey) {
    return _termGoalsBox.values
        .where(
          (term) => term.activityKey == activityKey,
        )
        .toList();
  }

//-----------------------МЕТОДЫ ЗАМЕТОК----------------------//
  List<Note> getFilteredNotes(int activityKey) {
    return _notesBox.values
        .where(
          (note) => note.activityKey == activityKey,
        )
        .toList();
  }

//-----------------------МЕТОДЫ НАПРАВЛЕНИЯ----------------------//
  deleteActivity(BuildContext context) async {
    //удаление направления
    var box = Hive.box<Activity>(Constants.activitiesBoxName);
    await box.delete(activityKey);

    //удаление долгосроков направления
    await _termService.deleteActivityTerms(activityKey);

    //удаление заметок направления
    await _noteService.deleteActivityNotes(activityKey);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  //-----------------МЕТОДЫ НАВИГАЦИИ--------------------//
  toNewNoteScreen(BuildContext context, {required bool isNewNote}) {
    Navigator.pushNamed(
      context,
      RouteNames.noteForm,
      arguments: ActivityScreenConfiguration(
        isNewNote: isNewNote,
        activityKey: activityKey,
      ),
    );
  }

  toNoteScreen(BuildContext context,
      {required Note note, required bool isNewNote}) {
    Navigator.pushNamed(
      context,
      RouteNames.noteForm,
      arguments: ActivityScreenConfiguration(
        isNewNote: isNewNote,
        activityKey: activityKey,
        note: note,
      ),
    );
  }

  toNewTermGoal(BuildContext context) async {
    Navigator.pushNamed(context, RouteNames.termGoalForm,
        arguments: activityKey);
  }

//------------МЕТОДЫ СВЯЗАННЫЕ С БОКСАМИ И С ИХ КОРРЕКТНЫМ ЗАКРЫТИЕМ---------------//
/*
  @override
  Future<void> dispose() async {
    //закрытие боксов, если направление не удалено
    if (Hive.isBoxOpen((await _notesBox).name)) {
      await BoxManager.instance.closeBox(
        await _notesBox,
        await loadNotes(),
      );
    }

    if (Hive.isBoxOpen((await _termGoalsBox).name)) {
      await BoxManager.instance.closeBox(
        await _termGoalsBox,
        await loadTermGoals(),
      );
    }

    super.dispose();
  }
*/
}

class ActivityProvider extends InheritedNotifier<ActivityModel> {
  final ActivityModel model;
  const ActivityProvider({Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static ActivityModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ActivityProvider>()
        ?.model;
  }

  static ActivityProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ActivityProvider>()
        ?.widget;
    return widget is ActivityProvider ? widget : null;
  }
}
