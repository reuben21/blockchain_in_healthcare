import 'dart:convert';
import 'dart:io';
import 'package:blockchain_healthcare_frontend/databases/wallet_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:blockchain_healthcare_frontend/helpers/http_exception.dart' as exception;
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class UniqueWalletModel {
  const UniqueWalletModel(this.walletAddress,this.walletString);
  final String walletAddress;
  final String walletString;


}


class WalletModel with ChangeNotifier {
  String _walletAddress;
  String _walletPassword;
  String _walletDecryptedKey;
  DateTime _expiryDate;


  bool get isWalletAvailable {

    print(_walletDecryptedKey != null);
    return _walletDecryptedKey != null;
  }

  String get walletDecryptedKey {
    return _walletDecryptedKey;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _walletDecryptedKey != null) {
      return _walletDecryptedKey;
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

  final String _rpcUrl = 'http://10.0.2.2:7545';

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

  Future<void> createWallet(String password) async {
    Credentials credentials;
    EthereumAddress myAddress;

    final url = Uri.parse("http://10.0.2.2:3000/wallet/create");
    try {
      final response = await http.post(url,
          body: json.encode({"password": password}),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          });
      // final List<OrderItem> loadedOrders = [];

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final wallet = Wallet.fromJson(json.encode(extractedData), password);
      print(wallet.privateKey);
      credentials = await wallet.privateKey;
      myAddress = await credentials.extractAddress();
      print(myAddress.hex);

      _walletAddress = myAddress.hex.toString() ;
      _walletPassword = password.toString();
      _walletDecryptedKey = extractedData.toString();
      _expiryDate = DateTime.now()
          .add(Duration(seconds: 172800));


      var dbResponse = await DBProviderWallet.db.newWallet(
          _walletAddress, _walletPassword, _walletDecryptedKey,_expiryDate.toIso8601String());
      // _orders = loadedOrders;
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

  Future<void> transferEther(

      Credentials credentials,
      String senderAddress,
      String receiverAddress,
      double amount

      ) async {



    await _client.sendTransaction(
      credentials,
        Transaction(
            from: EthereumAddress.fromHex(senderAddress),
            to: EthereumAddress.fromHex(receiverAddress),
            maxGas: 2000,
            gasPrice: EtherAmount.zero(),
            value: EtherAmount.fromUnitAndValue(EtherUnit.ether,amount )
        )
    );
  }
}
