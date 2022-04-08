import 'dart:convert';
import 'dart:typed_data';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/provider_doctor/model_doctor.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_prescription_form.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/keys.dart' as keys;
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_details.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../Widgets/CustomButtonGen.dart';
import '../Widgets/CustomCard.dart';
import 'doctor_change_hospital.dart';
import 'doctor_patient_list.dart';
import 'doctor_patient_medical_view.dart';

class DoctorRecordScreen extends StatefulWidget {
  static const routeName = '/doctor-record-screen';

  @override
  _DoctorRecordScreenState createState() {
    return _DoctorRecordScreenState();
  }
}

class _DoctorRecordScreenState extends State<DoctorRecordScreen> {
  String? role;
  late String doctorName;
  late String doctorIpfsHashData;
  late Map<String, dynamic> doctorIpfsHash;
  String walletAdd = '';

  @override
  void initState() {
    role = '';
    doctorName = '';
    doctorIpfsHashData = '';
    doctorIpfsHash = {
      "doctor_name": "",
      "doctor_age": "",
      "doctor_address": "",
      "doctor_gender": "",
      "doctor_phone_no": "",
    };
    fetchDoctorData();
    getWalletFromDatabase();
    super.initState();
  }

  Future<void> getWalletFromDatabase() async {
    var dbResponse = await WalletSharedPreference.getWalletDetails();
    walletAdd = dbResponse!['walletAddress'].toString();
    setState(() {
      walletAdd;
    });
  }

  Future<void> fetchDoctorData() async {
    Credentials credentialsNew;
    EthereumAddress address;

    credentialsNew =
        Provider.of<WalletModel>(context, listen: false).walletCredentials;
    address = await credentialsNew.extractAddress();
    print(address);

    var data = await Provider.of<WalletModel>(context, listen: false)
        .readContract("getDoctorData", [address]);

    print(data);
    // print(data[0]);

    if (data[1].toString() != '') {
      var doctorProvider =
          await Provider.of<DoctorModel>(context, listen: false)
              .setDoctorData(data[4], data[2]);
      var doctorData = await Provider.of<IPFSModel>(context, listen: false)
          .receiveData(data[1]);
      print(doctorData);
      var dataRole = await Provider.of<WalletModel>(context, listen: false)
          .readContract("getRoleForDoctors", [address]);
      print("Role Status -" + dataRole.toString());

      setState(() {
        doctorName = data[0].toString();
        doctorIpfsHashData = data[1].toString();
        doctorIpfsHash = doctorData!;
        role = dataRole[0].toString() == "ACCESS GRANTED BY HOSPITAL" ? "ACCESS GRANTED":"DOCTOR";
      });
    } else {
      setState(() {
        doctorName = data[0];
      });
    }
    // if (dataRole[0]) {
    //   setState(() {
    //     role = "DOCTOR";
    //   });
    // } else {
    //   role = "UNVERIFIED";
    // }
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
    // var doctorProvider =
    //     Provider.of<DoctorModel>(context, listen: false).doctorHospitalAddress;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: const Text("Doctor Record"),
      // ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                doctorIpfsHash['doctor_name'] == ''
                        ? Container(
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
                              "assets/images/undraw_doctor.svg",
                              height: 220,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Hello Doctor !",
                                  style: GoogleFonts.montserrat(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              Text(
                                "Start By",
                                style: GoogleFonts.montserrat(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "Registering Yourself",
                                style: GoogleFonts.montserrat(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 25,
                                ),

                              ),
                              Text(
                                "On the Blockchain",
                                style: GoogleFonts.montserrat(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 25,
                                ),

                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30,right: 75),
                                child: FloatingActionButton.extended(
                                  heroTag: "registerOnBlockchain",
                                  backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                                  foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                                  onPressed: ()  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DoctorDetails(
                                          doctorName: doctorIpfsHash['doctor_name'],
                                          doctorAge: doctorIpfsHash['doctor_age'],
                                          doctorAddress: doctorIpfsHash['doctor_address'],
                                          doctorHospitalAddress:
                                          doctorIpfsHash['hospital_address'],
                                          doctorGender: doctorIpfsHash['doctor_gender'],
                                          doctorPhoneNo:
                                          doctorIpfsHash['doctor_phone_no'],
                                        ),
                                      ),
                                    );
                                  },
                                  // icon: Image.asset(
                                  //     "assets/icons/registration-100.png",
                                  //     color: Theme.of(context).colorScheme.secondary,
                                  //     width: 25,
                                  //     fit: BoxFit.fill,
                                  //     height: 25),
                                  label: Text('Register Now',style: GoogleFonts.montserrat(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 18,
                                  ) ,),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                    width: double.infinity,
                    height: 460,
                    child:Card(
                              // borderOnForeground: true,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(
                                //     color: Theme.of(context).colorScheme.primary,
                                //     width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          leading: Image.asset(
                                              "assets/icons/checked-user-male-100.png",
                                              color:
                                                  Theme.of(context).colorScheme.primary,
                                              width: 35,
                                              height: 35),
                                          title: Text('Role', style: textStyleForName),
                                          subtitle: Text(
                                            role.toString(),
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          leading: Image.asset(
                                              "assets/icons/icons8-medical-doctor-100.png",
                                              color:
                                              Theme.of(context).colorScheme.primary,
                                              width: 35,
                                              height: 35),
                                          title: Text('Doctor Name',
                                              style: textStyleForName),
                                          subtitle: Text(
                                            doctorIpfsHash['doctor_name'],
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          leading: Image.asset(
                                              "assets/icons/icons8-age-100.png",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 35,
                                              height: 35),
                                          title: Text('Date Of Birth',
                                              style: textStyleForName),
                                          subtitle: Text(
                                              DateTime.parse(doctorIpfsHash['doctor_age']).day.toString()+"/"+ DateTime.parse(doctorIpfsHash['doctor_age']).month.toString()+"/"+DateTime.parse(doctorIpfsHash['doctor_age']).year.toString(),
                                            style: GoogleFonts.montserrat(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          leading: Image.asset(
                                              "assets/icons/icons8-gender-100.png",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 35,
                                              height: 35),
                                          title: Text(
                                            'Gender',
                                            style: textStyleForName,
                                          ),
                                          subtitle: Text(
                                            doctorIpfsHash['doctor_gender'],
                                            style: GoogleFonts.montserrat(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    leading: Image.asset(
                                        "assets/icons/address-100.png",
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        width: 35,
                                        height: 35),
                                    title:
                                        Text('Address', style: textStyleForName),
                                    subtitle: Text(
                                      doctorIpfsHash['doctor_address'],
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Image.asset(
                                        "assets/icons/wallet.png",
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        width: 35,
                                        height: 35),
                                    title: Text('Hospital Address',
                                        style: textStyleForName),
                                    subtitle: Text(
                                      doctorIpfsHash['hospital_address']
                                              .toString()
                                              .substring(0, 4) +
                                          "...." +
                                          doctorIpfsHash['hospital_address']
                                              .toString()
                                              .lastChars(4),
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Image.asset(
                                        "assets/icons/phone-100.png",
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        width: 35,
                                        height: 35),
                                    title:
                                        Text('Phone No', style: textStyleForName),
                                    subtitle: Text(
                                      doctorIpfsHash['doctor_phone_no'],
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Image.asset(
                                        "assets/icons/storage-100.png",
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        width: 35,
                                        height: 35),
                                    title: Text('IPFS Hash',
                                        style: textStyleForName),
                                    subtitle: Text(
                                      doctorIpfsHashData,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 15,
                                      ),
                                    ),
                                    onTap: () {
                                      String _url =
                                          "${keys.getIpfsUrlForReceivingData}$doctorIpfsHashData";
                                      _launchURL(_url);
                                    },
                                  ),
                                ],
                              ),
                            ),
                  ),
                        ),

                // Divider(
                //
                //   height: 20,
                //   thickness: 2,
                //   indent: 15,
                //   endIndent: 15,
                //   color: Theme.of(context).colorScheme.primary,
                // ),
                doctorIpfsHash['doctor_name'] == ''
                    ?Container():
                Column(
                  children: [
                    CustomButtonGen(cardText:'Store or Update Doctor on Blockchain',onPressed:()=>{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetails(
                            doctorName: doctorIpfsHash['doctor_name'],
                            doctorAge: doctorIpfsHash['doctor_age'],
                            doctorAddress: doctorIpfsHash['doctor_address'],
                            doctorHospitalAddress:
                            doctorIpfsHash['hospital_address'],
                            doctorGender: doctorIpfsHash['doctor_gender'],
                            doctorPhoneNo:
                            doctorIpfsHash['doctor_phone_no'],
                          ),
                        ),
                      )
                    },imageAsset:Image.asset(
                      "assets/icons/icons8-medical-doctor-100.png",
                      color: Theme.of(context).primaryColor,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),),
                    CustomButtonGen(cardText:'Change Hospital on Blockchain',onPressed:()=>{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorChangeHospital(
                            oldHospitalAddress:
                            doctorIpfsHash['hospital_address'],
                            doctorWalletAddress: walletAdd,
                          ),
                        ),
                      )
                    },imageAsset:Image.asset(
                      "assets/icons/hospital.png",
                      color: Theme.of(context).primaryColor,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),),
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
