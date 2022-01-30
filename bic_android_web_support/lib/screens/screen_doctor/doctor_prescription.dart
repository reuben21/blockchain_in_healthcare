import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/src/rendering/box.dart';
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

class DoctorPrescriptionScreen extends StatefulWidget {
  static const routeName = '/doctor-prescription-screen';

  @override
  _DoctorPrescriptionScreenState createState() {
    return _DoctorPrescriptionScreenState();
  }
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
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
  int _activeCurrentStep = 0;


  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  List<Step> stepList() => [
    // This is step1 which is called Account.
    // Here we will fill our personal details
    Step(
      state: _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeCurrentStep >= 0,
      title: const Text('Prescription'),
      content: SizedBox(
        height:500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full Name',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ],
        ),
      ),
    ),
    // This is Step2 here we will enter our address
    Step(
        state:
        _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeCurrentStep >= 1,
        title: const Text('Details'),
        content: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full House Address',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: pincode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pin Code',
                ),
              ),
            ],
          ),
        )),

    // This is Step3 here we will display all the details
    // that are entered by the user
    Step(
        state: StepState.complete,
        isActive: _activeCurrentStep >= 2,
        title: const Text('Confirmation'),
        content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Name: ${name.text}' ,style:TextStyle(color: Colors.deepPurple, fontSize: 15)),
                Text('Email: ${email.text}',style:TextStyle(color: Colors.deepPurple, fontSize: 15)),
                Text('Password: ${pass.text}',style:TextStyle(color: Colors.deepPurple, fontSize: 15)),
                Text('Address : ${address.text}',style:TextStyle(color: Colors.deepPurple, fontSize: 15)),
                Text('PinCode : ${pincode.text}',style:TextStyle(color: Colors.deepPurple, fontSize: 15)),
              ],
            )))
  ];



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Prescription Generation"),
      ),
      body:
                Center(
                  child: Stepper(
      type: StepperType.horizontal,
    currentStep: _activeCurrentStep,
    steps: stepList(),
    onStepContinue: () {
    if (_activeCurrentStep < (stepList().length - 1)) {
    setState(() {
    _activeCurrentStep += 1;
    });
    }
    },
    onStepCancel: () {
    if (_activeCurrentStep == 0) {
    return;
    }
    setState(() {
    _activeCurrentStep -= 1;
    });
    },
    onStepTapped: (int index) {
    setState(() {
    _activeCurrentStep = index;
    });
    },

    ),
                ),

    );
  }
}

