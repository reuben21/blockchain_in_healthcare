import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/credentials.dart';
import 'package:bic_android_web_support/providers/crypto_api.dart';
import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/providers/provider_firebase/model_firebase.dart';
import 'package:bic_android_web_support/providers/provider_pharmacy/model_pharmacy.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_details.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:bic_android_web_support/screens/screens_auth/login_screen.dart';
import 'package:bic_android_web_support/screens/screens_auth/sign_up_screen.dart';
import 'package:bic_android_web_support/screens/screens_wallet/confirmation_screen.dart';
import 'package:bic_android_web_support/screens/screens_wallet/transaction_list.dart';
import 'package:bic_android_web_support/screens/screens_wallet/view_wallet.dart';
import 'package:bic_android_web_support/screens/splash_welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web3dart/credentials.dart';

import '../providers/ipfs.dart';
import '../providers/patient.dart';
import '../providers/wallet.dart';
import '../screens/Tabs/tabs_screen.dart';
import '../screens/medical_records_screen.dart';
import '../screens/prescription_screen.dart';
import 'screens/screens_wallet/transfer_screen.dart';
import 'screens/screen_unusefull/wallet.dart';
import 'screens/screen_unusefull/wallet_login.dart';
import '../theme.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore_for_file: prefer_const_constructors
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await WalletSharedPreference.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late Credentials credentials;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CryptoApiModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FirebaseModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CredentialsModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PharmacyModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GasEstimationModel(),
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
              primaryVariant: Color(0xa35e10b3),
            ),
            backgroundColor: Color(0xFFf5f7ec),
            bottomAppBarColor: Color(0xFFf5f7ec),
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                      color: Color(0xff732eca),
                      fontSize: 16,
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
            '/': (ctx) => SignUpScreen(),
            // '/': (ctx) => WalletView(),
            // '/': (ctx) => Ipfs_screen(),
            // DoctorDetails.routeName: (ctx) => DoctorDetails(),
            PatientDetails.routeName: (ctx) => PatientDetails(),
            PrescriptionScreen.routeName: (ctx) => PrescriptionScreen(),
            MedicalRecordScreen.routeName: (ctx) => MedicalRecordScreen(),
            WalletScreen.routeName: (ctx) => WalletScreen(),
            WalletView.routeName: (ctx) => WalletView(),
            WalletLogin.routeName: (ctx) => WalletLogin(),
            TransferScreen.routeName: (ctx) => TransferScreen(
                  address: '',
                ),
            TabsScreen.routeName: (ctx) => TabsScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            TransactionList.routeName: (ctx) => TransactionList(),
            ConfirmationScreen.routeName: (ctx) => ConfirmationScreen(
                  credentials: credentials,
                  receiverAddress: '',
                  amount: '',
                  senderAddress: '',
                ),
            SplashWelcomeScreen.routeName: (ctx) => SplashWelcomeScreen()
          },
        ),
      ),
    );
  }
}
