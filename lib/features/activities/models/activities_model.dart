import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/utils/utils.dart';
import 'package:mind_manager/navigation/main_navigation.dart';
import 'package:mind_manager/data/services/term_goal_service.dart';

import '../../../data/entities/activity.dart';

class ActivitiesModel extends ChangeNotifier {
  final TermGoalsService _termGoalsService = TermGoalsService();

  late final Box<Activity> activitiesBox;

  List<Activity> _activities = <Activity>[];
  List<Activity> get activities => _activities.toList();

  ActivitiesModel() {
    init();
  }
//подгрузка идет из общего бокса и по сути этот метод больше не нужен
  // Future<void> loadActualTermGoalsFromActivitiesBox() async {
  //   List<TermGoal> termGoalsList = [];
  //   //подготовка локального termGoalsList для дальнейшего заполнения списка аткуальных
  //   for (Activity activity in _activities) {
  //     int key = activity.key;
  //     List<TermGoal> termsFromBox =
  //         await _termGoalsService.getActivityTermsFromBoxByKey(key);
  //     termGoalsList.addAll(termsFromBox);
  //   }
  //   // //заполнение списка актуального списка
  //   // if (TermGoalsService.goalsListener.value.length != termGoalsList.length) {
  //   //   for (TermGoal goal in termGoalsList) {
  //   //     //_termGoalsService.addActualToList(goal);
  //   //     //тестирую слушатель, если не работает - разкомментить
  //   //   }
  //   // }
  //   notifyListeners();
  // }

  deleteTerm(String goalId) {
    _termGoalsService.deleteTermFromBoxById(goalId);
    notifyListeners();
  }

  completeTerm(String goalId) {
    _termGoalsService.deleteTermFromActualList(goalId);
    notifyListeners();
  }

  init() async {
    activitiesBox = Hive.box<Activity>(Constants.activitiesBoxName);
    TermGoalsService().loadActuals();
    _loadActivities();
    activitiesBox.listenable().addListener(() {
      _loadActivities();
    });
  }

  _loadActivities() async {
    _activities = activitiesBox.values.toList();
    notifyListeners();
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

class ActivitiesProvider extends InheritedNotifier<ActivitiesModel> {
  final ActivitiesModel model;
  const ActivitiesProvider(
      {Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static ActivitiesModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ActivitiesProvider>()
        ?.model;
  }

  static ActivitiesProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ActivitiesProvider>()
        ?.widget;
    return widget is ActivitiesProvider ? widget : null;
  }
}
