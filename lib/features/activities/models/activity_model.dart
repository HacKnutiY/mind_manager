import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/data/services/term_goal_service.dart';
import 'package:mind_manager/utils/box_manager.dart';
import 'package:mind_manager/data/entities/note.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

import '../../../utils/utils.dart';
import '../../../data/entities/activity.dart';

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
  List<TermGoal> _activityTermGoals = <TermGoal>[];
  List<TermGoal> get activityTermGoals => _activityTermGoals.toList();

  late Future<Box<Note>> _notesBox;
  late Box<TermGoal> _termGoalsBox;

  ActivityModel({required this.activityKey}) {
    setup();
  }

  setup() async {
    _notesBox = BoxManager.instance.openNoteBox(activityIndex: activityKey);

    //просто все долгосроки загрузятся туда
    _termGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);

    loadData();

    (await _notesBox).listenable().addListener(() {
      loadNotes();
    });

    _termGoalsBox.listenable().addListener(() {
      loadTermGoals();
      TermGoalsService().loadActuals();
    });
    notifyListeners();
  }

  loadData() {
    loadNotes();
    loadTermGoals();
  }

//-----------------------МЕТОДЫ ЗАМЕТОК----------------------//
  loadNotes() async {
    _notes = (await _notesBox).values.toList();
    notifyListeners();
  }

//-----------------------МЕТОДЫ ЦЕЛЕЙ----------------------//

  //загрузка долгосроков
  loadTermGoals() async {
    _activityTermGoals = _termGoalsBox.values
        .where((goal) => goal.activityKey == activityKey)
        .toList();
    notifyListeners();
  }

//-----------------------МЕТОДЫ НАПРАВЛЕНИЯ----------------------//
  deleteActivity() async {
    //удаление направления
    var box = Hive.box<Activity>(Constants.activitiesBoxName);
    await box.delete(activityKey);

    //удаление заметок направления
    await (await _notesBox).deleteFromDisk();

    //удаление долгосроков направления
    //await (_termGoalsBox).deleteFromDisk();

    for (TermGoal term in _termGoalsBox.values) {
      if (term.activityKey == activityKey) {
        _termGoalsBox.delete(term.key);
      }
    }
    print(_termGoalsBox.values.length);
  }

  //-----------------МЕТОДЫ НАВИГАЦИИ--------------------//
  toNewNoteScreen(BuildContext context,
      {required int activityKey, required bool isNewNote}) {
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
      {required int noteIndex, required bool isNewNote}) {
    Navigator.pushNamed(
      context,
      RouteNames.noteForm,
      arguments: ActivityScreenConfiguration(
        isNewNote: isNewNote,
        activityKey: activityKey,
        noteIndex: noteIndex,
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
