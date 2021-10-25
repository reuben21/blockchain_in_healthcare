import 'dart:async';
import 'package:blockchain_healthcare_frontend/theme.dart';
import 'package:blockchain_healthcare_frontend/widgets/forms/login_form.dart';
import 'package:blockchain_healthcare_frontend/widgets/forms/primary_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            Text(
              'Welcome Back',
              style: titleText,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'New to this app?',
                  style: subTitle,
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => null,
                      ),
                    );
                  },
                  child: Text(
                    'Sign up',
                    style: textButton.copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            LoginForm(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationThickness: 1,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              buttonText: 'Log In',
            ),
          ],
        ),
      ),
    );
  }
}
