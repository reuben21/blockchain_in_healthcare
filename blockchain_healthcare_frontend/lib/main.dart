// import 'dart:async';
import 'dart:io';

import 'package:blockchain_healthcare_frontend/databases/moor_database.dart';
import 'package:blockchain_healthcare_frontend/providers/ipfs.dart';
import 'package:blockchain_healthcare_frontend/providers/patient.dart';
import 'package:blockchain_healthcare_frontend/providers/wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/Tabs/tabs_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/create_wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/medical_records_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/prescription_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/sign_up_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/splash_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/transfer_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/view_wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/wallet_login.dart';
import 'package:blockchain_healthcare_frontend/test_screens/ipfs_test.dart';
import 'package:blockchain_healthcare_frontend/theme.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  runApp(MyApp());
}

Future testWindowFunctions() async {
  Size size = await DesktopWindow.getWindowSize();
  print(size);
  await DesktopWindow.setWindowSize(Size(1000,900));

  await DesktopWindow.setMinWindowSize(Size(400,400));
  await DesktopWindow.setMaxWindowSize(Size(800,800));

  await DesktopWindow.resetMaxWindowSize();
  await DesktopWindow.toggleFullScreen();
  bool isFullScreen = await DesktopWindow.getFullScreen();
  await DesktopWindow.setFullScreen(true);
  await DesktopWindow.setFullScreen(false);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      testWindowFunctions();
    }

    return MultiProvider(
      providers: [
        Provider<MyDatabase>(
          create: (_) => MyDatabase(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PatientsModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => WalletModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => IPFSModel(),
        ),
      ],
      child: Consumer<WalletModel>(
        builder: (ctx, auth, _) => MaterialApp(
          supportedLocales: const [
            Locale('en'),
            Locale('it'),
            Locale('fr'),
            Locale('es'),
          ],
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,

          ],
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
                      color: Color(0xff732eca),
                      fontSize: 18,
                      fontFamily: 'Handlee'),
                  bodyText2: TextStyle(
                    color: Color(0xFFf5f7ec),
                    fontFamily: 'Handlee',
                  ),

                  headline6: TextStyle(
                    color: kSecondaryColor[100],
                    fontSize: 15,
                    fontFamily: 'PlayfairDisplay',
                  ),
                  headline5: GoogleFonts.lato(
                    color: Color(0xFFf5f7ec),
                    fontSize: 18,
                    backgroundColor: Color(0xff732eca),
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
            // '/': (ctx) => Ipfs_screen(),
            // '/': (ctx) => CreateWallet(),
            '/': (ctx) => CreateWallet(),
            // '/': (ctx) => Ipfs_screen(),
            PrescriptionScreen.routeName: (ctx) => PrescriptionScreen(),
            MedicalRecordScreen.routeName: (ctx) => MedicalRecordScreen(),
            WalletScreen.routeName: (ctx) => WalletScreen(),
            WalletView.routeName: (ctx) => WalletView(),
            WalletLogin.routeName: (ctx) => WalletLogin(),
            TransferScreen.routeName: (ctx) => TransferScreen(address: '',),
          },
        ),
      ),
    );
  }
}

