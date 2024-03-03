// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FirstTimeAdapter extends TypeAdapter<FirstTime> {
  @override
  final int typeId = 1;

  @override
  FirstTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirstTime(
      isFirstTime: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FirstTime obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isFirstTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirstTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
