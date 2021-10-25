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
      '0e75aade5bd385616574bd6252b0d810f3f03f013dc43cbe15dc2e21e6ff4f14';

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
    List<dynamic> result = await query("balanceOf", []);

    print(result[0].toString());
  }

  Future<void> getCoinName() async {
    List<dynamic> result = await query("totalSupply", []);

    print(result[0].toString());
  }

  Future<void> getCoinSymbol() async {
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
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView(
                children: const [
                  Card(
                    elevation: 0.0,
                    child: ListTile(
                      leading: Icon(Icons.download_done),
                      title: Text(
                        'Received',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'From: 0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      trailing: Text('+ 0,0012 ETH'),
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    child: ListTile(
                      leading: Icon(Icons.download_done),
                      title: Text(
                        'Received',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      trailing: Text('+ 2 ETH'),
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    child: ListTile(
                      leading: Icon(Icons.download_done),
                      title: Text(
                        'Sent',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '0xE1ab66A6f9157b  02C32DE2682B0Fea298eA0b3eE',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      trailing: Text('- 0,003 ETH'),
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    child: ListTile(
                      leading: Icon(Icons.download_done),
                      title: Text(
                        'Recieved',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      trailing: Text('+ 0,0220 ETH'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
