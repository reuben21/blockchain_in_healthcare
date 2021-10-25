import 'dart:convert';


import 'package:blockchain_healthcare_frontend/helpers/keys.dart' as keys;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class Patient {
  final String name;
  final String personalDetails;
  final String signatureHash;
  final EthereumAddress hospitalAddress;
  final EthereumAddress walletAddress;



  Patient(
      {@required this.name,
        @required this.personalDetails,
        @required this.signatureHash,
        @required this.hospitalAddress,
        @required this.walletAddress});
}


class PatientsModel with ChangeNotifier {
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



  PatientsModel(){
    initiateSetup();
  }

  Future<void> initiateSetup() async {

    _client = Web3Client(_rpcUrl, Client());

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
    await rootBundle.loadString("assets/abis/Patient.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(keys.privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Patient"), _contractAddress);

    _registerPatient = _contract.function("registerPatient");
    _getPatientData = _contract.function("getPatientData");
    _updatePatientMedicalRecords = _contract.function("updatePatientMedicalRecords");
    _getUserAddress = _contract.function("getUserAddress");
    _getSignatureHash = _contract.function("getSignatureHash");
    _getNewRecords = _contract.function("getNewRecords");

    // print("");
  }

  Future<void> registerPatient(Patient patient) async {
    isLoading = true;
    notifyListeners();
    final result = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _registerPatient,
            parameters: [
              patient.name,
              patient.personalDetails,
              patient.hospitalAddress,
              patient.walletAddress
            ]));

    return result;


  }

}