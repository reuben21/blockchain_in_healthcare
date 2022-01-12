import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

class TransactionList extends StatefulWidget {
  static const routeName = '/transaction-list-screen';

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final String screenName = "view_wallet.dart";
  FirebaseAuth auth = FirebaseAuth.instance;

  CarouselController buttonCarouselController = CarouselController();

  late Credentials credentials;
  late EthereumAddress myAddress;
  late String balanceOfAccount;

  List<String> options = <String>['Select Account'];
  String dropdownValue = 'Select Account';
  String dropDownCurrentValue = 'Select Account';
  late String scannedAddress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[

          ]),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser?.uid)
              .collection("transactions").orderBy("dateTime",descending: true).limit(10)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                final documents = snapshot.data?.docs;
                print(documents?.length.toString());
                return SizedBox(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: documents?.length,
                        itemBuilder: (BuildContext context, int position) {
                          return Card(
                            color: Theme.of(context).colorScheme.secondary,
                            elevation: 0.0,
                            child: ExpansionTile(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                    documents![position]['status']
                                                .toString()
                                                .toLowerCase() ==
                                            "true"
                                        ? "assets/icons/ok-100.png"
                                        : "assets/icons/cancel-100.png",
                                    color: Theme.of(context).primaryColor,
                                    width: 32,
                                    height: 32),
                              ),
                              title: Text(
                                documents[position]['status']
                                            .toString()
                                            .toLowerCase() ==
                                        "true"
                                    ? "Success"
                                    : "Fail",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'To: ${documents[position]['to'].toString()}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'From: ${documents[position]['from'].toString()}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'Block Number: ${documents[position]['blockNumber'].toString()}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'Transaction Hash: ${documents[position]['transactionHash'].toString()}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              subtitle: Text(
                                'To: ${documents[position]['to']}',
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                              trailing: Text(
                                '${ documents[position]['totalAmountInEther'].toString()} ETH',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }
            }
            return const Center(
              child: Text('No Transactions Found As Of Yet'),
            );
          },
        ),
      ),
    );
  }
}
