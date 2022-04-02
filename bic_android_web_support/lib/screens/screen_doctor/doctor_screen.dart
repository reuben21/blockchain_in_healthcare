import 'dart:convert';
import 'dart:typed_data';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/provider_doctor/model_doctor.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
      var doctorProvider = await Provider.of<DoctorModel>(context, listen: false)
          .setDoctorData(data[4],data[2]);
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
        role = dataRole[0].toString();
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
    var doctorProvider = Provider.of<DoctorModel>(context, listen: false)
        .doctorHospitalAddress;

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

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: double.infinity,
                    height: 520,
                    child: doctorIpfsHash['doctor_name'] == ''
                        ? Card(
                            // borderOnForeground: true,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              // side: BorderSide(
                              //     color: Theme.of(context).colorScheme.primary,
                              //     width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const ListTile(
                              leading: Icon(Icons.arrow_drop_down_circle),
                              title: Text(
                                "Not Registered on Blockchain",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          )
                        : Card(
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
                                ListTile(
                                  leading: Image.asset(
                                      "assets/icons/checked-user-male-100.png",
                                      color: Theme.of(context).colorScheme.primary,
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
                                ListTile(
                                  leading: Image.asset(
                                      "assets/icons/icons8-medical-doctor-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 35,
                                      height: 35),
                                  title: Text('Doctor Name',
                                      style: textStyleForName),
                                  subtitle: Text(
                                    doctorIpfsHash['doctor_name'] ,
                                    style: GoogleFonts.montserrat(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 15,
                  ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: Image.asset(
                                            "assets/icons/icons8-age-100.png",
                                            color:
                                                Theme.of(context).colorScheme.primary,
                                            width: 35,
                                            height: 35),
                                        title: Text('Age', style: textStyleForName),
                                        subtitle: Text(
                                          doctorIpfsHash['doctor_age'],
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
                                            "assets/icons/icons8-gender-100.png",
                                            color:
                                            Theme.of(context).colorScheme.primary,
                                            width: 35,
                                            height: 35),
                                        title: Text(
                                          'Gender',
                                          style: textStyleForName,
                                        ),
                                        subtitle: Text(
                                          doctorIpfsHash['doctor_gender'],
                                          style: GoogleFonts.montserrat(
                    color: Colors.black.withOpacity(0.6),
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
                                  title:
                                  Text('Hospital Address', style: textStyleForName),
                                  subtitle: Text(
                                    doctorIpfsHash['hospital_address'].toString().substring(0,4)+"...."+doctorIpfsHash['hospital_address'].toString().lastChars(4),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 180.0,

                      aspectRatio: 16 / 9,
                      viewportFraction: 0.5,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: [
                      CustomCard(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDetails(
                                doctorName: doctorIpfsHash['doctor_name'],
                                doctorAge: doctorIpfsHash['doctor_age'],
                                doctorAddress:
                                doctorIpfsHash['doctor_address'],
                                doctorGender: doctorIpfsHash['doctor_gender'],
                                doctorPhoneNo:
                                doctorIpfsHash['doctor_phone_no'],
                              ),
                            ),
                          )
                        },
                        imageAsset: Image.asset("assets/icons/icons8-medical-doctor-100.png",
                            color: Theme.of(context).primaryColor,
                            width: 20,
                            height: 20),
                        cardText: 'Store or Update Doctor on Blockchain',
                      ),
                      CustomCard(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorChangeHospital(
                                oldHospitalAddress: doctorIpfsHash['hospital_address'], doctorWalletAddress:walletAdd ,
                              ),
                            ),
                          )
                        },
                        imageAsset:
                        Image.asset("assets/icons/hospital.png",
                            color: Theme.of(context).primaryColor,
                            width: 20,
                            height: 20,fit: BoxFit.contain,alignment: Alignment.center,),
                        cardText: 'Change Hospital on Blockchain',
                      ),
                      CustomCard(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorPatientMedicalRecordView(hospitalAddress:doctorProvider.hex),
                            ),
                          )
                        },
                        imageAsset:
                        Image.asset("assets/icons/icons8-medical-history-100.png",
                          color: Theme.of(context).primaryColor,
                          width: 20,
                          height: 20,fit: BoxFit.contain,alignment: Alignment.center,),
                        cardText: 'View Medical Records for Patients',
                      ),
                      CustomCard(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorPatientMedicalRecordView(
                                  hospitalAddress: doctorProvider.hex),
                            ),
                          )
                        },
                        imageAsset:
                        Image.asset("assets/icons/icons8-hand-with-a-pill-100.png",
                          color: Theme.of(context).primaryColor,
                          width: 20,
                          height: 20,fit: BoxFit.contain,alignment: Alignment.center,),
                        cardText: 'Prescribe Medicine',
                      ),
                      CustomCard(
                        onPressed: () => {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => DoctorPatientMedicalRecordView(
                                      hospitalAddress: doctorProvider.hex),
                            ),
                          )
                        },
                        imageAsset:
                        Image.asset("assets/icons/icons8-list-100.png",
                          color: Theme.of(context).primaryColor,
                          width: 20,
                          height: 20,fit: BoxFit.contain,alignment: Alignment.center,),
                        cardText: 'View Patient List',
                      ),
                    ].toList(),
                  ),
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