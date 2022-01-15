import 'dart:convert';
import 'dart:typed_data';
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
    super.initState();
  }

  Future<void> fetchDoctorData() async {
    Credentials credentialsNew;
    EthereumAddress address;

    credentialsNew =
        Provider.of<WalletModel>(context, listen: false).walletCredentials;
    address = await credentialsNew.extractAddress();
    print(address);
    var dataRole = await Provider.of<WalletModel>(context, listen: false)
        .readContract("hasRole", [
      hexToBytes(
          "0x504841524d414359000000000000000000000000000000000000000000000000"),
      address
    ]);
    print("Role Status -" + dataRole.toString());

    var data = await Provider.of<WalletModel>(context, listen: false)
        .readContract("getDoctorData", [address]);
    // print(data);
    // print(data[0]);
    if (data[0].toString() != '') {
      var doctorData = await Provider.of<IPFSModel>(context, listen: false)
          .receiveData(data[1]);
      print(doctorData);
      setState(() {
        doctorName = data[0].toString();
        doctorIpfsHashData = data[1].toString();
        doctorIpfsHash = doctorData!;
      });
    } else {
      setState(() {
        doctorName = data[0];
      });
    }
    if (dataRole[0]) {
      setState(() {
        role = "DOCTOR";
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Doctor Record"),
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
                          leading: Image.asset(
                              "assets/icons/checked-user-male-100.png",
                              color: Theme.of(context).colorScheme.primary,
                              width: 35,
                              height: 35),
                          title: Text('Role', style: textStyleForName),
                          // subtitle: Text(
                          //   role.toString(),
                          //   style: TextStyle(
                          //       fontSize: 20,
                          //       color: Colors.black.withOpacity(0.6)),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: double.infinity,
                    height: 500,
                    child: doctorIpfsHash['doctor_name'] == ''
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Image.asset(
                                      "assets/icons/pharmacy-shop-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 35,
                                      height: 35),
                                  title: Text('Doctor Name',
                                      style: textStyleForName),
                                  subtitle: Text(
                                    doctorName,
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
                                  title: Text('Owner', style: textStyleForName),
                                  subtitle: Text(
                                    doctorIpfsHash['doctor_age'],
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
                                    doctorIpfsHash['doctor_address'],
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
                                    'Year Started',
                                    style: textStyleForName,
                                  ),
                                  subtitle: Text(
                                    doctorIpfsHash['doctor_gender'],
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
                                    doctorIpfsHash['doctor_phone_no'],
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
                                    doctorIpfsHashData,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  onTap: () {
                                    String _url =
                                        "${keys.getIpfsUrlForReceivingData}$doctorIpfsHashData";
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
                          title: Text('Store or Update Doctor on Blockchain',
                              style: Theme.of(context).textTheme.bodyText1),
                          onTap: () {
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
        // child: Container(
        //   child: FloatingActionButton.extended(
        //     heroTag: "PatientDetails",
        //     backgroundColor: Theme.of(context).colorScheme.primary,
        //     foregroundColor: Theme.of(context).colorScheme.secondary,
        //     onPressed: () async {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => DoctorDetails(),
        //         ),
        //       );
        //     },
        //     icon: Image.asset("assets/icons/sign_in.png",
        //         color: Theme.of(context).colorScheme.secondary,
        //         width: 25,
        //         fit: BoxFit.fill,
        //         height: 25),
        //     label: const Text('Log In'),
        //   ),
        // ),
      ),
    );
  }
}
