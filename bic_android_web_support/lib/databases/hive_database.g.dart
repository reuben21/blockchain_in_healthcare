// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletHiveAdapter extends TypeAdapter<WalletHive> {
  @override
  final int typeId = 0;

  @override
  WalletHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletHive()
      ..walletAddress = fields[0] as String
      ..walletEncryptedKey = fields[1] as String
      ..userName = fields[2] as String
      ..userEmail = fields[3] as String
      ..createdDate = fields[4] as DateTime;
  }

  @override
  void write(BinaryWriter writer, WalletHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.walletAddress)
      ..writeByte(1)
      ..write(obj.walletEncryptedKey)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.userEmail)
      ..writeByte(4)
      ..write(obj.createdDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
