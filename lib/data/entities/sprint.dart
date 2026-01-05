import 'package:hive_flutter/hive_flutter.dart';

part 'sprint.g.dart';

@HiveType(typeId: 4)
class Sprint extends HiveObject {
  Sprint({
    required this.name,
    required this.firstDate,
    required this.lastDate,
  });
  @HiveField(0)
  String name;
  @HiveField(1)
  DateTime? firstDate;
  @HiveField(2)
  DateTime? lastDate;
}
/*
связка с тасками - по ключу этого спринта
таски в отдельном боксе
*/
