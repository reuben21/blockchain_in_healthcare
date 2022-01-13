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
    // TODO: implement build
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
                  'Welcome Back !',
                  style: Theme.of(context).textTheme.headline1,
                ),
                status ? Text(
                  'Your Data has been loaded',
                  style: Theme.of(context).textTheme.bodyText1,
                ) :Text(
                  'We are Loading your Data',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                status ? Container(
                  child: ElevatedButton.icon(
                    icon: Image.asset("assets/icons/login-right-100.png",
                        color: Theme.of(context).colorScheme.secondary,
                        scale: 1,
                        width: 25,
                        height: 25),

                    // padding: EdgeInsets.symmetric(
                    //     vertical: 20, horizontal: 40),
                    // color: Theme.of(context).colorScheme.primary,
                    onPressed: () async {
                      if (true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TabsScreen(),
                          ),
                        );
                      }
                    },
                    label:
                        const Text("Continue", style: TextStyle(color: Colors.white)),
                  ),
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
