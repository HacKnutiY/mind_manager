import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:mind_manager/utils/utils.dart';

import '../../../data/entities/activity.dart';

class NewActivityModel extends ChangeNotifier {
  String name = "";
  String? errorMessage;

  saveActivity(BuildContext context) async {
    name = name.trim();
    if (name.isNotEmpty) {
      var box = Hive.box<Activity>(Constants.activitiesBoxName);
      await box.add(Activity(name: name, index: box.values.length));
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      errorMessage = Constants.emptyFieldsError;
      notifyListeners();
    }
  }
}

class NewActivityProvider extends InheritedNotifier<NewActivityModel> {
  final NewActivityModel model;
  const NewActivityProvider({
    required this.model,
    super.key,
    required super.child,
  }) : super(notifier: model);
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
