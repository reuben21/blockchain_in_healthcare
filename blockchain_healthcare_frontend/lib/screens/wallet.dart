import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet';

  @override
  _WalletScreenState createState() {
    return _WalletScreenState();
  }
}

class _WalletScreenState extends State<WalletScreen> {
   Client httpClient;
   Web3Client ethClient;
   String rpcUrl = 'http://127.0.0.1:7545';

  @override
  void initState() {
    super.initState();
    initialSetup();

  }

  Future<void> initialSetup() async {
    httpClient = Client();
    ethClient = Web3Client(rpcUrl, httpClient);

    await getCredentials();

  }

   Credentials credentials;
   EthereumAddress myAddress;

  String privateKey =
      '81ec06bd270aba1032e3b9e87a41c201cb0f33c2cfaaf45a07d56316e14ca93d';



  Future<void> getCredentials() async {
    credentials = await EthPrivateKey.fromHex(privateKey);
    myAddress = await credentials.extractAddress();
    print(myAddress.toString());
    print(myAddress.hexEip55);
    print(await ethClient.getBalance(myAddress));
  }





  Future<DeployedContract> getDeployedContract() async {
    String abi;
    EthereumAddress contractAddress;

    String abiString = await rootBundle.loadString('assets/abis/HospitalToken.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    print(abi);

    contractAddress = EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "HospitalToken"), contractAddress);
    return contract;
  }

  ContractFunction balanceOf, coinName, coinSymbol;

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(contract: contract, function: ethFunction, params: args);
    return result;
  }



  Future<void> getBalance() async {

    List<dynamic> result = await query("totalSupply",[]);

    print(result[0].toString());
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

    );
  }
}