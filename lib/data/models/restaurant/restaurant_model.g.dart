// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantModelAdapter extends TypeAdapter<RestaurantModel> {
  @override
  final int typeId = 0;

  @override
  RestaurantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantModel(
      address: fields[0] as String?,
      avatar: fields[1] as String?,
      cash: fields[2] as int?,
      createdAt: fields[3] as String?,
      dailyCost: fields[4] as dynamic,
      id: fields[5] as int?,
      isActive: fields[6] as bool?,
      mapLat: fields[7] as String?,
      mapLong: fields[8] as String?,
      name: fields[9] as String?,
      phone: fields[10] as String?,
      zoneId: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.avatar)
      ..writeByte(2)
      ..write(obj.cash)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.dailyCost)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.mapLat)
      ..writeByte(8)
      ..write(obj.mapLong)
      ..writeByte(9)
      ..write(obj.name)
      ..writeByte(10)
      ..write(obj.phone)
      ..writeByte(11)
      ..write(obj.zoneId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
