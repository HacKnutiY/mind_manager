import 'package:hive_flutter/hive_flutter.dart';
part 'term_goal.g.dart';

@HiveType(typeId: 2)
class TermGoal extends HiveObject {
  @HiveField(0)
  String text;
  @HiveField(1)
  DateTime? firstDate;
  @HiveField(2)
  DateTime? lastDate;
  @HiveField(3)
  String id;
  @HiveField(4)
  bool isComplete;
  @HiveField(5)
  int activityKey;
  

  TermGoal({
    required this.text,
    required this.firstDate,
    required this.lastDate,
    required this.isComplete,
    required this.id,
    required this.activityKey,
  });
}
