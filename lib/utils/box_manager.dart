import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/utils/utils.dart';
import 'package:mind_manager/data/entities/activity.dart';
import 'package:mind_manager/data/entities/note.dart';
import 'package:mind_manager/data/entities/term_goal.dart';

class BoxManager {
  static BoxManager instance = BoxManager._();
  BoxManager._();

  final Map<String, int> _boxReferencesCounter = {};

  Future<Box<Note>> openNoteBox({required int activityIndex}) => _openBox<Note>(
      boxName: getBoxName(
          activityKey: activityIndex, boxName: Constants.notesBoxName),
      adapter: NoteAdapter(),
      adapterId: 1);

  String getBoxName({required int activityKey, required String boxName}) =>
      "${boxName}_$activityKey";

  Future<Box<Task>> openTasksBox() => _openBox<Task>(
      boxName: Constants.sprintTasksBoxName,
      adapter: TaskAdapter(),
      adapterId: 3);

  Future<Box<Activity>> openActivitesBox() => _openBox<Activity>(
      boxName: Constants.activitiesBoxName,
      adapter: ActivityAdapter(),
      adapterId: 0);

  Future<void> closeBox<T>(Box<T> box, [void Function()? listener]) async {
    var boxName = box.name;
    if (_boxReferencesCounter.containsKey(boxName)) {
      _boxReferencesCounter[boxName] = _boxReferencesCounter[boxName]! - 1;

      if (_boxReferencesCounter[boxName]! <= 0) {
        //закрытие бокса
        await box.compact();
        await box.close();
        //удаление ключа из счетчика открытий
        _boxReferencesCounter.remove(boxName);
        //удаление слушателя
        (listener != null) ? box.listenable().removeListener(listener) : null;
      }
    }
  }

  Future<Box<T>> _openBox<T>({
    required String boxName,
    required TypeAdapter adapter,
    required int adapterId,
  }) async {
    //Бокс закрыт
    if (!_boxReferencesCounter.keys.contains(boxName)) {
      _boxReferencesCounter[boxName] = 1;
      if (!Hive.isAdapterRegistered(adapterId)) {
        Hive.registerAdapter(adapter);
      }

      return await Hive.openBox<T>(boxName);
    }
    //бокс открыт
    else {
      _boxReferencesCounter[boxName] = _boxReferencesCounter[boxName]! + 1;
      return Hive.box<T>(boxName);
    }
  }
}
