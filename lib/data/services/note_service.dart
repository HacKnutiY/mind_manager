import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/note.dart';
import 'package:mind_manager/utils/const_strings.dart';

class NoteService {
  late final Box<Note> _notesBox;
  NoteService() {
    _notesBox = Hive.box<Note>(Constants.notesBoxName);
  }

  Future<void> deleteNoteById(String id) async {
    for (Note note in _notesBox.values) {
      if (note.id == id) {
        await _notesBox.delete(note.key);
      }
    }
  }

  deleteActivityNotes(int activityKey) async {
    for (Note note in _notesBox.values) {
      if (note.activityKey == activityKey) {
        await _notesBox.delete(note.key);
      }
    }
  }

  Future<void> addNote(Note note) async {
    await (_notesBox).add(note);
  }
}
