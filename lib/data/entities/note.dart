import 'package:hive_flutter/hive_flutter.dart';
part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String text;
  @HiveField(2)
  String id;
  @HiveField(3)
  int activityKey;



  Note({
    required this.name,
    required this.text,
    required this.id,
    required this.activityKey,

  });
}

