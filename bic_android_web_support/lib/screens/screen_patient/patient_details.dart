import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:flutter/material.dart';

class PatientDetails extends StatefulWidget {
  static const routeName = '/patientDetail';
  const PatientDetails({Key? key}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: Background(
        child: Container(),
      ),
    );
  }
}
