import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      var gasPrice = await _client.getGasPrice();
      if (txReceipt?.cumulativeGasUsed != null) {
        String? culma = txReceipt?.cumulativeGasUsed.toString();
        var gasCostEstimation =
            BigInt.parse(culma.toString()) * gasPrice.getInWei;
        var gasAmountInWei = EtherAmount.fromUnitAndValue(
            EtherUnit.wei, gasCostEstimation.toString());

        var actualAmountInWei =
            EtherAmount.fromUnitAndValue(EtherUnit.ether, tx.value.getInEther);

        var totalAmount =
            (gasAmountInWei.getInWei + actualAmountInWei.getInWei) /
                BigInt.from(1000000000000000000);

        Map<String, String?> data = {
          "from": tx.from.hex.toString(),
          "to": tx.to?.hex.toString(),
          "value": tx.value.getInWei.toString(),
          "status": txReceipt?.status.toString(),
          "blockNumber": txReceipt?.blockNumber.blockNum.toString(),
          "contractAddress": txReceipt?.contractAddress?.hex.toString(),
          "cumulativeGasUsed": txReceipt?.cumulativeGasUsed.toString(),
          "gasUsed": txReceipt?.gasUsed.toString(),
          "transactionHash": transactionHash,
          "date":
              "${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}",
          "dateTime": DateTime.now().toIso8601String(),
          "totalAmountInEther": totalAmount.toString()
        };

        if (auth.currentUser?.uid.toString() != null) {
          userFirestore
              .doc(auth.currentUser?.uid.toString())
              .collection("transactions")
              .doc()
              .set(data);
          print(data);
        }
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

  Future<bool> storeUserRegistrationStatus(String walletAddressOfUser) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      Map<String, bool?> data = {"registerOnce": true};
      if (auth.currentUser?.uid.toString() != null) {
        var hospitalId;
        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('walletAddress', isEqualTo: walletAddressOfUser)
            .get();

        for (var doc in querySnapshot.docs) {
          // Getting data directly

          hospitalId = doc.data();

          if(doc.data()['registerOnce']==true) {
            return true;
          } else if(doc.data()['registerOnce']==false) {
            userFirestore.doc(auth.currentUser?.uid.toString()).update(data);
            return false;
          }
        }



      }
      return false;
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error.toString());
    }
  }


  Future<String> checkIfUserIsPresent(String walletAddressOfUser) async {
    try {

      if (auth.currentUser?.uid.toString() != null) {
        var hospitalId;
        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('walletAddress', isEqualTo: walletAddressOfUser)
            .get();

        for (var doc in querySnapshot.docs) {
          // Getting data directly

          hospitalId = doc.id;
        }
        return hospitalId;
      }
      return "";
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error.toString());
    }
  }

  Future<bool> sendHospitalRequest(
      String hospitalFirebaseId, String doctorAddress) async {
    String? userType = await WalletSharedPreference.getUserType();
    try {
      Map<String, dynamic?> data = {
        "address": doctorAddress,
        "userType": userType,
        "granted": false
      };
      if (auth.currentUser?.uid.toString() != null) {
        userFirestore
            .doc(hospitalFirebaseId)
            .collection("AccessControl")
            .add(data);
      }
      return true;
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error.toString());
    }
  }

  Future<bool> addPatientToDoctorList(
      String doctorFirebaseId, String walletAddress,patientName) async {


    try {
      Map<String, dynamic?> data = {
        "address": walletAddress,
        "patientName": patientName
      };
      if (auth.currentUser?.uid.toString() != null) {
        userFirestore
            .doc(doctorFirebaseId)
            .collection("PatientList")
            .add(data);
      }
      return true;
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error.toString());
    }
  }
}
