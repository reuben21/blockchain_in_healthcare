import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/crypto_api.dart';
import 'package:bic_android_web_support/screens/Widgets/CustomCard.dart';
import 'package:bic_android_web_support/screens/Widgets/CustomCardWallet.dart';
import 'package:bic_android_web_support/screens/screens_wallet/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart';
import 'package:pdf/widgets.dart' as BarcodeComponent;
import 'package:web3dart/web3dart.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:web_socket_channel/io.dart';
import '../../providers/wallet.dart';
import '../screens_wallet/transfer_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import '../../helpers/http_exception.dart' as exception;
import '../../helpers/keys.dart' as keys;
import 'package:barcode_widget/barcode_widget.dart';

class WalletView extends StatefulWidget {
  static const routeName = '/view-wallet';

  @override
  _WalletViewState createState() {
    return _WalletViewState();
  }
}

class _WalletViewState extends State<WalletView> {
  late Web3Client _client;
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
  List countForEntities = ['', '', '', ''];

  List<String> options = <String>['Select Account'];

  String walletAdd = '';
  late String scannedAddress;

  @override
  void initState() {
    // initiateSetup();
    balanceOfAccount = "null";
    balanceOfAccountInRs = "null";
    rateForEther = "null";

    getWalletFromDatabase();
    getAccountBalance();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  Future<void> getAccountBalance() async {
    try {
      print("getAccountBalance()");
      Credentials credentialsNew;
      EthereumAddress address;

      credentialsNew =
          Provider.of<WalletModel>(context, listen: false).walletCredentials;
      address = await credentialsNew.extractAddress();

      var countEntities = await Provider.of<WalletModel>(context, listen: false)
          .readContract("retrieveCountForEntities", []);
      // print("Role Status -"+dataRole);
      // var ethereumRate = await Provider.of<CryptoApiModel>(context,listen: false).getCryptoDataForEthInr();
      var ethereumRate = 258511.96959478396;
      var balance = await Provider.of<WalletModel>(context, listen: false)
          .getAccountBalance(EthereumAddress.fromHex(address.hex));
      var calculatedBalance =
          ((balance.getInWei) / BigInt.from(1000000000000000000)).toString();
      print(calculatedBalance + "----------" + ethereumRate.toString());
      setState(() {
        countForEntities = countEntities;
        balanceOfAccount = calculatedBalance;
        balanceOfAccountInRs =
            (double.parse(calculatedBalance) * ethereumRate).toStringAsFixed(2);
        rateForEther = "1 ETH = Rs. ${ethereumRate.toStringAsFixed(2)}";
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Refreshed Page")));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  Future<void> getWalletFromDatabase() async {
    var dbResponse = await WalletSharedPreference.getWalletDetails();
    walletAdd = dbResponse!['walletAddress'].toString();
    setState(() {
      walletAdd;
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
    // print(screenName + " " + options.toString());
    // print(screenName + " " + balanceOfAccount.toString());
    return Scaffold(
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
                    const SizedBox(
                      height: kIsWeb ? 1 : 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 220,
                        width: kIsWeb ? 500 : double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Colors.purpleAccent.withOpacity(0.9),
                                // Colors.lightBlueAccent,
                              ]),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // SizedBox(
                                  //     // height: 10,
                                  //     // width: 20,
                                  //     ),

                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                          "assets/icons/ethereum-500.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 32,
                                          height: 32),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        balanceOfAccount == "null"
                                            ? "0 ETH"
                                            : "$balanceOfAccount ETH",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        balanceOfAccountInRs == "null"
                                            ? "0 ₹"
                                            : "$balanceOfAccountInRs ₹",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  // Text('ehllo'),
                                ],
                              ),
                            ),
                            Card(

                                borderOnForeground: true,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  // side: BorderSide(
                                  //     color: Theme.of(context)
                                  //         .colorScheme
                                  //         .secondary,
                                  //     width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: Colors.red.withOpacity(0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SelectableText(walletAdd),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 125,
                                    height: 45,
                                    child: ElevatedButton.icon(
                                      icon: Image.asset(
                                          "assets/icons/pay-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 32,
                                          height: 32),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0.0,
                                        primary: Colors.red.withOpacity(0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            side: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
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
                                        await getAccountBalance();
                                      },
                                      child: Image.asset(
                                          "assets/icons/refresh-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 80,
                                          fit: BoxFit.scaleDown,
                                          height: 80),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          primary: Colors.red.withOpacity(0),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary))),
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
                                        primary: Colors.red.withOpacity(0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            side: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor: Theme.of(context)
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
                                              height: 260,
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    // TODO: GENERATE BARCODE COMPONENT
                                                    BarcodeWidget(
                                                      barcode: Barcode.qrCode(
                                                        errorCorrectLevel:
                                                            BarcodeQRCorrectionLevel
                                                                .high,
                                                      ),
                                                      data: walletAdd,
                                                      width: 200,
                                                      height: 200,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ]),
              1.heightBox,
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomCardWallet(onPressed: (){}, cardText: "Patient Count: ${countForEntities[0].toString()} ", imageAsset: Image.asset(
                              "assets/icons/patient-count-100.png",
                              color:
                              Theme.of(context).colorScheme.primary,
                              width: 50,
                              height: 50)),
                        ),
                        Expanded(
                          child: CustomCardWallet(onPressed: (){}, cardText: "Doctor Count: ${countForEntities[1].toString()} ", imageAsset: Image.asset(
                              "assets/icons/doctor-count-100.png",
                              color:
                              Theme.of(context).colorScheme.primary,
                              width: 50,
                              height: 50)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomCardWallet(onPressed: (){}, cardText: "Hospital Count: ${countForEntities[2].toString()} ", imageAsset: Image.asset(
                              "assets/icons/hospital-count-100.png",
                              color:
                              Theme.of(context).colorScheme.primary,
                              width: 50,
                              height: 50)),
                        ),
                        Expanded(
                          child: CustomCardWallet(onPressed: (){}, cardText: "Pharmacy Count: ${countForEntities[3].toString()} ", imageAsset: Image.asset(
                              "assets/icons/pharmacy-count-100.png",
                              color:
                              Theme.of(context).colorScheme.primary,
                              width: 50,
                              height: 50)),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 4,
                  // shadowColor: Theme.of(context).colorScheme.primary,
                  borderOnForeground: true,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(
                    //     color: Theme.of(context).colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(

                  leading: Image.asset("assets/icons/icons8-transaction-100.png",
                      color: Theme.of(context).primaryColor,
                      width: 25,
                      height: 25),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 4,
                  // shadowColor: Theme.of(context).colorScheme.primary,
                  borderOnForeground: true,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(
                    //     color: Theme.of(context).colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading:Image.asset("assets/icons/icons8-logout-100.png",
                            color: Theme.of(context).primaryColor,
                            width: 25,
                            height: 25) ,
                        trailing: Image.asset("assets/icons/forward-100.png",
                            color: Theme.of(context).primaryColor,
                            width: 25,
                            height: 25),
                        title: Text('Log Out',
                            style: Theme.of(context).textTheme.bodyText1),
                        onTap: () async {
                          var walletLogoutStatus =
                              await Provider.of<WalletModel>(context,
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
