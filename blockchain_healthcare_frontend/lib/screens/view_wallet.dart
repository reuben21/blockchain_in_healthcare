import 'dart:convert';
import 'dart:io' show Platform;
import 'package:blockchain_healthcare_frontend/databases/wallet_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

class WalletView extends StatefulWidget {
  static const routeName = '/view-wallet';

  @override
  _WalletViewState createState() {
    return _WalletViewState();
  }
}

class _WalletViewState extends State<WalletView> {
  int _value = 0;
  List<String> options = <String>['Select Account'];
  String dropdownValue = 'Select Account';
  String _selectedField;

  @override
  void initState() {
    print("Hello Init");

    super.initState();

  }
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    print("Hello Init didChangeDependencies");
    getWalletFromDatabase();
    super.didChangeDependencies();
  }

  Future<void> getWalletFromDatabase() async {

    var dbResponse = await DBProviderWallet.db.getWallet;
    print(dbResponse['walletAddress']);
    var newAddress = dbResponse["walletAddress"].toString().substring(0,5)+".."+dbResponse["walletAddress"].toString().lastChars(10);
    options.add(newAddress);

    setState(() {
      options;
    });


  }





  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(options);
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(

          children: [
            ZStack([

              Column(
                children: [


                  const SizedBox(
                    height: 80,
                  ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary,
                          image: const DecorationImage(
                              image: AssetImage('assets/icons/ethereum.png'),
                              fit: BoxFit.contain
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("0 ETH", style: Theme.of(context).textTheme.headline2,),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                          focusColor:Theme.of(context).colorScheme.secondary ,
                          dropdownColor: Theme.of(context).colorScheme.primary,
                          value: dropdownValue,
                          selectedItemBuilder: (BuildContext context) {
                            return options.map((String value) {
                              return Text(
                                dropdownValue,
                                style: const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                          items: options.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged:(String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          style: Theme.of(context).textTheme.headline5,
                          hint:const Text("Select Account")
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  HStack(
                    [
                      FloatingActionButton.extended(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          getWalletFromDatabase();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          // Respond to button press
                        },
                        icon: const Icon(Icons.call_made_outlined),
                        label: const Text('Send'),
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
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

                ],
              ),
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
      ),
    );
  }
}


extension E on String {
  String lastChars(int n) => substring(length - n);
}
