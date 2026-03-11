import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/note.dart';
import 'package:mind_manager/data/services/note_service.dart';

class NewNoteModel extends ChangeNotifier {
  late int activityKey;

  NoteService _noteService = NoteService();

  String name = "";
  String text = "";
  Note? note; // !isNewNote -> null

  bool isNewNote;
  NewNoteModel(
      {required this.activityKey,
      required this.isNewNote,
      required this.note}) {
    loadNoteFields();
  }

  loadNoteFields() {
    if (!isNewNote) {
      name = note!.name;
      text = note!.text;
    }
  }

  Future<void> deleteNote() async {
    await _noteService.deleteNoteById(note!.id);
  }

  generateId() {
    final now = DateTime.now();
    final random = Random().nextInt(9999);
    return "$now$random";
  }

  Future<void> saveNote(
    BuildContext context,
  ) async {
    // создание нового
    if (isNewNote && name.isNotEmpty) {
      Note note = Note(
        name: name,
        text: text,
        id: generateId(),
        activityKey: activityKey,
      );

      await _noteService.addNote(note);
    }

    // изменение уже существующего
    else if (name.isNotEmpty) {
      note!.name = name;
      note!.text = text;
      note!.save();
    } else {
      return;
    }
  }
}

class NewNoteProvider extends InheritedNotifier<NewNoteModel> {
  final NewNoteModel model;
  const NewNoteProvider({Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static NewNoteModel? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NewNoteProvider>()?.model;
  }

  static NewNoteProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NewNoteProvider>()
        ?.widget;
    return widget is NewNoteProvider ? widget : null;
  }
}
