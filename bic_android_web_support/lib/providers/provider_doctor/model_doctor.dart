
import 'package:flutter/cupertino.dart';
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
