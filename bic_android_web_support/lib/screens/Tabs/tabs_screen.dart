import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_prescription_form.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_screen.dart';
import 'package:bic_android_web_support/screens/screen_hospital/hospital_access_control.dart';
import 'package:bic_android_web_support/screens/screen_hospital/hospital_screen.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_medicine_screen.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_screen.dart';
import 'package:bic_android_web_support/screens/screen_pharmacy/pharmacy_prescription.dart';
import 'package:bic_android_web_support/screens/screen_pharmacy/pharmacy_screen.dart';
import 'package:bic_android_web_support/screens/screens_wallet/view_wallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../../screens/medical_records_screen.dart';
import '../screen_doctor/doctor_prescription_screen.dart';
import '../screen_patient/prescription_screen.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';

  @override
  _TabsScreenState createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Widget>> screen = [
    {'page': PatientRecordScreen()},
    {'page': PrescriptionScreen()},
    {'page': WalletView()}
  ];



  late final List<Map<String, Widget>> _screensPatient = [
    {'page': PatientRecordScreen()},
    {'page': PatientMedicineScreen()},
    {'page': WalletView()}
  ];

  late final List<Map<String, Widget>> _screensDoctor = [
    {'page': DoctorRecordScreen()},
    {'page': DoctorPrescriptionScreen()},
    {'page': WalletView()}
  ];

  late final List<Map<String, Widget>> _screensPharmacy = [
    {'page': PharmacyRecordScreen()},
    {'page': PharmacyPrescriptionScreen()},
    {'page': WalletView()}
  ];

  late final List<Map<String, Widget>> _screensHospital = [
    {'page': HospitalScreen()},
    {'page': HospitalAccessControl()},
    {'page': WalletView()}
  ];

  @override
  void initState() {
    getUserType();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  Future<void> getUserType() async {
    String? userType = await WalletSharedPreference.getUserType();
    if (userType == 'Patient') {
      _setEntityPage(_screensPatient);
    } else if (userType == 'Doctor') {
      _setEntityPage(_screensDoctor);
    } else if (userType == 'Hospital') {
      _setEntityPage(_screensHospital);
    } else if (userType == 'Pharmacy') {
      _setEntityPage(_screensPharmacy);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _setEntityPage(List<Map<String, Widget>> page) {
    setState(() {
      screen = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_pages[_selectPageIndex]['title'].toString()),
      // ),
      body: screen[_selectPageIndex]['page'],
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
        // unselectedItemColor: Colors.white,

        showElevation: true,
        itemCornerRadius: 24,
        selectedIndex: _selectPageIndex,
        onItemSelected: _selectPage,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: Theme.of(context).primaryColor,
              icon: Image.asset(
                "assets/icons/icons8-home-100.png",
                color: Theme.of(context).primaryColor,
                width: 32,
                height: 32,
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          BottomNavyBarItem(
              activeColor: Theme.of(context).primaryColor,
              icon: Image.asset("assets/icons/medicine.png",
                  color: Theme.of(context).primaryColor, width: 32, height: 32),
              title: Text(
                'Medicine',
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          BottomNavyBarItem(
              activeColor: Theme.of(context).primaryColor,
              icon: Image.asset("assets/icons/wallet.png",
                  color: Theme.of(context).primaryColor, width: 32, height: 32),
              title: Text(
                'Wallet',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ))
        ],
      ),
    );
  }
}
