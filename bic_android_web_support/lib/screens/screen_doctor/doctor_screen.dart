import 'dart:convert';
import 'dart:typed_data';

import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_details.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class DoctorRecordScreen extends StatefulWidget {
  static const routeName = '/doctor-record-screen';

  @override
  _DoctorRecordScreenState createState() {
    return _DoctorRecordScreenState();
  }
}

class _DoctorRecordScreenState extends State<DoctorRecordScreen> {
  String? role;
  late String doctorName;
  late String doctorIpfsHashData;
  late Map<String, dynamic> doctorIpfsHash;
  @override
  void initState() {
    role = '';
    doctorName = '';
    doctorIpfsHashData = '';
    // doctorIpfsHash = {
    //   "dcotor_name":"",
    //   "pharmacy_owner_name":"",
    //   "pharmacy_address":"",
    //   "pharmacy_year_origin":"",
    //   "pharmacy_phone_no":"",
    // };
    // fetchPharmacyData();
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Doctor Record"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: FloatingActionButton.extended(
            heroTag: "PatientDetails",
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.secondary,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetails(),
                ),
              );
            },
            icon: Image.asset("assets/icons/sign_in.png",
                color: Theme.of(context).colorScheme.secondary,
                width: 25,
                fit: BoxFit.fill,
                height: 25),
            label: const Text('Log In'),
          ),
        ),
      ),
    );
  }
}
