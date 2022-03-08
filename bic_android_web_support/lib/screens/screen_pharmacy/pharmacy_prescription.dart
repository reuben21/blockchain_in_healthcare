import 'dart:convert';
import 'dart:typed_data';

import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class PharmacyPrescriptionScreen extends StatefulWidget {
  static const routeName = '/pharmacy-prescription-screen';

  @override
  _PharmacyPrescriptionScreenState createState() {
    return _PharmacyPrescriptionScreenState();
  }
}

class _PharmacyPrescriptionScreenState
    extends State<PharmacyPrescriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String privateKey =
      '0e75aade5bd385616574bd6252b0d810f3f03f013dc43cbe15dc2e21e6ff4f14';

  Future<void> getMessage(String password, String publicKeyString) async {
    Credentials credentials;
    EthereumAddress publicAddress;
    credentials = EthPrivateKey.fromHex(privateKey);
    publicAddress = await credentials.extractAddress();
    print("Public Address:- " + publicAddress.toString());
    //
    // publicAddress =  EthereumAddress.fromHex(publicKey);

    if (publicAddress.toString() == publicKeyString.toLowerCase()) {
      Uint8List messageHash = hexToBytes(password);
      Uint8List privateKeyInt = EthPrivateKey.fromHex(privateKey).privateKey;

      MsgSignature _msgSignature = sign(messageHash, privateKeyInt);

      MsgSignature _msgSignature2 =
          MsgSignature(_msgSignature.r, _msgSignature.s, _msgSignature.v);

      Uint8List publicKey = privateKeyBytesToPublic(privateKeyInt);

      print(
          isValidSignature(messageHash, _msgSignature2, publicKey).toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text("Pharmacy Prescription"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 125,
                        width: 125,
                        child: Card(
                          color: Theme.of(context).colorScheme.primary,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Image.asset("assets/icons/hospital-count-100.png",
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 50,
                                  height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Hospital Count",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 125,
                        width:  125,
                        child: Card(
                          color: Theme.of(context).colorScheme.primary,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Image.asset("assets/icons/hospital-count-100.png",
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 50,
                                  height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Hospital Count",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //   FloatingActionButton.extended(
                      //     backgroundColor: Theme.of(context).colorScheme.secondary,
                      //     foregroundColor: Theme.of(context).colorScheme.primary,
                      //     onPressed: () async {
                      //       Map<String, dynamic> objText = {
                      //         "firstName": "Rhea",
                      //         "lastName": "Coutinho",
                      //         "lastName2": "Coutinho",
                      //         "lastName3": "Coutinho",
                      //         "lastName4": ["Coutinho", "Coutinho", "Coutinho"],
                      //         "age": 30
                      //       };
                      //       var hashReceived =
                      //       await Provider.of<IPFSModel>(context, listen: false)
                      //           .sendData(objText);
                      //       print("hashReceived ------" + hashReceived.toString());
                      //     },
                      //     icon: const Icon(Icons.qr_code_scanner),
                      //     label: const Text('Send Pharmacy Prescription'),
                      //   ),
                      //   FloatingActionButton.extended(
                      //     backgroundColor: Theme.of(context).colorScheme.secondary,
                      //     foregroundColor: Theme.of(context).colorScheme.primary,
                      //     onPressed: () async {
                      //       var dataReceived =
                      //       await Provider.of<IPFSModel>(context, listen: false)
                      //           .receiveData(
                      //           "Qmag49qRfLCsyDcBgkp7bf21ox4HgnEgHuYxKxjTjodbmx");
                      //       print("dataReceived ------" + dataReceived!['firstName']);
                      //     },
                      //     icon: const Icon(Icons.qr_code_scanner),
                      //     label: const Text('Receive'),
                      //   ),
                      //   FloatingActionButton.extended(
                      //     heroTag: "PatientDetails",
                      //     backgroundColor: Theme.of(context).colorScheme.primary,
                      //     foregroundColor: Theme.of(context).colorScheme.secondary,
                      //     onPressed: () async {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => PatientDetails(),
                      //         ),
                      //       );
                      //     },
                      //     icon: Image.asset("assets/icons/sign_in.png",
                      //         color: Theme.of(context).colorScheme.secondary,
                      //         width: 25,
                      //         fit: BoxFit.fill,
                      //         height: 25),
                      //     label: const Text('Log In'),
                      //   ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    Container(
                      height: 125,
                      width: 125,
                      child: Card(
                        // color: Theme.of(context).colorScheme.primary,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "1",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Image.asset("assets/icons/hospital-count-100.png",
                                color: Theme.of(context).colorScheme.primary,
                                width: 50,
                                height: 50),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Hospital Count",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 125,
                      width:  125,
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "1",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Image.asset("assets/icons/hospital-count-100.png",
                                color: Theme.of(context).colorScheme.secondary,
                                width: 50,
                                height: 50),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Hospital Count",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //   FloatingActionButton.extended(
                    //     backgroundColor: Theme.of(context).colorScheme.secondary,
                    //     foregroundColor: Theme.of(context).colorScheme.primary,
                    //     onPressed: () async {
                    //       Map<String, dynamic> objText = {
                    //         "firstName": "Rhea",
                    //         "lastName": "Coutinho",
                    //         "lastName2": "Coutinho",
                    //         "lastName3": "Coutinho",
                    //         "lastName4": ["Coutinho", "Coutinho", "Coutinho"],
                    //         "age": 30
                    //       };
                    //       var hashReceived =
                    //       await Provider.of<IPFSModel>(context, listen: false)
                    //           .sendData(objText);
                    //       print("hashReceived ------" + hashReceived.toString());
                    //     },
                    //     icon: const Icon(Icons.qr_code_scanner),
                    //     label: const Text('Send Pharmacy Prescription'),
                    //   ),
                    //   FloatingActionButton.extended(
                    //     backgroundColor: Theme.of(context).colorScheme.secondary,
                    //     foregroundColor: Theme.of(context).colorScheme.primary,
                    //     onPressed: () async {
                    //       var dataReceived =
                    //       await Provider.of<IPFSModel>(context, listen: false)
                    //           .receiveData(
                    //           "Qmag49qRfLCsyDcBgkp7bf21ox4HgnEgHuYxKxjTjodbmx");
                    //       print("dataReceived ------" + dataReceived!['firstName']);
                    //     },
                    //     icon: const Icon(Icons.qr_code_scanner),
                    //     label: const Text('Receive'),
                    //   ),
                    //   FloatingActionButton.extended(
                    //     heroTag: "PatientDetails",
                    //     backgroundColor: Theme.of(context).colorScheme.primary,
                    //     foregroundColor: Theme.of(context).colorScheme.secondary,
                    //     onPressed: () async {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => PatientDetails(),
                    //         ),
                    //       );
                    //     },
                    //     icon: Image.asset("assets/icons/sign_in.png",
                    //         color: Theme.of(context).colorScheme.secondary,
                    //         width: 25,
                    //         fit: BoxFit.fill,
                    //         height: 25),
                    //     label: const Text('Log In'),
                    //   ),
                  ],
                ),
              ],
            ),
          ),
          ),
        );
  }
}
