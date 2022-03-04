import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../../helpers/keys.dart' as keys;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import '../../helpers/http_exception.dart' as exception;
import 'package:web3dart/web3dart.dart';

class DoctorModel with ChangeNotifier {

  late EthereumAddress _doctorHospitalAddress;
  late EthereumAddress _doctorAddress;


  EthereumAddress get doctorHospitalAddress {
    return _doctorHospitalAddress;
  }

  EthereumAddress get doctorAddress {
    return _doctorAddress;
  }

  Future<void> setDoctorData( EthereumAddress    doctorHospitalAddress,EthereumAddress doctorAddress) async {
    _doctorHospitalAddress = doctorHospitalAddress;
    _doctorAddress = doctorAddress;

  }



}
