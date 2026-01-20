import 'package:flutter/material.dart';
import 'package:mind_manager/app/app.dart';
import 'package:mind_manager/features/activities/views/activities_screen.dart';
import 'package:mind_manager/features/activities/views/activity_screen.dart';
import 'package:mind_manager/features/activities/views/new_activity_screen.dart';
import 'package:mind_manager/features/activities/views/new_note_screen.dart';
import 'package:mind_manager/features/activities/views/new_term_goal_screen.dart';
import 'package:mind_manager/features/sprint/views/new_sprint_screen.dart';
import 'package:mind_manager/features/sprint/views/new_sprint_task_screen.dart';
import 'package:mind_manager/features/sprint/views/sprint_screen.dart';
import 'package:mind_manager/features/sprint/views/sprints_screen.dart';
import 'package:mind_manager/features/tasks/views/new_task_screen.dart';
import 'package:mind_manager/features/tasks/views/tasks_screen.dart';

class RouteNames {
  static const home = 'home';
  //--------Activities Tab----------//
  static const activities = 'activities';
  static const activityForm = 'activities/new_activity';
  static const activityInfo = 'activities/activity';
  static const noteForm = 'activities/activity/new_note';
  static const termGoalForm = 'activities/activity/new_term_goal';
  //в onGenRoute тоже есть она, откуда то может убрать ее
  //--------Sprint Tab----------//
  static const sprints = 'sprints';
  static const sprintForm = 'sprints/new_sprint';
  static const sprintTaskForm = 'sprints/new_sprint/new_sprint_task';
  static const sprintInfo = 'sprints/sprint';
  //--------Task Tab-----------//
  static const tasks = 'tasks';
  static const taskForm = 'tasks/new_task';
}

class MainNavigation {
  static const initialRoute = RouteNames.home;
  static final routes = <String, Widget Function(BuildContext)>{
    //--------Activity Tab----------//
    RouteNames.home: (context) => Home(),
    RouteNames.activities: (context) => ActivitiesScreen(),
    RouteNames.activityForm: (context) => const NewActivityScreen(),
    RouteNames.noteForm: (context) => const NewNoteScreen(),
    //--------Sprint Tab----------//
    RouteNames.sprints: (context) => SprintsScreen(),
    RouteNames.sprintForm: (context) => NewSprintScreen(),
    RouteNames.sprintTaskForm: (context) => NewSprintTaskScreen(),
    //--------Task Tab------------//
    RouteNames.tasks: (context) => TasksScreen(),
    RouteNames.taskForm: (context) => NewTaskScreen(),
  };
}

Route<Object>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.activityInfo:
      {
        final activityKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => ActivitiyScreen(
            activityKey: activityKey,
          ),
        );
      }
    case RouteNames.termGoalForm:
      {
        final activityKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => NewTermGoalScreen(
            activityKey: activityKey,
          ),
        );
      }
    case RouteNames.sprintInfo:
      {
        final sprintKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => SprintScreen(
            sprintKey: sprintKey,
          ),
        );
      }
  }
  switch (settings.name) {}
  switch (settings.name) {}
  // switch (settings.name) {
  //   case RouteNames.activityInfo:
  //     {
  //       final activityKey = settings.arguments as int;
  //       return MaterialPageRoute(
  //         builder: (context) => ActivitiyScreen(
  //           activityKey: activityKey,
  //         ),
  //       );
  //     }
  // }
}
