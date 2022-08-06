// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AreaModelAdapter extends TypeAdapter<AreaModel> {
  @override
  final int typeId = 1;

  @override
  AreaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AreaModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AreaModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
