import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/constants.dart';
import 'package:mind_manager/entities/activity.dart';
import 'package:mind_manager/entities/term_goal.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  registerAdapters();
  await Hive.openBox<Activity>(Constants.activitiesBoxName);
  await Hive.openBox<TermGoal>(Constants.actualTermGoalBoxName);

  runApp(const MindManager());
}

registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ActivityAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(TermGoalAdapter());
  }
}
