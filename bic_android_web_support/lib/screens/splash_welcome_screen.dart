import 'dart:convert';
import 'dart:typed_data';

import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class SplashWelcomeScreen extends StatefulWidget {
  static const routeName = '/splash-welcome-screen';

  @override
  _SplashWelcomeScreenState createState() {
    return _SplashWelcomeScreenState();
  }
}

class _SplashWelcomeScreenState extends State<SplashWelcomeScreen> {
  bool status = false;

  @override
  void initState() {
    callme();
    super.initState();
  }

  callme() async {
    await Future.delayed(Duration(seconds: 5));

      setState(() {
        status = true;
      });

  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      body: SingleChildScrollView(
        child: Background(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.08),
                SvgPicture.asset(
                  "assets/icons/signup.svg",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  'Please Wait !',
                  style: Theme.of(context).textTheme.headline1,
                ),
                status ? Text(
                  'As We Load Your Data',
                  style: Theme.of(context).textTheme.bodyText1,
                ) :Text(
                  'We are Loading your Data',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                status ? Container(
                  child:
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: FloatingActionButton.extended(
                      heroTag: "signUpButtonOnSignUpScreen",
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      onPressed:() async {
                        if (true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabsScreen(),
                            ),
                          );
                        }
                      },
                      icon: Image.asset("assets/icons/login-right-100.png",
                          color: Theme.of(context).colorScheme.secondary,
                          width: 25,
                          fit: BoxFit.fill,
                          height: 25),
                      label: const Text('Continue'),
                    ),
                  )
                 ,
                ) : Text(
                  'Give us a Second',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
