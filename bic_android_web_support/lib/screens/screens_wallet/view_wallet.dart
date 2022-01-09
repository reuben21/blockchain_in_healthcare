// import 'package:bic_android_web_support/providers/credentials.dart';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/crypto_api.dart';
import 'package:bic_android_web_support/screens/screens_wallet/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../../providers/wallet.dart';
import '../screens_wallet/transfer_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import '../../helpers/http_exception.dart' as exception;
import '../../helpers/keys.dart' as keys;

class WalletView extends StatefulWidget {
  static const routeName = '/view-wallet';

  @override
  _WalletViewState createState() {
    return _WalletViewState();
  }
}

class _WalletViewState extends State<WalletView> {
  final String screenName = "view_wallet.dart";
  FirebaseAuth auth = FirebaseAuth.instance;
  firestore.CollectionReference userFirestore =
      firestore.FirebaseFirestore.instance.collection('users');

  CarouselController buttonCarouselController = CarouselController();

  late Credentials credentials;
  late EthereumAddress myAddress;
  late String balanceOfAccount;
  late String balanceOfAccountInRs;
  late String rateForEther;

  List<String> options = <String>['Select Account'];

  String walletAdd = '';
  late String scannedAddress;

  @override
  void initState() {
    balanceOfAccount = "null";
    balanceOfAccountInRs = "null";
    rateForEther = "null";

    getWalletFromDatabase();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies


    super.didChangeDependencies();
  }

  Future<void> getWalletFromDatabase() async {
    var dbResponse = await WalletSharedPreference.getWalletDetails();
    walletAdd = dbResponse!['walletAddress'].toString();
    setState(() {
      walletAdd;
    });
  }

  Future<void> getAccountBalance(String walletAddress) async {
    // var ethereumRate = await Provider.of<CryptoApiModel>(context, listen: false)
    //     .getCryptoDataForEthInr();
    var ethereumRate = 258511.96959478396;
    var balance = await Provider.of<WalletModel>(context, listen: false)
        .getAccountBalance(EthereumAddress.fromHex(walletAddress));
    var calculatedBalance =
        ((balance.getInWei) / BigInt.from(1000000000000000000)).toString();
    print(calculatedBalance + "----------" + ethereumRate.toString());
    setState(() {
      balanceOfAccount = calculatedBalance;
      balanceOfAccountInRs =
          (double.parse(calculatedBalance) * ethereumRate).toStringAsFixed(2);
      rateForEther = "1 ETH = Rs. ${ethereumRate.toStringAsFixed(2)}";
    });
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getWalletFromDatabase();
    print(screenName + " " + options.toString());
    print(screenName + " " + balanceOfAccount.toString());
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      height: 10,
                      child: ListTile(
                        leading: const Icon(Icons.logout_outlined),
                        title: const Text(
                          'Log Out',
                          style: TextStyle(fontSize: 18),
                        ),
                        iconColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () async {
                        var walletLogoutStatus = await Provider.of<WalletModel>(
                                context,
                                listen: false)
                            .walletLogOut();
                        // getWalletFromDatabase();
                        if (walletLogoutStatus) {
                          Navigator.of(context).pushReplacementNamed("/");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ]),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            // color: Theme.of(context).colorScheme.primary,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ZStack([
                    Column(
                      children: [
                        // const SizedBox(
                        //   height: kIsWeb ? 10 : 50,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Colors.purpleAccent.withOpacity(0.9),
                                    // Colors.lightBlueAccent,
                                  ]),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      40.0, 28.0, 70.0, 28.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // SizedBox(
                                      //     // height: 10,
                                      //     // width: 20,
                                      //     ),
                                      Container(
                                        width: 60,
                                        height: 60,
                                        child: Image.asset(
                                            "assets/icons/ethereum-500.png",
                                            color: Theme.of(context)
                                                .colorScheme.secondary,
                                            width: 32,
                                            height: 32),

                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            balanceOfAccount == "null"
                                                ? "0 ETH"
                                                : "$balanceOfAccount ETH",
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            balanceOfAccountInRs == "null"
                                                ? "0 Rs"
                                                : "$balanceOfAccountInRs Rs",
                                            style:  TextStyle(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // Text('ehllo'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      HStack(
                                        [
                                          SizedBox(
                                            width: 125,
                                            height: 45,
                                            child: ElevatedButton.icon(
                                              icon: Image.asset(
                                                  "assets/icons/pay-100.png",
                                                  color: Theme.of(context)
                                                      .colorScheme.secondary,
                                                  width: 32,
                                                  height: 32),
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                primary:
                                                Colors.red.withOpacity(0),
                                                shape:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                    side: BorderSide(
                                                        color: Theme.of(context).colorScheme.secondary)),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TransferScreen(
                                                          address: walletAdd,
                                                        ),
                                                  ),
                                                );
                                              },
                                              label: const Text('Transfer'),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 70,
                                            height: 40,
                                            child: ElevatedButton(

                                              onPressed: () async {
                                                const snackBar = SnackBar(
                                                    content: Text(
                                                        'Balance Refreshed'));
                                                await getAccountBalance(
                                                    walletAdd);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              },

                                              child: Image.asset(
                                                  "assets/icons/refresh-100.png",
                                                  color:Theme.of(context).colorScheme.secondary,
                                                  width: 80,
                                                  fit: BoxFit.scaleDown,
                                                  height: 80),
                                              style:  ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                primary:
                                                Colors.red.withOpacity(0),
                                                shape:CircleBorder(side: BorderSide(
                                                    color: Theme.of(context).colorScheme.secondary))

                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 125,
                                            height: 45,
                                            child: ElevatedButton.icon(
                                              icon: Image.asset(
                                                  "assets/icons/qr-code-100.png",
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  width: 32,
                                                  height: 32),
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                primary:
                                                    Colors.red.withOpacity(0),
                                                shape:
                                                     RoundedRectangleBorder(
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                        side: BorderSide(
                                                            color: Theme.of(context).colorScheme.secondary)),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    title: Text(
                                                      "Show the QR Code",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                    content: Container(
                                                      width: 200,
                                                      height: 240,
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            QrImage(
                                                              data: walletAdd ==
                                                                      "Select Account"
                                                                  ? ""
                                                                  : "ethereum:" +
                                                                      walletAdd,
                                                              version:
                                                                  QrVersions.auto,
                                                              size: 200.0,
                                                            ),
                                                            Text(walletAdd)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx).pop();
                                                        },
                                                        child: const Text("okay"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              label: const Text('QR Code'),
                                            ),
                                          )
                                        ],
                                        alignment:
                                            MainAxisAlignment.spaceAround,
                                        axisSize: MainAxisSize.max,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     CarouselSlider.builder(
                        //       itemCount: options.length,
                        //       itemBuilder: (BuildContext context, int itemIndex,
                        //               int pageViewIndex) =>
                        //           Column(
                        //         children: [
                        //           Container(
                        //             width: 100,
                        //             height: 100,
                        //             decoration: BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               color: Theme.of(context)
                        //                   .colorScheme
                        //                   .secondary,
                        //               image: const DecorationImage(
                        //                   image: AssetImage(
                        //                       'assets/icons/ethereum.png'),
                        //                   fit: BoxFit.contain),
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             height: 10,
                        //           ),
                        //           Text(
                        //             balanceOfAccount == "null"
                        //                 ? "0 ETH"
                        //                 : "$balanceOfAccount ETH",
                        //             style: TextStyle(fontSize: 25),
                        //           ),
                        //           Text(
                        //             balanceOfAccountInRs == "null"
                        //                 ? "0 Rs"
                        //                 : "$balanceOfAccountInRs Rs",
                        //             style: TextStyle(fontSize: 18),
                        //           ),
                        //           Text(
                        //             rateForEther == "null"
                        //                 ? "0 Rs"
                        //                 : rateForEther,
                        //             style: TextStyle(fontSize: 18),
                        //           ),
                        //           const SizedBox(
                        //             height: 10,
                        //           ),
                        //         ],
                        //       ),
                        //       carouselController: buttonCarouselController,
                        //       options: CarouselOptions(
                        //         autoPlay: false,
                        //         enlargeCenterPage: true,
                        //         viewportFraction: 0.9,
                        //         aspectRatio: 2.0,
                        //         initialPage: 2,
                        //       ),
                        //     ),
                        //     DropdownButton<String>(
                        //         focusColor:
                        //             Theme.of(context).colorScheme.secondary,
                        //         dropdownColor:
                        //             Theme.of(context).colorScheme.primary,
                        //         value: dropdownValue,
                        //         selectedItemBuilder: (BuildContext context) {
                        //           return options.map((String value) {
                        //             if (value == "Select Account") {
                        //               return Text(
                        //                 "Select Account",
                        //                 style: TextStyle(
                        //                     color: Theme.of(context)
                        //                         .colorScheme
                        //                         .secondary),
                        //               );
                        //             } else {
                        //               return Text(
                        //                 dropdownValue
                        //                         .toString()
                        //                         .substring(0, 5) +
                        //                     "..." +
                        //                     dropdownValue
                        //                         .toString()
                        //                         .lastChars(5),
                        //                 style: TextStyle(
                        //                     color: Theme.of(context)
                        //                         .colorScheme
                        //                         .secondary),
                        //               );
                        //             }
                        //           }).toList();
                        //         },
                        //         items: options.map<DropdownMenuItem<String>>(
                        //             (String value) {
                        //           return DropdownMenuItem<String>(
                        //             value: value,
                        //             child: value == "Select Account"
                        //                 ? const Text("Select Account")
                        //                 : Text(
                        //                     value.toString().substring(0, 5) +
                        //                         "..." +
                        //                         value.toString().lastChars(5)),
                        //           );
                        //         }).toList(),
                        //         onChanged: (String? newValue) {
                        //           buttonCarouselController.animateToPage(
                        //               options.indexOf(newValue!),
                        //               duration: Duration(milliseconds: 300),
                        //               curve: Curves.linear);
                        //           setState(() {
                        //             dropdownValue = newValue;
                        //             dropDownCurrentValue = newValue;
                        //           });
                        //           getAccountBalance(newValue);
                        //           print(newValue);
                        //         },
                        //         style: Theme.of(context).textTheme.headline5,
                        //         hint: const Text("Select Account")),
                        //   ],
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                              clipBehavior: Clip.hardEdge,
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText(walletAdd),
                              )),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ]),
                  10.heightBox,
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          trailing: Image.asset("assets/icons/forward-100.png",
                              color: Theme.of(context).primaryColor,
                              width: 25,
                              height: 25),
                          title: Text('See Recent Transactions',
                              style: Theme.of(context).textTheme.bodyText1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionList(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
