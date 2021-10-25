// import 'dart:async';
import 'package:blockchain_healthcare_frontend/providers/auth.dart';
import 'package:blockchain_healthcare_frontend/providers/patient.dart';
import 'package:blockchain_healthcare_frontend/screens/Tabs/tabs_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/medical_records_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/prescription_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/sign_up_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/splash_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/wallet.dart';
import 'package:blockchain_healthcare_frontend/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PatientsModel(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: kPrimaryColor,
            primaryColor: kPrimaryColor,

          ),
          // home: WalletScreen(),
          routes: {
            '/': (ctx) =>  SignUpScreen(),
            PrescriptionScreen.routeName: (ctx) => PrescriptionScreen(),
            MedicalRecordScreen.routeName: (ctx) => MedicalRecordScreen(),
            WalletScreen.routeName: (ctx) => WalletScreen(),
          },
        ),
      ),
    );
  }
}
