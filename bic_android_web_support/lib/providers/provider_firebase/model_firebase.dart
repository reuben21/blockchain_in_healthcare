import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../../helpers/keys.dart' as keys;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import '../../helpers/http_exception.dart' as exception;
import 'package:web3dart/web3dart.dart';

class FirebaseModel with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  firestore.CollectionReference userFirestore =
  firestore.FirebaseFirestore.instance.collection('users');

  late Web3Client _client;
  final String _rpcUrl = keys.rpcUrl;


  FirebaseModel() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client());
    getDeployedContract();
  }

  Future<DeployedContract> getDeployedContract() async {
    String abi;
    EthereumAddress contractAddress;

    String abiString =
    await rootBundle.loadString('assets/abis/MainContract.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "MainContract"), contractAddress);
    print("MainContract Contract Address:- " + contract.address.toString());

    return contract;
  }


  Future<bool> storeTransaction(String transactionHash) async {
    try {

      TransactionInformation tx =
      await _client.getTransactionByHash(transactionHash);

      TransactionReceipt? txReceipt =
      await _client.getTransactionReceipt(transactionHash);

      if (auth.currentUser?.uid.toString() != null) {
        userFirestore.doc(auth.currentUser?.uid.toString()).collection(
            "transactions").doc().set({
          "from": tx.from.hex.toString(),
          "to": tx.to?.hex.toString(),
          "value": tx.value.getInWei.toString(),
          "status": txReceipt?.status.toString(),
          "blockNumber": txReceipt?.blockNumber.blockNum.toString(),
          "contractAddress": txReceipt?.contractAddress?.hex.toString(),
          "gasUsed": txReceipt?.gasUsed.toString(),
          "transactionHash": transactionHash,
          "date": "${DateTime
              .now()
              .year
              .toString()}-${DateTime
              .now()
              .month
              .toString()}-${DateTime
              .now()
              .day
              .toString()}",
          "dateTime": DateTime.now().toIso8601String()
        });
      }

      if (tx.hash.isNotEmpty) {
        return true;
      } else {
        return false;
      }
      notifyListeners();
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error.toString());
    }
    notifyListeners();
  }




}