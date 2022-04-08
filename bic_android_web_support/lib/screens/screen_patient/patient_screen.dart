import 'package:bic_android_web_support/screens/screen_patient/patient_change_doctor.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_change_hospital.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/keys.dart' as keys;
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../Widgets/CustomButtonGen.dart';
import '../Widgets/CustomCard.dart';
import '../screen_doctor/doctor_read_screen.dart';
import '../screen_hospital/hospital_read_screen.dart';

class PatientRecordScreen extends StatefulWidget {
  static const routeName = '/patient-record-screen';

  @override
  _PatientRecordScreenState createState() {
    return _PatientRecordScreenState();
  }
}

class _PatientRecordScreenState extends State<PatientRecordScreen> {
  String? role;
  late String patientName;
  late String patientIpfsHashData;
  late Map<String, dynamic> patientIpfsHash;
  final ScrollController _controller = ScrollController();
  late Credentials credentialsNew;
  late EthereumAddress address;
  late var dataGlobal= [];

  @override
  void initState() {
    role = '';
    patientName = '';
    patientIpfsHashData = '';
    patientIpfsHash = {
      "patient_name": "",
      "patient_hospital_hash": "",
      "patient_address": "",
      "patient_age": "",
      "patient_phone_no": "",
    };
    fetchPatientData();
    super.initState();
  }

  Future<void> fetchPatientData() async {


    credentialsNew =
        Provider.of<WalletModel>(context, listen: false).walletCredentials;
    address = await credentialsNew.extractAddress();

    var dataRole = await Provider.of<WalletModel>(context, listen: false)
        .readContract("getRoleForUser", [address]);
    print("Role Status -" + dataRole.toString());

    // print("Role Status -" + dataRole.toString());

    var data = await Provider.of<WalletModel>(context, listen: false)
        .readContract("retrievePatientData", [address]);
    print(data);
    // print(data[0]);
    if (data[0].toString() != '') {
      var PatientData = await Provider.of<IPFSModel>(context, listen: false)
          .receiveData(data[1]);
      print(PatientData);
      setState(() {
        dataGlobal = data;
        patientName = data[0].toString();
        patientIpfsHashData = data[1].toString();
        patientIpfsHash = PatientData!;
      });
    } else {
      setState(() {
        patientName = data[0];
      });
    }

    if (dataRole[0] != '') {
      if(dataRole[0] == 'PATIENT') {
        setState(() {
          role = dataRole[0].toString();
        });
      } else if(dataRole[0] == 'VERIFIED_PATIENT') {
        setState(() {
          role = "VERIFIED";
        });
      }

    } else {
      role = "UNVERIFIED";
    }
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

    var textStyleGoogleFont = GoogleFonts.montserrat(
      color: Colors.black.withOpacity(0.6),
      fontSize: 18,
    );
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: const Text("Patient Record"),
      // ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              patientIpfsHash['patient_name'] == ''
                  ? Container(
                      height: 800,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primaryVariant,
                        ],
                      )),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: SvgPicture.asset(
                              "assets/images/undraw_personal_info.svg",
                              height: 220,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Start By",
                                style: GoogleFonts.montserrat(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "Registering Yourself",
                                style: GoogleFonts.montserrat(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "On the Blockchain",
                                style: GoogleFonts.montserrat(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, right: 75),
                                child: FloatingActionButton.extended(
                                  heroTag: "registerOnBlockchain",
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PatientStoreDetails(
                                          patientName:
                                              patientIpfsHash['patient_name'],
                                          patientHospitalAddress:
                                              patientIpfsHash[
                                                  'patient_hospital_address'],
                                          patientDoctorAddress: patientIpfsHash[
                                              'patient_doctor_address'],
                                          patientAddress: patientIpfsHash[
                                              'patient_address'],
                                          patientAge:
                                              patientIpfsHash['patient_age'],
                                          patientPhoneNo: patientIpfsHash[
                                              'patient_phone_no'],
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
                                  label: Text(
                                    'Register Now',
                                    style: GoogleFonts.montserrat(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 525,
                      child: Card(
                        borderOnForeground: true,
                        clipBehavior: Clip.antiAlias,
                        // shape: RoundedRectangleBorder(
                        //   side: BorderSide(
                        //       color: Theme.of(context).colorScheme.primary,
                        //       width: 2),
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        child: SingleChildScrollView(
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
                                            "assets/icons/pharmacy-shop-100.png",
                                            color:
                                            Theme.of(context).colorScheme.primary,
                                            width: 35,
                                            height: 35),
                                        title: Text('Patient Name',
                                            style: textStyleForName),
                                        subtitle: Text(
                                          patientName,
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
                                            "assets/icons/year-view-100.png",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 35,
                                            height: 35),
                                        title: Text(
                                          'Date Of Birth',
                                          style: textStyleForName,
                                        ),
                                        subtitle: Text(
                                          DateTime.parse(patientIpfsHash[
                                          'patient_dateOfBirth']
                                              .toString())
                                              .day
                                              .toString() +
                                              "-" +
                                              DateTime.parse(patientIpfsHash[
                                              'patient_dateOfBirth']
                                                  .toString())
                                                  .month
                                                  .toString() +
                                              "-" +
                                              DateTime.parse(patientIpfsHash[
                                              'patient_dateOfBirth']
                                                  .toString())
                                                  .year
                                                  .toString(),
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
                                          patientIpfsHash['patient_gender']
                                              .toString(),
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
                                      "assets/icons/icons8-hospital-3-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 35,
                                      height: 35),
                                  title: Text('Hospital Address',
                                      style: textStyleForName),
                                  subtitle: Text(
                                    dataGlobal[2].toString()
                                            .substring(0, 5) +
                                        "...." +
                                        dataGlobal[2].toString()
                                            .subStringLastChars(4),
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
                                  title: Text('Doctor Address',
                                      style: textStyleForName),
                                  subtitle: Text(
                                    dataGlobal[3].toString()
                                            .substring(0, 5) +
                                        "...." +
                                        dataGlobal[3].toString()
                                            .subStringLastChars(4),
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 15,
                                    ),
                                  ),
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
                                    patientIpfsHash['patient_address'],
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
                                    patientIpfsHash['patient_phone_no'],
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
                                    patientIpfsHashData,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 15,
                                    ),
                                  ),
                                  onTap: () {
                                    String _url =
                                        "${keys.getIpfsUrlForReceivingData}$patientIpfsHashData";
                                    _launchURL(_url);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

              SizedBox(
                height: 10,
              ),
              patientIpfsHash['patient_name'] == ''
                  ? Container()
                  : Column(
                      children: [
                        CustomButtonGen(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientStoreDetails(
                                  patientName: patientIpfsHash['patient_name'],
                                  patientHospitalAddress: patientIpfsHash[
                                      'patient_hospital_address'],
                                  patientDoctorAddress:
                                      patientIpfsHash['patient_doctor_address'],
                                  patientAddress:
                                      patientIpfsHash['patient_address'],
                                  patientAge: patientIpfsHash['patient_age'],
                                  patientPhoneNo:
                                      patientIpfsHash['patient_phone_no'],
                                ),
                              ),
                            )
                          },
                          imageAsset: Image.asset(
                              "assets/icons/icons8-user-shield-100.png",
                              color: Theme.of(context).primaryColor,
                              width: 20,
                              height: 20),
                          cardText: 'Store or Update Patient on Blockchain',
                        ),

                        CustomButtonGen(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientChangeDoctor(oldHospitalAddress: dataGlobal[3].toString() ),
                              ),
                            )
                          },
                          imageAsset: Image.asset(
                              "assets/icons/icons8-medical-doctor-100.png",
                              color: Theme.of(context).primaryColor,
                              width: 20,
                              height: 20),
                          cardText: 'Change Doctor',
                        ),

                        CustomButtonGen(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientChangeHospital(oldHospitalAddress: dataGlobal[2].toString()),
                              ),
                            )
                          },
                          imageAsset: Image.asset(
                              "assets/icons/icons8-hospital-3-100.png",
                              color: Theme.of(context).primaryColor,
                              width: 20,
                              height: 20),
                          cardText: 'Change Hospital',
                        ),

                      ],
                    ),


            ],
          ),
        ),
      ),
    );
  }
}

extension E on String {
  String subStringLastChars(int n) => substring(length - n);
}
