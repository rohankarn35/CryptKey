// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passwordManagerModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordManagerModelAdapter extends TypeAdapter<PasswordManagerModel> {
  @override
  final int typeId = 0;

  @override
  PasswordManagerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordManagerModel(
      platform: fields[0] as String,
      username: fields[1] as String,
      password: fields[2] as String,
      platformName: fields[3] as String?,
      isUploaded: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordManagerModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.platform)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.platformName)
      ..writeByte(4)
      ..write(obj.isUploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordManagerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
