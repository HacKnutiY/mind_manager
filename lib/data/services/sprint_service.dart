import 'package:flutter/foundation.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/utils/const_strings.dart';

class SprintService {
  final Box<Sprint> _sprintsBox = Hive.box<Sprint>(Constants.sprintsBoxName);
  late bool _isActiveSprintExist;
  bool get isActiveSprintExist => (_sprintsBox.values.isNotEmpty &&
          _sprintsBox.values.last.isActive == true)
      ? true
      : false;
  late ValueListenable<Box<Sprint>> sprintsBoxListenable;
  SprintService() {
    _init();
  }
  _init() {
    sprintsBoxListenable = _sprintsBox.listenable();
  }

  //создать все таки метод isActiveSprintExist
// чтобы его каждый раз вызывать и обновлять данные
  getSprints() {
    return _sprintsBox.values.toList();
  }

  deleteSprint(int key) {
    _sprintsBox.delete(key);
  }

  Sprint? getSprintFromKey(int key) {
    return _sprintsBox.get(key);
  }

  Future<int> addSprint(Sprint sprint) async {
    return await _sprintsBox.add(sprint);
  }
}
