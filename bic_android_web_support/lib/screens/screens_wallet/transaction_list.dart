import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../databases/wallet_shared_preferences.dart';
import '../../providers/wallet.dart';
import '../screens_wallet/transfer_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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

  String? walletAddress;


  firestore.CollectionReference? users;

  @override
  void initState() {
    // TODO: implement initState
    getCollectionReferenceData();
    super.initState();
  }





  Future<firestore.CollectionReference?> getFirestoreDocument(
      String userType) async {
    if (userType == 'Patient') {
      firestore.CollectionReference patientFirestore =
          firestore.FirebaseFirestore.instance.collection('Patient');
      return patientFirestore;
    } else if (userType == 'Doctor') {
      firestore.CollectionReference doctorFirestore =
          firestore.FirebaseFirestore.instance.collection('Doctor');
      return doctorFirestore;
    } else if (userType == 'Hospital') {
      firestore.CollectionReference hospitalFirestore =
          firestore.FirebaseFirestore.instance.collection('Hospital');
      return hospitalFirestore;
    } else if (userType == 'Pharmacy') {
      firestore.CollectionReference pharmacyFirestore =
          firestore.FirebaseFirestore.instance.collection('Pharmacy');
      return pharmacyFirestore;
    }

    return null;
  }

  Future<void> getCollectionReferenceData() async {
    String? userType = await WalletSharedPreference.getUserType();
    var walletDetails = await WalletSharedPreference.getWalletDetails();
    users = await getFirestoreDocument(userType!);
    setState(() {
      users;
      walletAddress = walletDetails!['walletAddress'];
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[]),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: users
              ?.doc(walletAddress)
              .collection("transactions")
              .orderBy("dateTime", descending: true)
              .limit(10)
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(

                              shape: RoundedRectangleBorder(
                                // side: BorderSide(
                                //     color: Theme.of(context).colorScheme.primary,
                                //     width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                              elevation: 4,
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                'To:',
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
                                                '${documents[position]['to'].toString().substring(0,4)+"..."+documents[position]['to'].toString().lastChars(4)}',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                'From:',
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
                                                '${documents[position]['from'].toString().substring(0,4)+"..."+documents[position]['from'].toString().lastChars(4)}',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                'Block Number:',
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
                                                '${documents[position]['blockNumber'].toString()}',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                'Transaction Hash:',
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
                                                '${documents[position]['transactionHash'].toString().substring(0,5)+"...."+documents[position]['transactionHash'].toString().lastChars(5)}',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                            ),
                                          ],
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
                                  '${documents[position]['totalAmountInEther'].toString()} ETH',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary),
                                ),
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


extension E on String {
  String lastChars(int n) => substring(length - n);
}
