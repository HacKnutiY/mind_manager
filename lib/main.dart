import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/entities/activity.dart';
import 'package:mind_manager/entities/note.dart';

import 'app/app.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  registerAdapters();

  await Hive.openBox<Activity>(Constants.activitiesBoxName);
  await Hive.openBox<Note>(Constants.noteBoxName);
  await Hive.box<Note>(Constants.noteBoxName).clear();
  await Hive.box<Activity>(Constants.activitiesBoxName).clear();

  runApp(const MindManager());
}

registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ActivityAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(NoteAdapter());
  }
}
