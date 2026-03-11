// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sprint.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SprintAdapter extends TypeAdapter<Sprint> {
  @override
  final int typeId = 4;

  @override
  Sprint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sprint(
      name: fields[0] as String,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime,
      description: fields[4] as String,
    )..isActive = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, Sprint obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SprintAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
