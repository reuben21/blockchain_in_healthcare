
import 'package:flutter/cupertino.dart';
import 'package:web3dart/web3dart.dart';

enum WalletType {
  firebase,
  metamask
}

class WalletItem {
  final String walletAddress;
  final Credentials walletCredentials;
  final WalletType walletType;



  WalletItem(
      {required this.walletAddress,
        required this.walletCredentials,
        required this.walletType,
        });
}