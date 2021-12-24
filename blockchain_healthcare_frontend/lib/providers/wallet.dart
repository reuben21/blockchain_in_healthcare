import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:blockchain_healthcare_frontend/databases/transactions_database.dart';
import 'package:blockchain_healthcare_frontend/databases/wallet_database.dart';
import 'package:blockchain_healthcare_frontend/helpers/keys.dart' as keys;
import 'package:blockchain_healthcare_frontend/mongo_db/wallet_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:blockchain_healthcare_frontend/helpers/http_exception.dart'
    as exception;
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class UniqueWalletModel {
  const UniqueWalletModel(this.walletAddress, this.walletString);

  final String walletAddress;
  final String walletString;
}

class WalletModel with ChangeNotifier {
  String _walletAddress;
  String _walletPassword;
  String _walletCredentials;
  DateTime _expiryDate;

  bool get isWalletAvailable {
    print(_walletCredentials != null);
    return _walletCredentials != null;
  }

  String get walletDecryptedKey {
    return _walletCredentials;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _walletCredentials != null) {
      return _walletCredentials;
    }
    return null;
  }

  EtherAmount bal;
  BigInt balance;
  bool isLoading = true;
  Web3Client _client;
  String _abiCode;
  Credentials _credentials;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  ContractFunction _registerPatient;
  ContractFunction _getPatientData;
  ContractFunction _getUserAddress;
  ContractFunction _getSignatureHash;
  ContractFunction _getNewRecords;
  ContractFunction _updatePatientMedicalRecords;

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
        await rootBundle.loadString('assets/abis/HospitalToken.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "HospitalToken"), contractAddress);
    print("HospitalToken Contract Address:- " + contract.address.toString());
    // _registerPatient = contract.function('registerPatient');
    // _getSignatureHash = contract.function('getSignatureHash');
    // _getPatientData = contract.function('getPatientData');

    return contract;
  }

  Future<EtherAmount> getAccountBalance(EthereumAddress address) async {
    return _client.getBalance(address);
  }

  Future<List<dynamic>> readContract(
    ContractFunction functionName,
    List<dynamic> functionArgs,
  ) async {
    final contract = await getDeployedContract();
    var queryResult = await _client.call(
      contract: contract,
      function: functionName,
      params: functionArgs,
    );

    return queryResult;
  }

  Future<void> writeContract(ContractFunction functionName,
      List<dynamic> functionArgs, Credentials credentials) async {
    final contract = await getDeployedContract();
    await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: functionName,
        parameters: functionArgs,
      ),
    );
  }

  Future<void> createWalletInternally(String password) async {
    Credentials credentials;
    EthereumAddress myAddress;


    try {
      var rng = Random.secure();
     
      BigInt EthPrivateKeyInteger = EthPrivateKey.createRandom(rng).privateKeyInt;
      
      credentials = EthPrivateKey.fromInt(EthPrivateKeyInteger);
      myAddress = await credentials.extractAddress();
      
      Wallet wallet = Wallet.createNew(credentials, password, rng);
      
      _walletAddress = myAddress.hex.toString();
      _walletCredentials = wallet.toJson().toString();


      var dbResponse = await DBProviderWallet.db.newWallet(
          _walletAddress,
          _walletCredentials,
          );
      // _orders = loadedOrders;

      Wallet newWallet = Wallet.fromJson(_walletCredentials, password);
      print(newWallet.privateKey.privateKeyInt);

      var dbNewResponse = await MongoDBProviderWallet().newWallet(_walletAddress,
           _walletCredentials);

      notifyListeners();
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error);
    }
    notifyListeners();
  }

  Future<void> signInWithWallet(String walletAddress,String password) async {
    Credentials credentials;
    EthereumAddress myAddress;


    try {
      var dbNewResponse = await MongoDBProviderWallet().getWalletByWalletAddress(_walletAddress);
      print(dbNewResponse);
      Wallet newWallet = Wallet.fromJson(dbNewResponse[0]['walletEncryptedKey'], password);
      print(newWallet.privateKey.address);
      var dbResponse = await DBProviderWallet.db.newWallet(
          _walletAddress,
          dbNewResponse[0]['walletEncryptedKey']
          );





      notifyListeners();
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error);
    }
    notifyListeners();
  }



  Future<bool> transferEther(Credentials credentials, String senderAddress,
      String receiverAddress, String amount) async {
    try {
      EthereumAddress transactionTo;
      EthereumAddress transactionFrom;

      String transactionHash = await _client.sendTransaction(
          credentials,
          Transaction(
              from: EthereumAddress.fromHex(senderAddress),
              to: EthereumAddress.fromHex(receiverAddress),
              value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount)));



      TransactionInformation tx =
          await _client.getTransactionByHash(transactionHash);

      TransactionReceipt txReceipt =
      await _client.getTransactionReceipt(transactionHash);

      DateTime dateTime;
      dateTime = DateTime.now();

      var dbResponse = await DBProviderTransactions.db.newTransaction(transactionHash, tx.blockNumber.toString(),
          tx.value.getInEther.toString(), tx.from.hex, tx.to.hex,dateTime.toIso8601String());



      if(tx.hash.isNotEmpty) {
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
      throw exception.HttpException(error);
    }
    notifyListeners();
  }
}
