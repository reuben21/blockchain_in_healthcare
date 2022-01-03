import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'hive_database.g.dart';

@HiveType(typeId: 0)
class WalletHive extends HiveObject {

  @HiveField(0)
  late String walletAddress;
  
  @HiveField(1)
  late String walletEncryptedKey;

  @HiveField(2)
  late String userName;

  @HiveField(3)
  late String userEmail;


  @HiveField(4)
  late DateTime createdDate;
}

