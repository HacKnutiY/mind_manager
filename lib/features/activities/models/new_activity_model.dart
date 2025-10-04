import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:mind_manager/constants.dart';

import '../../../entities/activity.dart';

class NewActivityModel {
  String name = "";

  saveActivity() async {
    if (name.isNotEmpty) {
      var box = Hive.box<Activity>(Constants.activitiesBoxName);
      await box.add(Activity(name: name, index: box.values.length));
    }
  }
}

class NewActivityProvider extends InheritedWidget {
  final NewActivityModel model;
  const NewActivityProvider({
    required this.model,
    super.key,
    required super.child,
  });
//По сути след 2 метода прописаны для дочерних элементов инхерита для быстрого поиска его по дереву
//В один конкретный момент модельку объявленную выше использует один конкретный виджет
  static NewActivityProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NewActivityProvider>();
  }

  static NewActivityProvider? read(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<NewActivityProvider>()
        ?.widget as NewActivityProvider;
  }

  @override
  bool updateShouldNotify(covariant NewActivityProvider oldWidget) {
    return false;
  }
}
