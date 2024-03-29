import 'dart:convert';
import 'dart:io';
import 'dart:math';


import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/provider_firebase/model_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_socket_channel/io.dart';

import '../helpers/keys.dart' as keys;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import '../helpers/http_exception.dart' as exception;
import 'package:web3dart/web3dart.dart';

class WalletModel with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  firestore.CollectionReference patientFirestore =
  firestore.FirebaseFirestore.instance.collection('Patient');
  firestore.CollectionReference doctorFirestore =
  firestore.FirebaseFirestore.instance.collection('Doctor');
  firestore.CollectionReference hospitalFirestore =
  firestore.FirebaseFirestore.instance.collection('Hospital');
  firestore.CollectionReference pharmacyFirestore =
  firestore.FirebaseFirestore.instance.collection('Pharmacy');

  late String _walletAddress;
  late String _walletPassword;
  late String _walletCredentials;
  late DateTime _expiryDate;
  late Credentials _credentials;


  bool get isWalletAvailable {
    print(_walletCredentials != null);
    return _walletCredentials != null;
  }

  String get walletDecryptedKey {
    return _walletCredentials;
  }

  Credentials get walletCredentials {
    return _credentials;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _walletCredentials != null) {
      return _walletCredentials;
    }
    return null;
  }

  late EtherAmount bal;
  late BigInt balance;
  late bool isLoading = true;
  late Web3Client _client;


  final String _rpcUrl = keys.rpcUrl;

  WalletModel() {
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

    return contract;
  }

  Future<EtherAmount> getAccountBalance(EthereumAddress address) async {
    try {

    return _client.getBalance(address);
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

  Future<List<dynamic>> readContract(
      String functionName,
      List<dynamic> functionArgs,
      ) async {
    final contract = await getDeployedContract();
    var queryResult = await _client.call(
      contract: contract,
      function: contract.function(functionName),
      params: functionArgs,
    );

    return queryResult;
  }

  Future<String> writeContract(String functionName,
      List<dynamic> functionArgs, Credentials credentials) async {
    final contract = await getDeployedContract();
    String transactionHash = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function(functionName),
        parameters: functionArgs,
      ),
    );
    return transactionHash;
  }

  // writeContract('storePharmacy', ['Pharmacy A','pharmacy ipfs hash',credentials.toString()], credentials);

  Future<firestore.CollectionReference?> getFirestoreDocument(String userType) async {

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

    return null;

  }
  Future<bool> transferEther(Credentials credentials, String senderAddress,
      String receiverAddress, String amount) async {
    try {
      EthereumAddress transactionTo;
      EthereumAddress transactionFrom;

      double ethAmount = double.parse(amount) * 1000000000000000000;
      print(ethAmount);

      String transactionHash = await _client.sendTransaction(
          credentials,
          Transaction(
              from: EthereumAddress.fromHex(senderAddress),
              to: EthereumAddress.fromHex(receiverAddress),
              value: EtherAmount.fromUnitAndValue(EtherUnit.wei, ethAmount.toStringAsFixed(0).toString())));

      TransactionInformation tx =
      await _client.getTransactionByHash(transactionHash);

      TransactionReceipt? txReceipt =
      await _client.getTransactionReceipt(transactionHash);


      var gasPrice = await _client.getGasPrice();
      if(txReceipt?.cumulativeGasUsed != null) {

        String? culma = txReceipt?.cumulativeGasUsed.toString();
        var gasCostEstimation = BigInt.parse(culma.toString()) * gasPrice.getInWei;
        var gasAmountInWei = EtherAmount.fromUnitAndValue(
            EtherUnit.wei, gasCostEstimation.toString());

        var actualAmountInWei =
        EtherAmount.fromUnitAndValue(EtherUnit.ether, tx.value.getInEther);

        var totalAmount = (gasAmountInWei.getInWei + actualAmountInWei.getInWei) /
            BigInt.from(1000000000000000000);

        Map<String,String?> data = {
          "from": tx.from.hex.toString(),
          "to": tx.to?.hex.toString(),
          "value": tx.value.getInWei.toString(),
          "status": txReceipt?.status.toString(),
          "blockNumber": txReceipt?.blockNumber.blockNum.toString(),
          "contractAddress": txReceipt?.contractAddress?.hex.toString(),
          "cumulativeGasUsed":txReceipt?.cumulativeGasUsed.toString(),
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
          "dateTime": DateTime.now().toIso8601String(),
          "totalAmountInEther":totalAmount.toString()

        };


        if (auth.currentUser?.uid.toString() != null) {
          String? userType = await WalletSharedPreference.getUserType();
          firestore.CollectionReference? users = await getFirestoreDocument(userType!);
          users?.doc(auth.currentUser?.uid.toString()).collection(
              "transactions").doc().set(data);
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

  Future<void> createWalletInternally(String fullName, String emailId,
      String? userId, String password, String userType) async {
    Credentials credentials;
    EthereumAddress myAddress;

    try {
      var rng = Random.secure();

      BigInt EthPrivateKeyInteger =
          EthPrivateKey
              .createRandom(rng)
              .privateKeyInt;

      credentials = EthPrivateKey.fromInt(EthPrivateKeyInteger);
      myAddress = await credentials.extractAddress();

      Wallet wallet = Wallet.createNew(
          EthPrivateKey.fromInt(EthPrivateKeyInteger), password, rng);

      _walletAddress = myAddress.hex.toString();
      _walletCredentials = wallet.toJson().toString();

      Wallet newWallet = Wallet.fromJson(_walletCredentials, password);
      print(newWallet.privateKey.privateKeyInt);


      firestore.CollectionReference? users = await getFirestoreDocument(userType);
      users?.doc(myAddress.hex.toString()).set({
        'userName': fullName,
        'userEmail': emailId,
        'walletAddress': newWallet.privateKey.address.hex,
        'walletEncryptedKey': _walletCredentials,
        'userType': userType,
        'registerOnce':false
      }).then((value) => {});


      await WalletSharedPreference.setWalletDetails(
          fullName, emailId,  newWallet.privateKey.address.hex, _walletCredentials,
          userType);

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

  Future<bool> signInWithWallet(String emailId, String? uid, String password,String userType) async {

    print(uid.toString() + " " + password+ " " + userType );


    try {

      firestore.CollectionReference? users = await getFirestoreDocument(userType);
      var querySnapshot = await users
          ?.where('userEmail', isEqualTo: emailId)
          .get();
      for (var doc in querySnapshot!.docs) {
        // Getting data directly
        var data = doc.data() as Map<String,dynamic>;


          String walletAddressFirestore =data['walletAddress'];
          String userEmailFirestore = data['userEmail'];
          String userNameFirestore = data['userName'];
          String userType = data['userType'];
          String walletEncryptedKeyFirestore = data['walletEncryptedKey'];

          await WalletSharedPreference.setWalletDetails(
              userNameFirestore, userEmailFirestore, walletAddressFirestore, walletEncryptedKeyFirestore,
              userType);
          Wallet newWallet = Wallet.fromJson(
              walletEncryptedKeyFirestore,
              password);
          _credentials = newWallet.privateKey;
          return true;

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
    notifyListeners();
  }

  Future<bool> walletLogOut() async {
    try {
      // final box = Boxes.getWallets();
      // box.deleteFromDisk();
      await WalletSharedPreference.deleteWalletData();
      auth.signOut();
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

  Future<Map<String, dynamic>> estimateGas(String senderAddress,
      String receiverAddress, String amount) async {
    try {
      double ethAmount = double.parse(amount) * 1000000000000000000;
      print(ethAmount.toStringAsFixed(0).toString());

      var gasEstimate = await _client.estimateGas(
          sender: EthereumAddress.fromHex(senderAddress),
          to: EthereumAddress.fromHex(receiverAddress),
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, ethAmount.toStringAsFixed(0).toString()));

      print(gasEstimate);
      var gasPrice = await _client.getGasPrice();

      var gasCostEstimation = gasEstimate * gasPrice.getInWei;

      var gasAmountInWei = EtherAmount.fromUnitAndValue(
          EtherUnit.wei, gasCostEstimation.toString());

      var actualAmountInWei = EtherAmount.fromUnitAndValue(
          EtherUnit.ether,  ethAmount.toStringAsFixed(0).toString());

      var totalAmount = (gasAmountInWei.getInWei + actualAmountInWei.getInWei) /
          BigInt.from(1000000000000000000);

      Map<String, dynamic> result = {
        "gasPrice": gasPrice.getInWei,
        "gasEstimate": gasEstimate,
        "gasCostEstimation": gasCostEstimation,
        "gasAmountInWei": gasAmountInWei.getInWei,
        "actualAmountInWei": amount,
        "totalAmount": amount
      };

      print(result);


      notifyListeners();
      return result;
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
