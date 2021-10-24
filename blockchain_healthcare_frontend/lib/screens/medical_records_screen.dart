import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/crypto.dart';

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


  MsgSignature _msgSignature;

  Future<void> getMessage(String password,String privateKey ) {
    Uint8List messageHash = hexToBytes(password);
    Uint8List privateKeyInt = hexToBytes(privateKey) ;

    MsgSignature _msgSignature = sign(messageHash, privateKeyInt);

    print(_msgSignature.r.toString());
    MsgSignature _msgSignature2 = MsgSignature(_msgSignature.r, _msgSignature.s, _msgSignature.v);
    Uint8List publicKeyInt = privateKeyBytesToPublic(privateKeyInt);
    print(isValidSignature(messageHash,_msgSignature2,publicKeyInt).toString());


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
                    getMessage("123456","fa2181fddd12174b96472263139f8c046b4074d27b71a63b7a0633a05e9dc08d");
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