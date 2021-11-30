// import 'dart:async';
import 'package:blockchain_healthcare_frontend/providers/auth.dart';
import 'package:blockchain_healthcare_frontend/providers/patient.dart';
import 'package:blockchain_healthcare_frontend/providers/wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/Tabs/tabs_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/create_wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/medical_records_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/prescription_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/sign_up_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/splash_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/view_wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/wallet.dart';
import 'package:blockchain_healthcare_frontend/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        ChangeNotifierProvider(
          create: (ctx) => WalletModel(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blockchain in Flutter',
          theme: ThemeData(
            primaryColor: Color(0xff732eca),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color(0xff732eca),
              secondary: Color(0xFFf5f7ec),
            ),
            backgroundColor: Color(0xFFf5f7ec),
            bottomAppBarColor: Color(0xFFf5f7ec),
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                      color: Color(0xFFf5f7ec), fontSize: 18, fontFamily: 'Handlee'),
                  bodyText2: TextStyle(
                    color: Color(0xFFf5f7ec),
                    fontFamily: 'Handlee',
                  ),
                  headline6: TextStyle(
                    color: kSecondaryColor[100],
                    fontSize: 15,
                    fontFamily: 'PlayfairDisplay',
                  ),
                  headline5: TextStyle(
                    color: kSecondaryColor[100],
                    fontSize: 12,
                    fontFamily: 'PlayfairDisplay',
                  ),
                  headline4: GoogleFonts.lato(
                      color: Color(0xff732eca),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  headline3: GoogleFonts.lato(
                      color: Color(0xff732eca),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  headline2: GoogleFonts.lato(
                      color: Color(0xFFf5f7ec),
                      fontSize: 40,
                      fontWeight: FontWeight.w500),
                  headline1: GoogleFonts.lato(
                      color: Color(0xff732eca),
                      fontSize: 40,
                      fontWeight: FontWeight.w500),
                ),
          ),
          // home: WalletScreen(),
          routes: {
            '/': (ctx) => CreateWallet(),
            PrescriptionScreen.routeName: (ctx) => PrescriptionScreen(),
            MedicalRecordScreen.routeName: (ctx) => MedicalRecordScreen(),
            WalletScreen.routeName: (ctx) => WalletScreen(),
            WalletView.routeName: (ctx) => WalletView()
          },
        ),
      ),
    );
  }
}
