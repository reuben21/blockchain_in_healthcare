
import 'dart:typed_data';

import '../../helpers/keys.dart' as keys;
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/screen_pharmacy/pharmacy_store_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class PharmacyRecordScreen extends StatefulWidget {
  static const routeName = '/pharmacy-record-screen';

  @override
  _PharmacyRecordScreenState createState() {
    return _PharmacyRecordScreenState();
  }
}

class _PharmacyRecordScreenState extends State<PharmacyRecordScreen> {
  late String pharmacyName;
  late String pharmacyIpfsHashData;
  late Map<String, dynamic> pharmacyIpfsHash;

  @override
  void initState() {
    pharmacyName = '';
    pharmacyIpfsHashData = '';
    pharmacyIpfsHash = {
      "pharmacy_name":"",
      "pharmacy_owner_name":"",
      "pharmacy_address":"",
      "pharmacy_year_origin":"",
      "pharmacy_phone_no":"",
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
        .readContract("hasRole", [ hexToBytes("0x504841524d414359000000000000000000000000000000000000000000000000"),address]);
    print(dataRole);



    var data = await Provider.of<WalletModel>(context, listen: false)
        .readContract("getPharmacyData", [address]);
    // print(data);
    // print(data[0]);
    if (data[0].toString() != '') {
      var pharmacyData = await Provider.of<IPFSModel>(context, listen: false)
          .receiveData(data[1]);
      // print(pharmacyData);
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
    // TODO: implement build
    var textStyleForName = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Pharmacy Record"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: double.infinity,
                  height: 500,
                  child: pharmacyIpfsHash['pharmacy_owner_name'] == ''
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
                                title: Text('Pharmacy Name',
                                    style: textStyleForName),
                                subtitle: Text(
                                  pharmacyName,
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
                                  pharmacyIpfsHash['pharmacy_owner_name'],
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
                                title: Text('Address', style: textStyleForName),
                                subtitle: Text(
                                  pharmacyIpfsHash['pharmacy_address'],
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
                                  pharmacyIpfsHash['pharmacy_year_origin'],
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
                                  pharmacyIpfsHash['pharmacy_phone_no'],
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
                                title:
                                Text('IPFS Hash', style: textStyleForName),
                                subtitle: Text(
                                  pharmacyIpfsHashData,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                                onTap: () {
                                  String _url = "${keys.getIpfsUrlForReceivingData}$pharmacyIpfsHashData";
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
                        color: Theme.of(context).colorScheme.primary, width: 2),
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
                        title: Text('Store or Update Pharmacy on Blockchain',
                            style: Theme.of(context).textTheme.bodyText1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PharmacyStoreDetails(
                                pharmacyName: pharmacyIpfsHash['pharmacy_name'],
                                pharmacyOwnerName:
                                    pharmacyIpfsHash['pharmacy_owner_name'],
                                pharmacyAddress:
                                    pharmacyIpfsHash['pharmacy_address'],
                                pharmacyYearOrigin: pharmacyIpfsHash['pharmacy_year_origin'],
                                pharmacyPhoneNo: pharmacyIpfsHash['pharmacy_phone_no'],
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
    );
  }
}
