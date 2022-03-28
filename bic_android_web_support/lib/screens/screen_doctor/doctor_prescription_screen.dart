import 'dart:convert';
import 'dart:typed_data';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../../providers/provider_doctor/model_doctor.dart';
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
    var doctorProvider = Provider.of<DoctorModel>(context, listen: false)
        .doctorHospitalAddress;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Medical"),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    borderOnForeground: true,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          trailing: Image.asset("assets/icons/forward-100.png",
                              color: Theme.of(context).primaryColor,
                              width: 25,
                              height: 25),
                          title: Text('View Medical Record For Patient',
                              style: Theme.of(context).textTheme.bodyText1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorPatientMedicalRecordView(hospitalAddress:doctorProvider.hex),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    borderOnForeground: true,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          trailing: Image.asset("assets/icons/forward-100.png",
                              color: Theme.of(context).primaryColor,
                              width: 25,
                              height: 25),
                          title: Text('View Patient List',
                              style: Theme.of(context).textTheme.bodyText1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorPatientList(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                      ],
                    ),
                  ),
                ),

            ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorPrescriptionForm(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
