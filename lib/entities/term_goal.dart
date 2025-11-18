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

  TermGoal({
    required this.text,
    required this.firstDate,
    required this.lastDate,
  });
}
