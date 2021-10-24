import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
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
  String rpcUrl;

  @override
  void initState() {
    super.initState();
    initialSetup();
  }

  Future<void> initialSetup() async {
    httpClient = Client();
    if (Platform.isAndroid) {
      // Android-specific code
      rpcUrl = 'http://10.0.2.2:7545';
    } else if (Platform.isIOS) {
      // iOS-specific code
      rpcUrl = 'http://127.0.0.1:7545';
    }
    ethClient = Web3Client(rpcUrl, httpClient);

    await getCredentials();
  }

  Credentials credentials;
  EthereumAddress myAddress;

  String privateKey =
      'fa2181fddd12174b96472263139f8c046b4074d27b71a63b7a0633a05e9dc08d';

  Future<void> getCredentials() async {
    credentials = await EthPrivateKey.fromHex(privateKey);
    myAddress = await credentials.extractAddress();

    print(await ethClient.getBalance(myAddress));
    bal = await ethClient.getBalance(myAddress);
    setState(() {
      balance = bal.getInEther;
    });
    print(balance);
  }

  Future<void> refreshBalance() async {
    bal = await ethClient.getBalance(myAddress);
    setState(() {
      balance = bal.getInEther;
    });
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
      body: Column(
        children: [
          ZStack([
            VxBox()
                .blue600
                .size(context.screenWidth, context.percentHeight * 30)
                .make(),
            VStack([
              // const Image(image: AssetImage('assets/ethereum.png')),
              // (context.percentHeight * 10).heightBox,
              // "\$ Ethers 1".text.xl4.white.bold.center.makeCentered().py16(),
              // Image(
              //     image: new AssetImage("assets/icons/ethereum.png"),
              //     height: 100,
              //     width: MediaQuery.of(context).size.width,
              //     fit: BoxFit.cover,
              //     // scale: 0.8
              //
              //     // fit: BoxFit.fitHeight,
              //     ),
              Image.asset(
                'assets/icons/ethereum.png',
                height: 140,
                width: MediaQuery.of(context).size.width * 2,
              ),

              // (context.percentHeight * 1).heightBox,
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
                      refreshBalance();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      // Respond to button press
                    },
                    icon: const Icon(Icons.call_made_outlined),
                    label: const Text('Send'),
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      // Respond to button press
                    },
                    icon: const Icon(Icons.call_received_outlined),
                    label: const Text('Recieve'),
                  ),
                ],
                alignment: MainAxisAlignment.spaceAround,
                axisSize: MainAxisSize.max,
              )
            ]),
          ]),
          10.heightBox,
        ],
      ),
    );
  }
}
