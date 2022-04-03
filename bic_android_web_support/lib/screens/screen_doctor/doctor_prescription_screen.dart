import 'dart:convert';
import 'dart:typed_data';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../../providers/provider_doctor/model_doctor.dart';
import '../Widgets/CustomButtonGen.dart';
import '../screen_patient/patient_prescription_view.dart';
import 'doctor_patient_list.dart';
import 'doctor_patient_medical_view.dart';
import 'doctor_prescription_form.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  static const routeName = '/doctor-record-screen';

  @override
  _DoctorPrescriptionScreenState createState() {
    return _DoctorPrescriptionScreenState();
  }
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
  String walletAdd = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> getWalletFromDatabase() async {
    var dbResponse = await WalletSharedPreference.getWalletDetails();

    walletAdd = dbResponse!['walletAddress'].toString();

    setState(() {
      walletAdd;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    var textStyleForName = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary);
    var doctorProvider =
        Provider.of<DoctorModel>(context, listen: false).doctorHospitalAddress;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: const Text("Medical"),
      // ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: doctorProvider == null ? Container(
            height: 800,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryVariant,
                    Theme.of(context).colorScheme.primary,

                  ],
                )),
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 80),
                  child: SvgPicture.asset(
                    "assets/images/undraw_doctors.svg",
                    height: 220,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Register",
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 25,
                      ),

                    ),
                    Text(
                      "Yourself",
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 25,
                      ),


                    ),
                    Text(
                      "From the Home Tab",
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 25,
                      ),


                    ),
                  ],
                ),

              ],
            ),
          ):Container(
            child: Column(
              children: [
                CustomButtonGen(cardText:"View Medical Record For Patient",onPressed:()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DoctorPatientMedicalRecordView(),
                    ),
                  )
                },imageAsset:Image.asset(
                  "assets/icons/icons8-medical-history-100.png",
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),),
                CustomButtonGen(cardText:'Prescribe Medicine',onPressed:()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorPrescriptionForm(),
                    ),
                  )
                },imageAsset:Image.asset(
                  "assets/icons/icons8-hand-with-a-pill-100.png",
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),),
                CustomButtonGen(cardText:'View Patient List',onPressed:()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorPatientList(),
                    ),
                  )
                },imageAsset:Image.asset(
                  "assets/icons/icons8-list-100.png",
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),),
                CustomButtonGen(cardText:'View Prescriptions',onPressed:()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientPrescriptionViewGen(),
                    ),
                  )
                },imageAsset:Image.asset(
                  "assets/icons/icons8-file-prescription-100.png",
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),),

              ],
            ),
          ),
        ),
      ),

    );
  }
}
