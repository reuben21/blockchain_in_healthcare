import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

const MaterialColor kPrimaryColor = MaterialColor(
  0xFF0E7AC7,
  <int, Color>{
    50: const Color(0xFF16c2d5),
    100: const Color(0xFF16c2d5),
    200: const Color(0xFF16c2d5),
    300: const Color(0xFF16c2d5),
    400: const Color(0xFF16c2d5),
    500: const Color(0xFF16c2d5),
    600: const Color(0xFF16c2d5),
    700: const Color(0xFF16c2d5),
    800: const Color(0xFF16c2d5),
    900: const Color(0xFF16c2d5),
  },
);

const kPrimaryColorAccent = Color(0xFF89dee2);

const kSecondaryColor = Color(0xFF527c88);
const kSecondaryColorAccent = Color(0xFF2e4450);

const justBlue = Color(0xFF10217d);

const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF272726);
const kTextFieldColor = Color(0xFF979797);



const kDefaultPadding = EdgeInsets.symmetric(horizontal: 30);

TextStyle titleText =
TextStyle(color: kPrimaryColor, fontSize: 32, fontWeight: FontWeight.w700);
TextStyle subTitle = TextStyle(
    color: kSecondaryColor, fontSize: 18, fontWeight: FontWeight.w500);
TextStyle textButton = TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);