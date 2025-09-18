import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/constants.dart';
import 'package:mind_manager/entities/note.dart';

import '../../../entities/activity.dart';

class NewNoteModel {
  late int activityKey;
  Activity? activity;

  String name = "";
  String text = "";
  int? noteIndex;

  bool isNewNote;
  NewNoteModel(
      {required this.activityKey,
      required this.isNewNote,
      required this.noteIndex}) {
    loadActivity();
    loadNoteFields();
  }

  loadActivity() {
    Box<Activity> activitiesBox =
        Hive.box<Activity>(Constants.activitiesBoxName);
    activity = activitiesBox.get(activityKey);
  }

  loadNoteFields() {
    if (!isNewNote) {
      name = activity!.notes!.elementAt(noteIndex!).name;
      text = activity!.notes!.elementAt(noteIndex!).text;
    }
  }

  deleteNote() async {
    activity?.notes?.deleteFromHive(noteIndex!);
    await activity?.save();
  }

  saveNote(
    BuildContext context,
  ) async {
    Box<Note>? notesBox = Hive.box<Note>(Constants.noteBoxName);

    if (isNewNote && name.isNotEmpty) {
      //добавляем note в общий бокс
      Note note = Note(name: name, text: text);
      notesBox.add(note);

      //добавляем note в HiveList к конкретному активити
      activity?.addNote(notesBox, note);
      await activity?.save();
    } else if (name.isNotEmpty) {
      //попровляем уже существующий note
      activity!.notes!.elementAt(noteIndex!).name = name;
      activity!.notes!.elementAt(noteIndex!).text = text;
      await activity?.save();
    } else {
      return 0;
    }
  }
}

class NewNoteProvider extends InheritedWidget {
  final NewNoteModel model;

  const NewNoteProvider({Key? key, required Widget child, required this.model})
      : super(
          key: key,
          child: child,
        );

  static NewNoteProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NewNoteProvider>();
  }

  static NewNoteProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NewNoteProvider>()
        ?.widget;
    return widget is NewNoteProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant NewNoteProvider oldWidget) {
    return false;
  }
}
