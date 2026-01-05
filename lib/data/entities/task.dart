import 'dart:math';

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
  });

/*
создать фабричный конструктор для генерации id под капотом
 */
/*
были какие то непонятные ошибки и походу это потому что фабрика должен запрашивать поля отдельно 
поля которые порождающий - отдельно
*/

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
}
