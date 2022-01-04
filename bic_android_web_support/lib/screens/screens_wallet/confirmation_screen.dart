import 'dart:convert';

import 'package:bic_android_web_support/databases/boxes.dart';
import 'package:bic_android_web_support/databases/hive_database.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';

import '../../providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:web3dart/credentials.dart';

class ConfirmationScreen extends StatefulWidget {
  static const routeName = '/confirmation-screen';

  final String receiverAddress;
  final String senderAddress;
  final String password;
  final String amount;

  const ConfirmationScreen(
      {required this.receiverAddress,
      required this.amount,
      required this.password,
      required this.senderAddress});

  @override
  _ConfirmationScreenState createState() {
    return _ConfirmationScreenState();
  }
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {

   BigInt? gasEstimate;
   BigInt? gasPrice;
   String? totalAmount;


  @override
  void initState() {

    getGasEstimate();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }
  Future<void> getGasEstimate() async {
    var txStatus = await Provider.of<WalletModel>(context,
        listen: false)
        .estimateGas( widget.senderAddress,
        widget.receiverAddress, widget.amount);
    setState(() {
      gasEstimate = txStatus['gasEstimate'];
      gasPrice = txStatus['gasPrice'];
      totalAmount = txStatus['totalAmount'];
    });


  }

  @override
  void dispose() {
    super.dispose();
  }


  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        "Confirmation Screen",
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "From: " + widget.senderAddress,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "To: " + widget.receiverAddress,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ether Amount: ",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.amount,
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Gas Estimate: ",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            gasEstimate.toString()+" units",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Gas Price: ",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            gasPrice.toString()+" Wei",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "(Approx.) Total Ether Amount: ",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            totalAmount.toString()+" ETH",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed:  () async {
                      Credentials credentialsNew;
                      EthereumAddress myAddress;

                        String amount = widget.amount;
                        String receiverAddress = widget.receiverAddress;
                        String password = widget.password;
                        // var dbResponse =
                        // await DBProviderWallet.db.getWalletByWalletAddress(widget.address);
                        // print(dbResponse);

                        if (true) {
                          final box = Boxes.getWallets();
                          var dbResponse =
                          box.values.toList().cast<WalletHive>();

                          Wallet newWallet = Wallet.fromJson(
                              dbResponse[0].walletEncryptedKey, password);
                          credentialsNew = newWallet.privateKey;
                          myAddress = await credentialsNew.extractAddress();
                          print(myAddress);
                          var txStatus = await Provider.of<WalletModel>(context,
                              listen: false)
                              .transferEther(credentialsNew, myAddress.hex,
                              receiverAddress, amount);
                          if (txStatus) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TabsScreen(),
                              ),
                            );
                          }
                        }
                      }
                    ,
                    icon: const Icon(Icons.add_circle_outline_outlined),
                    label: const Text('Confirm Pay'),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
