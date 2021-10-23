import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet';

  @override
  _WalletScreenState createState() {
    return _WalletScreenState();
  }
}

class _WalletScreenState extends State<WalletScreen> {
  EtherAmount bal;
  BigInt balance;
  Client httpClient;
  Web3Client ethClient;
  String rpcUrl = 'http://10.0.2.2:7545';

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
      '60dcd659d87040d9f534bd081e4af2a027638ece77b278543fb555710902eaf9';

  Future<void> getCredentials() async {
    credentials = await EthPrivateKey.fromHex(privateKey);
    myAddress = await credentials.extractAddress();
    print(myAddress.toString());
    print(myAddress.hexEip55);
    print(await ethClient.getBalance(myAddress));
    bal = await ethClient.getBalance(myAddress);
    balance = bal.getInEther;
    print(balance);
  }

  Future<DeployedContract> getDeployedContract() async {
    String abi;
    EthereumAddress contractAddress;

    String abiString =
        await rootBundle.loadString('assets/abis/HospitalToken.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    print(abi);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "HospitalToken"), contractAddress);
    return contract;
  }

  ContractFunction balanceOf, coinName, coinSymbol;

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance() async {
    List<dynamic> result = await query("totalSupply", []);

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
      body: ZStack([
        VxBox()
            .blue600
            .size(context.screenWidth, context.percentHeight * 30)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "\$Ethers".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 3).heightBox,
          VxBox(
                  child: VStack([
            "Balance".text.black.xl2.semiBold.makeCentered(),
            10.heightBox,
            (balance.toString() + " Ethers")
                .text
                .black
                .xl2
                .semiBold
                .makeCentered(),
          ]))
              .p16
              .white
              .size(context.screenWidth, context.percentHeight * 18)
              .rounded
              .shadowXl
              .make()
              .p16(),
          30.heightBox,
          HStack(
            [
              FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                onPressed: () {
                  // Respond to button press
                },
                icon: Icon(Icons.refresh),
                label: Text('Refresh'),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                onPressed: () {
                  // Respond to button press
                },
                icon: Icon(Icons.call_made_outlined),
                label: Text('Send'),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                onPressed: () {
                  // Respond to button press
                },
                icon: Icon(Icons.call_received_outlined),
                label: Text('Recieve'),
              ),
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          ).p16()
        ])
      ]),
    );
  }
}
