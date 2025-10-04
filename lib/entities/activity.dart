import 'package:hive_flutter/hive_flutter.dart';

import 'note.dart';
part 'activity.g.dart';

@HiveType(typeId: 0)
class Activity extends HiveObject {
  Activity({
    required this.name,
    required this.index,
  });
  @HiveField(0)
  String name;
  @HiveField(1)
  int index;
  //last used HiveField(2)
}

/*
  @HiveField(2)
  HiveList<Note>? notes;


  addNote(Box<Note> box, Note note) {
    notes ??= HiveList(box);
    notes?.add(note);
  }
  */
