import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/utils/box_manager.dart';
import 'package:mind_manager/data/entities/note.dart';

class NewNoteModel extends ChangeNotifier {
  late int activityKey;

  late Future<Box<Note>> _notesBox;

  String name = "";
  String text = "";
  int? noteIndex;

  bool isNewNote;
  NewNoteModel(
      {required this.activityKey, required this.isNewNote, this.noteIndex}) {
    setupBox();
    loadNoteFields();
  }

  Future<void> setupBox() async {
    _notesBox = BoxManager.instance.openNoteBox(activityIndex: activityKey);
  }

  Future<void> loadNoteFields() async {
    if (!isNewNote) {
      //если заметка не новая, то noteIndex точно есть
      Note note = (await _notesBox).values.elementAt(noteIndex!);

      name = note.name;
      text = note.text;
      //тут он нужен: 1 - await не успевает за билдом, 2 - слушатель бокса не реагирует на изменение объекта
      notifyListeners();
    }
  }

  Future<void> deleteNote() async {
    (await _notesBox).deleteAt(noteIndex!);
  }

  Future<void> saveNote(
    BuildContext context,
  ) async {
    if (isNewNote && name.isNotEmpty) {
      Note note = Note(name: name, text: text);
      await (await _notesBox).add(note);
    } else if (name.isNotEmpty) {
      //попровляем уже существующий note
      Note note = (await _notesBox).values.elementAt(noteIndex!);

      note.name = name;
      note.text = text;
      note.save();
    } else {
      return;
    }
  }

  @override
  Future<void> dispose() async {
    await BoxManager.instance.closeBox(
      await _notesBox,
    );
    super.dispose();
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
