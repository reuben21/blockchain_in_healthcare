import 'dart:async';
import 'package:blockchain_healthcare_frontend/screens/signup.dart';
import 'package:blockchain_healthcare_frontend/theme.dart';
import 'package:blockchain_healthcare_frontend/widgets/forms/login_form.dart';
import 'package:blockchain_healthcare_frontend/widgets/forms/primary_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {


// ignore_for_file: prefer_const_constructors
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            Text(
              'Welcome Back',
              style: titleText,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'New to this app?',
                  style: subTitle,
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
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
            SizedBox(
              height: 10,
            ),
            LoginForm(),
            SizedBox(
              height: 20,
            ),
            Text(
              'Forgot Password?',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationThickness: 1,
              ),
            ),
            SizedBox(
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
