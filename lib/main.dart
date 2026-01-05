import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/utils/utils.dart';
import 'package:mind_manager/data/entities/activity.dart';
import 'package:mind_manager/data/entities/term_goal.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  registerAdapters();
  await Hive.openBox<Activity>(Constants.activitiesBoxName);
  await Hive.openBox<TermGoal>(Constants.termGoalsBoxName);
  Box<Task> tasks = await Hive.openBox<Task>(Constants.sprintTasksBoxName);
  await tasks.clear();
  Box<Sprint> sprints = await Hive.openBox<Sprint>(Constants.sprintsBoxName);
  sprints.clear();

  runApp(const MindManager());
}

registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ActivityAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(TermGoalAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(TaskAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(SprintAdapter());
  }
}
