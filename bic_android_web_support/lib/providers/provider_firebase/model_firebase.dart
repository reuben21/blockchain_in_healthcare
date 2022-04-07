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

  Future<firestore.CollectionReference> getFirestoreDocument(String userType) async {

    if (userType == 'Patient') {
      firestore.CollectionReference patientFirestore =
      firestore.FirebaseFirestore.instance.collection('Patient');
      return patientFirestore;
    } else if (userType == 'Doctor') {
      firestore.CollectionReference doctorFirestore =
      firestore.FirebaseFirestore.instance.collection('Doctor');
      return doctorFirestore;
    } else if (userType == 'Hospital') {
      firestore.CollectionReference hospitalFirestore =
      firestore.FirebaseFirestore.instance.collection('Hospital');
      return hospitalFirestore;
    } else if (userType == 'Pharmacy') {
      firestore.CollectionReference pharmacyFirestore =
      firestore.FirebaseFirestore.instance.collection('Pharmacy');
      return pharmacyFirestore;
    }

    firestore.CollectionReference patientFirestore =
    firestore.FirebaseFirestore.instance.collection('Patient');
    return patientFirestore;

  }

  Future<bool>  storeTransaction(String transactionHash) async {
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
          String? userType = await WalletSharedPreference.getUserType();
          var walletDetails = await WalletSharedPreference.getWalletDetails();
          firestore.CollectionReference userFirestore =
          firestore.FirebaseFirestore.instance.collection(userType!);
          userFirestore.doc(walletDetails!['walletAddress'])
              .collection("transactions")
              .doc()
              .set(data);



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

  Future<bool> storeUserRegistrationStatus(String walletAddressOfUser ) async {
    try {
      String? userType = await WalletSharedPreference.getUserType();
      firestore.CollectionReference users = await getFirestoreDocument(userType!);

      Map<String, bool?> newData = {"registerOnce": true};
      if (auth.currentUser?.uid.toString() != null) {
        var hospitalId;
        var querySnapshot = await users
            .where('walletAddress', isEqualTo: walletAddressOfUser)
            .get();

        for (var doc in querySnapshot.docs) {
          // Getting data directly

          var data = doc.data() as Map<String,dynamic>;
          print("SOMETHING: "+data['registerOnce'].toString());
          if (data['registerOnce'] == true) {
            return false;
          } else if (data['registerOnce'] == false) {
            users.doc(walletAddressOfUser).update(newData);
            return true;
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

  // Future<bool> checkIfHospitalIsPresent(String walletAddressOfUser) async {
  //   try {
  //     if (auth.currentUser?.uid.toString() != null) {
  //
  //       firestore.CollectionReference? users = await getFirestoreDocument('Hospital');
  //       var querySnapshot = await users
  //           .where('walletAddress', isEqualTo: walletAddressOfUser)
  //           .get();
  //
  //       for (var doc in querySnapshot!.docs) {
  //         // Getting data directly
  //         if(doc.exists) {
  //           return true;
  //         } else { return false; }
  //
  //       }
  //       return false;
  //     }
  //     return false;
  //   } on SocketException {
  //     throw exception.HttpException("No Internet connection 😑");
  //   } on HttpException {
  //     throw exception.HttpException("Couldn't find the post 😱");
  //   } on FormatException {
  //     throw exception.HttpException("Bad response format 👎");
  //   } catch (error) {
  //     throw exception.HttpException(error.toString());
  //   }
  // }

  // Future<bool> checkIfDoctorIsPresent(String walletAddressOfUser) async {
  //   try {
  //     if (auth.currentUser?.uid.toString() != null) {
  //
  //       firestore.CollectionReference? users = await getFirestoreDocument('Doctor');
  //       var querySnapshot = await users
  //           .where('walletAddress', isEqualTo: walletAddressOfUser)
  //           .get();
  //
  //       for (var doc in querySnapshot!.docs) {
  //         // Getting data directly
  //         if(doc.exists) {
  //           return true;
  //         } else { return false; }
  //
  //       }
  //       return false;
  //     }
  //     return false;
  //   } on SocketException {
  //     throw exception.HttpException("No Internet connection 😑");
  //   } on HttpException {
  //     throw exception.HttpException("Couldn't find the post 😱");
  //   } on FormatException {
  //     throw exception.HttpException("Bad response format 👎");
  //   } catch (error) {
  //     throw exception.HttpException(error.toString());
  //   }
  // }

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
        firestore.CollectionReference? users = await getFirestoreDocument('Hospital');

        users
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
      String doctorFirebaseId, String walletAddress, patientName) async {
    try {
      Map<String, dynamic?> data = {
        "address": walletAddress,
        "patientName": patientName
      };
      if (auth.currentUser?.uid.toString() != null) {
        userFirestore.doc(doctorFirebaseId).collection("PatientList").add(data);
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
