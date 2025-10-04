import 'package:flutter/material.dart';
import 'package:mind_manager/features/activities/presentation/activities_screen.dart';
import 'package:mind_manager/features/activities/presentation/activity_screen.dart';
import 'package:mind_manager/features/activities/presentation/new_activity_screen.dart';
import 'package:mind_manager/features/activities/presentation/new_note_screen.dart';
import 'package:mind_manager/features/activities/presentation/new_term_goal_screen.dart';

class RouteNames {
  static const activities = 'activities';
  static const activityForm = 'activities/new_activity';
  static const activityInfo = 'activities/activity';
  static const noteForm = 'activities/activity/new_note';
  static const termGoalForm = 'activities/activity/new_term_goal';
}

class MainNavigation {
  static const initialRoute = RouteNames.activities;
  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.activities: (context) => ActivitiesScreen(),
    RouteNames.activityForm: (context) => const NewActivityScreen(),
    RouteNames.noteForm: (context) => const NewNoteScreen(),
    RouteNames.termGoalForm: (context) => const NewTermGoalScreen()
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
  }
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
  }
}
