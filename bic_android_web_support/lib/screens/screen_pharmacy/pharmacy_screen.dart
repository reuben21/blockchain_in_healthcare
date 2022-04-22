import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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

import '../Widgets/CustomButtonGen.dart';
import '../Widgets/CustomCard.dart';
import '../screen_doctor/doctor_patient_medical_view.dart';
import '../screen_patient/patient_prescription_view.dart';
import '../screen_patient/prescription_screen.dart';

class PharmacyRecordScreen extends StatefulWidget {
  static const routeName = '/pharmacy-record-screen';

  @override
  _PharmacyRecordScreenState createState() {
    return _PharmacyRecordScreenState();
  }
}

class _PharmacyRecordScreenState extends State<PharmacyRecordScreen> {
  String? role;
  late String pharmacyName;
  late String pharmacyIpfsHashData;
  late Map<String, dynamic> pharmacyIpfsHash;

  @override
  void initState() {
    role = '';
    pharmacyName = '';
    pharmacyIpfsHashData = '';
    pharmacyIpfsHash = {
      "pharmacy_name": "",
      "pharmacy_owner_name": "",
      "pharmacy_address": "",
      "pharmacy_year_origin": "",
      "pharmacy_phone_no": "",
    };
    fetchPharmacyData();
    super.initState();
  }

  Future<void> fetchPharmacyData() async {
    Credentials credentialsNew;
    EthereumAddress address;

    credentialsNew =
        Provider.of<WalletModel>(context, listen: false).walletCredentials;
    address = await credentialsNew.extractAddress();

    var dataRole = await Provider.of<WalletModel>(context, listen: false)
        .readContract("getRoleForUser", [address]);
    print("Role Status -" + dataRole.toString());

    var data = await Provider.of<WalletModel>(context, listen: false)
        .readContract("getPharmacyData", [address]);
    // print(data);
    // print(data[0]);
    if (data[0].toString() != '') {
      var pharmacyData = await Provider.of<IPFSModel>(context, listen: false)
          .receiveData(data[1]);
      print(pharmacyData);
      setState(() {
        pharmacyName = data[0].toString();
        pharmacyIpfsHashData = data[1].toString();
        pharmacyIpfsHash = pharmacyData!;
      });
    } else {
      setState(() {
        pharmacyName = data[0];
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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: const Text("Pharmacy Record"),
      // ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              pharmacyIpfsHash['pharmacy_owner_name'] == ''
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
                          padding:
                          const EdgeInsets.symmetric(vertical: 80),
                          child: SvgPicture.asset(
                            "assets/images/undraw_secure.svg",
                            height: 220,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start By",
                              style: GoogleFonts.montserrat(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "Registering Pharmacy",
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
                                      builder: (context) => PharmacyStoreDetails(
                                        pharmacyName: pharmacyIpfsHash['pharmacy_name'],
                                        pharmacyOwnerName:
                                        pharmacyIpfsHash['pharmacy_owner_name'],
                                        pharmacyAddress:
                                        pharmacyIpfsHash['pharmacy_address'],
                                        pharmacyYearOrigin:
                                        pharmacyIpfsHash['pharmacy_year_origin'],
                                        pharmacyPhoneNo:
                                        pharmacyIpfsHash['pharmacy_phone_no'],
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
                      :  SizedBox(
                  width: double.infinity,
                  height: 450,
                  child:Card(
                          borderOnForeground: true,
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
                              ListTile(
                                leading: Image.asset(
                                    "assets/icons/pharmacy-shop-100.png",
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 35,
                                    height: 35),
                                title: Text('Pharmacy Name',
                                    style: textStyleForName),
                                subtitle: Text(
                                  pharmacyName,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                  ),
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
                                  pharmacyIpfsHash['pharmacy_owner_name'],
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
                                title: Text('Address', style: textStyleForName),
                                subtitle: Text(
                                  pharmacyIpfsHash['pharmacy_address'],
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ListTile(
                                      leading: Image.asset(
                                          "assets/icons/year-view-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 35,
                                          height: 35),
                                      title: Text(
                                        'Origin',
                                        style: textStyleForName,
                                      ),
                                      subtitle: Text(
                                          pharmacyIpfsHash[
                                              'pharmacy_year_origin'],
                                          style: GoogleFonts.montserrat(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 15,
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: ListTile(
                                      leading: Image.asset(
                                          "assets/icons/phone-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 35,
                                          height: 35),
                                      title: Text('Phone No',
                                          style: textStyleForName),
                                      subtitle: Text(
                                          pharmacyIpfsHash['pharmacy_phone_no'],
                                          style: GoogleFonts.montserrat(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 15,
                                          )),
                                    ),
                                  ),
                                ],
                              ),

                              ListTile(
                                leading: Image.asset(
                                    "assets/icons/storage-100.png",
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 35,
                                    height: 35),
                                title:
                                    Text('IPFS Hash', style: textStyleForName),
                                subtitle: Text(
                                  pharmacyIpfsHashData,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                  ),
                                ),
                                onTap: () {
                                  String _url =
                                      "${keys.getIpfsUrlForReceivingData}$pharmacyIpfsHashData";
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

              SizedBox(
                height: 5,
              ),
              pharmacyIpfsHash['pharmacy_owner_name'] == ''? Container():CustomButtonGen(cardText:'Store or Update Pharmacy Details',onPressed:()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PharmacyStoreDetails(
                      pharmacyName: pharmacyIpfsHash['pharmacy_name'],
                      pharmacyOwnerName:
                      pharmacyIpfsHash['pharmacy_owner_name'],
                      pharmacyAddress:
                      pharmacyIpfsHash['pharmacy_address'],
                      pharmacyYearOrigin:
                      pharmacyIpfsHash['pharmacy_year_origin'],
                      pharmacyPhoneNo:
                      pharmacyIpfsHash['pharmacy_phone_no'],
                    ),
                  ),
                )
              },imageAsset:Image.asset(
                "assets/icons/pharmacy-shop-100.png",
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
    );
  }
}
