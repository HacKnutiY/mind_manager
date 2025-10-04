import 'package:hive_flutter/hive_flutter.dart';
//part 'term_goal.g.dart';

@HiveType(typeId: 2)
class TermGoal extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String text;
  @HiveField(2)
  DateTime? firstDate;
  @HiveField(3)
  DateTime? lastDate;

  TermGoal({
    required this.id,
    required this.text,
    required this.firstDate,
    required this.lastDate,
  });
}
