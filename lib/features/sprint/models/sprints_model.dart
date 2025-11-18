import 'package:flutter/material.dart';

class SprintsModel extends ChangeNotifier {
  SprintsModel();
}

class SprintsProvider extends InheritedNotifier<SprintsModel> {
  final SprintsModel model;
  const SprintsProvider({Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static SprintsModel? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SprintsProvider>()?.model;
  }

  static SprintsProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<SprintsProvider>()
        ?.widget;
    return widget is SprintsProvider ? widget : null;
  }
}
