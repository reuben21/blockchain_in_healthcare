import 'dart:typed_data';
import 'package:bic_android_web_support/screens/screen_hospital/grant_access_to_patient_screen.dart';
import 'package:bic_android_web_support/screens/screen_hospital/revoke_access_screen.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import '../Widgets/CustomButtonGen.dart';
import '../screen_doctor/doctor_patient_medical_view.dart';
import '../screen_doctor/doctor_read_screen.dart';
import '../screen_patient/patient_read_screen.dart';
import 'grant_access_screen.dart';

class HospitalAccessControl extends StatefulWidget {
  static const routeName = '/hospital-access-control-screen';

  @override
  _HospitalAccessControlState createState() {
    return _HospitalAccessControlState();
  }
}

class _HospitalAccessControlState extends State<HospitalAccessControl> {
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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: const Text("Hospital Access Control"),
      // ),
      body: SingleChildScrollView(
        child: Container(
          child:  Column(
            children: [
              CustomButtonGen(cardText:'Grant Access',onPressed:()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GrantRoleScreen(),
                  ),
                )
              },imageAsset:Image.asset(
                "assets/icons/icons8-access-100.png",
                color: Theme.of(context).primaryColor,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),),

              CustomButtonGen(cardText:'Revoke Access',onPressed:()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RevokeRoleAccessScreen()),
                )
              },imageAsset:Image.asset(
                "assets/icons/icons8-no-access-100.png",
                color: Theme.of(context).primaryColor,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),),
              CustomButtonGen(cardText:'View Patient Details',onPressed:()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientReadScreen(),
                  ),
                )
              },imageAsset:Image.asset(
                "assets/icons/icons8-user-100.png",
                color: Theme.of(context).primaryColor,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),),
              CustomButtonGen(cardText:"View Medical Record For Patient",onPressed:()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DoctorPatientMedicalRecordView(),
                  ),
                )
              },imageAsset:Image.asset(
                "assets/icons/icons8-medical-history-100.png",
                color: Theme.of(context).primaryColor,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),),
              CustomButtonGen(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>DoctorReadScreen(),
                    ),
                  )
                },
                imageAsset:
                Image.asset("assets/icons/icons8-stethoscope-100.png",
                    color: Theme.of(context).primaryColor,
                    width: 20,
                    height: 20) ,
                cardText: 'View Doctor\'s Data',
              ),


            ],
          ),
            ),
      ),
    );
  }
}
