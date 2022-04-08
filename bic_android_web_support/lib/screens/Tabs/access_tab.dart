import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_prescription_form.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_screen.dart';
import 'package:bic_android_web_support/screens/screen_hospital/hospital_access_control.dart';
import 'package:bic_android_web_support/screens/screen_hospital/hospital_access_list_granted.dart';
import 'package:bic_android_web_support/screens/screen_hospital/hospital_access_list_pending.dart';
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

class AccessTabs extends StatefulWidget {
  static const routeName = '/tabs-screen';

  @override
  _AccessTabsState createState() {
    return _AccessTabsState();
  }
}

class _AccessTabsState extends State<AccessTabs> {
  List<Map<String, Widget>> screen = [
    {'page': HospitalAccessListPending()},
    {'page': HospitalAccessListGranted()},
  ];




  @override
  void initState() {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
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

        showElevation: false,
        itemCornerRadius: 24,
        selectedIndex: _selectPageIndex,
        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
        onItemSelected: _selectPage,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(

              activeColor: Theme.of(context).primaryColor,
              icon: Image.asset(
                "assets/icons/icons8-no-access-100.png",
                color: Theme.of(context).primaryColor,
                width: 32,
                height: 32,
              ),
              title: Text(
                'Pending',
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          BottomNavyBarItem(
              activeColor: Theme.of(context).primaryColor,
              icon: Image.asset("assets/icons/icons8-list-100.png",
                  color: Theme.of(context).primaryColor, width: 32, height: 32),
              title: Text(
                'Granted',
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),

        ],
      ),
    );
  }
}
