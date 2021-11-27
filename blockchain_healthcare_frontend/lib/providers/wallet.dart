import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blockchain_healthcare_frontend/helpers/keys.dart' as keys;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';


class WalletModel with ChangeNotifier {
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


  final String _rpcUrl = 'http://127.0.0.1:7545';


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
    _registerPatient = contract.function('registerPatient');
    _getSignatureHash = contract.function('getSignatureHash');
    _getPatientData = contract.function('getPatientData');

    return contract;
  }


  Future<List<dynamic>> readContract(ContractFunction functionName,
      List<dynamic> functionArgs,) async {
    final contract = await getDeployedContract();
    var queryResult = await _client.call(
      contract: contract,
      function: functionName,
      params: functionArgs,
    );

    return queryResult;
  }

  Future<void> writeContract(ContractFunction functionName,
      List<dynamic> functionArgs,
      Credentials credentials) async {
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


  Future<void> createWallet() async {

    Credentials credentials;
    EthereumAddress myAddress;

    final url = Uri.parse("http://localhost:3000/wallet/create");
    final response = await http.post(url,body: json.encode({
    "password":"Reuben21"
    }),headers: { 'Content-type': 'application/json',
    'Accept': 'application/json'}
    );
    // final List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null) {
    return;
    }

    final wallet = Wallet.fromJson(json.encode(extractedData), "Reuben21");
    print(wallet.privateKey);
    credentials = await wallet.privateKey;
    myAddress = await credentials.extractAddress();
    print(myAddress.hex);
    // _orders = loadedOrders;
    notifyListeners();
    }


  }