import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/utils/const_strings.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

import '../../../data/entities/activity.dart';

class ActivitiesModel extends ChangeNotifier {
  late final Box<Activity> activitiesBox;
  late final Box<TermGoal> termsGoalsBox;

  late final ValueListenable<Box<TermGoal>> termGoalsListenable;
  late final ValueListenable<Box<Activity>> activitiesListenable;

  ActivitiesModel() {
    init();
  }

  init() {
    activitiesBox = Hive.box<Activity>(Constants.activitiesBoxName);
    termsGoalsBox = Hive.box<TermGoal>(Constants.termGoalsBoxName);
    termGoalsListenable = termsGoalsBox.listenable();
    activitiesListenable = activitiesBox.listenable();
  }

  //------------НАВИГАЦИЯ-------------//
  toNewActivityScreen(BuildContext context) =>
      Navigator.pushNamed(context, RouteNames.activityForm);

  toActivityScreen(BuildContext context, int activityIndex) async {
    final activityKey = activitiesBox.keyAt(activityIndex) as int;
    
    unawaited(
      Navigator.pushNamed(
        context,
        RouteNames.activityInfo,
        arguments: activityKey,
      ),
    );
  }
}

