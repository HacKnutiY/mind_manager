import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_manager/constants.dart';
import 'package:mind_manager/entities/activity.dart';
import 'package:mind_manager/entities/note.dart';
import 'package:mind_manager/entities/term_goal.dart';

class BoxManager {
  static BoxManager instance = BoxManager._();
  BoxManager._();

  final Map<String, int> _boxReferencesCounter = {};

  Future<Box<Note>> openNoteBox({required int activityIndex}) => _openBox<Note>(
      boxName: _generateBoxName(
          activityKey: activityIndex, boxName: Constants.noteBoxName),
      adapter: NoteAdapter(),
      adapterId: 1);

  Future<Box<TermGoal>> openTermGoalBox({required int activityKey}) =>
      _openBox<TermGoal>(
          boxName: _generateBoxName(
              activityKey: activityKey, boxName: Constants.termGoalBoxName),
          adapter: TermGoalAdapter(),
          adapterId: 2);

  String _generateBoxName(
          {required int activityKey, required String boxName}) =>
      "${boxName}_$activityKey";

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
        //удаление ключа и слушателя
        _boxReferencesCounter.remove(boxName);
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
