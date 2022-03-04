import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:bic_android_web_support/screens/screens_auth/login_screen.dart';
import 'package:bic_android_web_support/screens/screens_auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome...\n'
              'to\n'
              'Health-Chain',
              style: Theme.of(context).textTheme.headline1,
            ),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: 300,
            ),
            const SizedBox(
              height: 25,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              //Center Row contents vertically,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: "signUpButtonOnSignUpScreen",
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  icon: Image.asset("assets/icons/registration-100.png",
                      color: Theme.of(context).colorScheme.secondary,
                      width: 25,
                      fit: BoxFit.fill,
                      height: 25),
                  label: const Text('Register'),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'OR',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 25,
                ),
                FloatingActionButton.extended(
                  heroTag: "logInButtonOnSignUpScreen",
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  icon: Image.asset("assets/icons/sign_in.png",
                      color: Theme.of(context).colorScheme.secondary,
                      width: 25,
                      fit: BoxFit.fill,
                      height: 25),
                  label: const Text('Log In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
