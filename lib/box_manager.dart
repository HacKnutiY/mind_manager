import 'package:hive/hive.dart';
import 'package:mind_manager/constants.dart';
import 'package:mind_manager/entities/activity.dart';
import 'package:mind_manager/entities/note.dart';

class BoxManager {
  static BoxManager instance = BoxManager._();
  BoxManager._();

  final Map<String, int> _boxReferencesCounter = {};

  Future<Box<Note>> openNoteBox({required int activityIndex}) => _openBox<Note>(
      boxName: generateTaskBoxName(activityIndex: activityIndex),
      adapter: NoteAdapter(),
      adapterId: 1);

  String generateTaskBoxName({required int activityIndex}) =>
      "${Constants.noteBoxName}_$activityIndex";

  Future<Box<Activity>> openActivitesBox() => _openBox<Activity>(
      boxName: Constants.activitiesBoxName,
      adapter: ActivityAdapter(),
      adapterId: 0);

  Future<void> closeBox<T>(Box<T> box) async {
    //если бокс > 1 -> закрой бокс
    //элсе -> +1
    var boxName = box.name;
    if (_boxReferencesCounter.containsKey(boxName)) {
      _boxReferencesCounter[boxName] = _boxReferencesCounter[boxName]! - 1;

      if (_boxReferencesCounter[boxName]! <= 0) {
        //закрытие бокса
        await box.compact();
        await box.close();
        //удаление ключа
        _boxReferencesCounter.remove(boxName);
        
      }
    }
  }

  Future<Box<T>> _openBox<T>({
    required String boxName,
    required TypeAdapter adapter,
    required int adapterId,
  }) async {
    //если имя_бокса нулл -> 1
    //элсе -> +1

    //Бокс не открыт
    if (!_boxReferencesCounter.keys.contains(boxName)) {
      _boxReferencesCounter[boxName] = 1;
      if (!Hive.isAdapterRegistered(adapterId)) {
        Hive.registerAdapter(adapter);
      }

      return await Hive.openBox<T>(boxName);
    } else {
      _boxReferencesCounter[boxName] = _boxReferencesCounter[boxName]! + 1;
      return Hive.box<T>(boxName);
    }
  }
}
