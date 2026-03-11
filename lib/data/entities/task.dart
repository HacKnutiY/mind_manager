import 'package:hive_flutter/hive_flutter.dart';

part 'task.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObject {
  Task({
    required this.id,
    required this.text,
    required this.activityType,
    required this.isComplete,
    this.sprintKey,
    this.isActive = false,
  });

  @HiveField(0)
  String text;
  @HiveField(1)
  String activityType;
  @HiveField(2)
  String id;
  @HiveField(3)
  bool isComplete;
  @HiveField(4)
  int? sprintKey;
  @HiveField(5)
  bool isActive;
// поле добавлено. теперь надо
// очистить все таск боксы(кстати только с обычными таксми или спрнтовыми тоже, скорее - 2)
// закрыть все эти боксы
//поставить брекпонит чтобы вышеуказанные команды выполнились
// запуск
// удаление команд вышеуказанных
// запуск программы без бп
}
