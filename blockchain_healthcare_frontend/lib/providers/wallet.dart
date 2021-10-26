import 'dart:convert';


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


  final String _rpcUrl = 'http://10.0.2.2:7545';



  WalletModel(){
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
    print("HospitalToken Contract Address:- "+contract.address.toString());
    _registerPatient = contract.function('registerPatient');
    _getSignatureHash = contract.function('getSignatureHash');
    _getPatientData = contract.function('getPatientData');

    return contract;
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

  Future<void> writeContract(
      ContractFunction functionName,
      List<dynamic> functionArgs,
      Credentials credentials
      ) async {
    final contract = await getDeployedContract();
    await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract:  contract,
        function: functionName,
        parameters: functionArgs,
      ),
    );
  }

}