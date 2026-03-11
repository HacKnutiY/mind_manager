import 'package:hive_flutter/hive_flutter.dart';

part 'sprint.g.dart';

@HiveType(typeId: 4)
class Sprint extends HiveObject {
  Sprint({
    required this.name,
    required this.startDate,
    required this.endDate,
    this.description = "",
  }) : isActive = DateTime.now().isBefore(endDate);
  @HiveField(0)
  String name;
  @HiveField(1)
  DateTime startDate;
  @HiveField(2)
  DateTime endDate;
  @HiveField(3)
  bool isActive;
  @HiveField(4)
  String description;
}
