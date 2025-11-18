// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TermGoalAdapter extends TypeAdapter<TermGoal> {
  @override
  final int typeId = 2;

  @override
  TermGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TermGoal(
      text: fields[0] as String,
      firstDate: fields[1] as DateTime?,
      lastDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TermGoal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.firstDate)
      ..writeByte(2)
      ..write(obj.lastDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TermGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
