import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_medical_record.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_medical_record_creation.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_medical_record_view.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../helpers/keys.dart' as keys;
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/screen_pharmacy/pharmacy_store_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../Widgets/CustomCard.dart';

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
    Credentials credentialsNew;
    EthereumAddress address;

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
      setState(() {
        role = dataRole[0].toString();
      });
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Patient Record"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 2,
                  left: 8,
                  right: 8,
                ),
                child: Container(
                  width: double.infinity,
                  height: 500,
                  child: patientIpfsHash['patient_name'] == ''
                      ? Card(
                          borderOnForeground: true,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
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
                          borderOnForeground: true,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Image.asset(
                                      "assets/icons/checked-user-male-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 35,
                                      height: 35),
                                  title: Text('Role', style: textStyleForName),
                                  subtitle: Text(
                                    role.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                ListTile(
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
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),

                                ListTile(
                                  leading: Image.asset(
                                      "assets/icons/name-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 35,
                                      height: 35),
                                  title: Text('Hospital Address',
                                      style: textStyleForName),
                                  subtitle: Text(
                                    patientIpfsHash['patient_hospital_address'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                ListTile(
                                  leading: Image.asset(
                                      "assets/icons/name-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 35,
                                      height: 35),
                                  title: Text('Doctor Address',
                                      style: textStyleForName),
                                  subtitle: Text(
                                    patientIpfsHash['patient_doctor_address'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.6)),
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
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                ListTile(
                                  leading: Image.asset(
                                      "assets/icons/year-view-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 35,
                                      height: 35),
                                  title: Text(
                                    'Age',
                                    style: textStyleForName,
                                  ),
                                  subtitle: Text(
                                    patientIpfsHash['patient_age'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.6)),
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
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.6)),
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
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  onTap: () {
                                    String _url =
                                        "${keys.getIpfsUrlForReceivingData}$patientIpfsHashData";
                                    _launchURL(_url);
                                  },
                                ),
                                // ListTile(
                                //
                                //   trailing: Image.asset("assets/icons/forward-100.png",
                                //       color: Theme.of(context).primaryColor,
                                //       width: 25,
                                //       height: 25),
                                //   title: Text('Store your Pharmacy on Blockchain',
                                //       style: Theme.of(context).textTheme.bodyText1),
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => PharmacyStoreDetails(),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              CarouselSlider(
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
                          builder: (context) => PatientStoreDetails(
                            patientName: patientIpfsHash['patient_name'],
                            patientHospitalAddress:
                                patientIpfsHash['patient_hospital_address'],
                            patientDoctorAddress:
                                patientIpfsHash['patient_doctor_address'],
                            patientAddress: patientIpfsHash['patient_address'],
                            patientAge: patientIpfsHash['patient_age'],
                            patientPhoneNo: patientIpfsHash['patient_phone_no'],
                          ),
                        ),
                      )
                    },
                    imageAsset: Image.asset("assets/icons/icons8-user-shield-100.png",
                        color: Theme.of(context).primaryColor,
                        width: 20,
                        height: 20) ,
                    cardText: 'Store or Update Patient on Blockchain',
                  ),
                  CustomCard(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientMedicalRecordView(),
                        ),
                      )
                    },
                    imageAsset:
                    Image.asset("assets/icons/icons8-medical-history-100.png",
                        color: Theme.of(context).primaryColor,
                        width: 20,
                        height: 20) ,
                    cardText: 'View Medical Records',
                  ),
                  CustomCard(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientMedicalRecords(),
                        ),
                      )
                    },
                    imageAsset:
                    Image.asset("assets/icons/icons8-treatment-100.png",
                        color: Theme.of(context).primaryColor,
                        width: 20,
                        height: 20),
                    cardText: 'Store Medical Records',
                  ),
                ].toList(),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              //   child: Card(
              //     borderOnForeground: true,
              //     clipBehavior: Clip.antiAlias,
              //     shape: RoundedRectangleBorder(
              //       side: BorderSide(
              //           color: Theme.of(context).colorScheme.primary, width: 2),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: <Widget>[
              //         ListTile(
              //           trailing: Image.asset("assets/icons/forward-100.png",
              //               color: Theme.of(context).primaryColor,
              //               width: 25,
              //               height: 25),
              //           title: Text('Store Medical Records',
              //               style: Theme.of(context).textTheme.bodyText1),
              //           onTap: () {},
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding:
              //       const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              //   child: Card(
              //     borderOnForeground: true,
              //     clipBehavior: Clip.antiAlias,
              //     shape: RoundedRectangleBorder(
              //       side: BorderSide(
              //           color: Theme.of(context).colorScheme.primary, width: 2),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: <Widget>[
              //         ListTile(
              //           trailing: Image.asset("assets/icons/forward-100.png",
              //               color: Theme.of(context).primaryColor,
              //               width: 25,
              //               height: 25),
              //           title: Text('Create Medical Record',
              //               style: Theme.of(context).textTheme.bodyText1),
              //           onTap: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) =>
              //                     PatientMedicalRecordCreation(),
              //               ),
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
