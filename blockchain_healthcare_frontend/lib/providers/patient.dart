import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class Patient {
  final String name;
  final String personalDetails;
  final String signatureHash;
  final String hospitalAddress;
  final String walletAddress;



  Patient(
      {@required this.name,
        @required this.personalDetails,
        @required this.signatureHash,
        @required this.hospitalAddress,
        @required this.walletAddress});
}


class Patients with ChangeNotifier {
  EtherAmount bal;
  BigInt balance;
  Client httpClient;
  Web3Client ethClient;
  String rpcUrl;




}