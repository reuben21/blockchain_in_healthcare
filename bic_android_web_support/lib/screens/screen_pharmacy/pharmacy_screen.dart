import 'dart:convert';
import 'dart:typed_data';

import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/provider_pharmacy/model_pharmacy.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:bic_android_web_support/screens/screen_pharmacy/pharmacy_store_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late Map<String,dynamic> pharmacyIpfsHash;


  @override
  void initState() {
    pharmacyName = '';
    pharmacyIpfsHash = {

    };
    fetchPharmacyData();
    super.initState();
  }
  
  Future<void> fetchPharmacyData() async {
    Credentials credentialsNew;
    EthereumAddress address;

    credentialsNew = Provider.of<WalletModel>(context,listen: false).walletCredentials;
    address =
    await credentialsNew.extractAddress();
    var data =await Provider.of<WalletModel>(context,listen: false).readContract("getPharmacyData", [address]);
    print(data);
    print(data[0]);
    if(data[0]!='') {
      var pharmacyData = await Provider.of<IPFSModel>(context,listen: false).receiveData(data[1]);
      print(pharmacyData);
      setState(() {
        pharmacyName = data[0];
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



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  child: pharmacyName == '' ?Card(
                      borderOnForeground: true,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).colorScheme.primary,width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),child: ListTile(
                    leading: Icon(Icons.arrow_drop_down_circle),
                    title: const Text("Not Registered on Blockchain",style: TextStyle(fontSize: 15),),

                  ), ) :Card(
                    borderOnForeground: true,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).colorScheme.primary,width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.arrow_drop_down_circle),
                          title: const Text('Pharmacy Name',style: TextStyle(fontSize: 15),),
                          subtitle: Text(
                            pharmacyName,
                            style: TextStyle(fontSize:20,color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.arrow_drop_down_circle),
                          title: const Text('Owner',style: TextStyle(fontSize: 15),),
                          subtitle: Text(
                            pharmacyIpfsHash['pharmacy_owner_name'],
                            style: TextStyle(fontSize:20,color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.arrow_drop_down_circle),
                          title: const Text('Address',style: TextStyle(fontSize: 15),),
                          subtitle: Text(
                            pharmacyIpfsHash['pharmacy_address'],
                            style: TextStyle(fontSize:20,color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.arrow_drop_down_circle),
                          title: const Text('Year Started',style: TextStyle(fontSize: 15),),
                          subtitle: Text(
                            pharmacyIpfsHash['pharmacy_year_origin'],
                            style: TextStyle(fontSize:20,color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.arrow_drop_down_circle),
                          title: const Text('Phone No',style: TextStyle(fontSize: 15),),
                          subtitle: Text(
                            pharmacyIpfsHash['pharmacy_phone_no'],
                            style: TextStyle(fontSize:20,color: Colors.black.withOpacity(0.6)),
                          ),
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
                    side: BorderSide(color: Theme.of(context).colorScheme.primary,width: 2),
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
                        title: Text('Store your Pharmacy on Blockchain',
                            style: Theme.of(context).textTheme.bodyText1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PharmacyStoreDetails(),
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
