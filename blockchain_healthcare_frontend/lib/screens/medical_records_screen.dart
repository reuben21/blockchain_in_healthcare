import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class MedicalRecordScreen extends StatefulWidget {
  static const routeName = '/medical_records';

  @override
  _MedicalRecordScreenState createState() {
    return _MedicalRecordScreenState();
  }
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
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




  Future<void> getMessage(String password,String publicKeyString  ) async {
    Credentials credentials;
    EthereumAddress publicAddress;
    credentials = EthPrivateKey.fromHex(privateKey);
    publicAddress = await credentials.extractAddress();
    print("Public Address:- " +publicAddress.toString());
    //
    // publicAddress =  EthereumAddress.fromHex(publicKey);

    if(publicAddress.toString() == publicKeyString.toLowerCase()) {
      Uint8List messageHash = hexToBytes(password);
      Uint8List privateKeyInt = EthPrivateKey.fromHex(privateKey).privateKey ;

      MsgSignature _msgSignature = sign(messageHash, privateKeyInt);


      MsgSignature _msgSignature2 = MsgSignature(_msgSignature.r, _msgSignature.s, _msgSignature.v);

      Uint8List publicKey = privateKeyBytesToPublic(privateKeyInt);


      print(isValidSignature(messageHash,_msgSignature2,publicKey).toString());


    }


  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: ZStack([
          VxBox()
              .blue600
              .size(context.screenWidth, context.percentHeight * 30)
              .make(),
          VStack([
            (context.percentHeight * 10).heightBox,
            "\$ Ethers 1".text.xl4.white.bold.center.makeCentered().py16(),
            (context.percentHeight * 3).heightBox,
            VxBox(
                child: VStack([
                  "Balance".text.black.xl2.semiBold.makeCentered(),
                  10.heightBox,
                  (" Ethers")
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
                    getMessage("123456","0xC30aC339bd3479eb62eD6fE71C1A0A59FA177F7B");
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
          ])
        ]),
      ),
    );
  }
}