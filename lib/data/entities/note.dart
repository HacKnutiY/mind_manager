import 'package:hive_flutter/hive_flutter.dart';
part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String text;

  Note({
    required this.name,
    required this.text,
  });
}

