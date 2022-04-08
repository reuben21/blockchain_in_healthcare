import 'dart:typed_data';

import 'package:algolia/algolia.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/Algolia.dart';
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

import '../../model_class/hospital.dart';
import '../Widgets/CustomButtonGen.dart';
import '../Widgets/CustomCard.dart';
import '../screen_doctor/doctor_patient_medical_view.dart';
import '../screen_patient/patient_prescription_view.dart';
import '../screen_patient/prescription_screen.dart';

class PharmacyReadScreen extends StatefulWidget {
  static const routeName = '/pharmacy-record-screen';

  @override
  _PharmacyReadScreenState createState() {
    return _PharmacyReadScreenState();
  }
}

class _PharmacyReadScreenState extends State<PharmacyReadScreen> {
  Algolia algolia = Application.algolia;
  String algoliaPatientAddress = "";
  TextEditingController _textFieldController = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();

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

    super.initState();
  }

  Future<void> fetchPharmacyData( EthereumAddress address
  ) async {



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
              Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 8, right: 8, bottom: 8),
                child: Card(
                  elevation: 4,
                  borderOnForeground: true,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      FormBuilder(
                          key: _formKey,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: DropdownSearch<HospitalHit>(
                                  selectedItem:HospitalHit(walletAddress:algoliaPatientAddress==""?"Select Address":algoliaPatientAddress,  userEmail: '', registerOnce: '', userName: ''),
                                  searchFieldProps: TextFieldProps(
                                    controller: _textFieldController,
                                    decoration: InputDecoration(
                                      labelText: "Enter Pharmacy Name",
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          _textFieldController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                  label: "Pharmacy Address",
                                  isFilteredOnline: true,
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  onFind: (String? filter) async {
                                    AlgoliaQuery query = algolia.instance
                                        .index('Pharmacies')
                                        .query(filter!)
                                        .setLength(1);
                                    query =
                                        query.facetFilter('registerOnce');
                                    // var models = HospitalHit.fromJson(query.parameters);
                                    // Get Result/Objects
                                    AlgoliaQuerySnapshot snap =
                                    await query.getObjects();

                                    List _list = snap.hits;
                                    List<HospitalHit> _newList = snap.hits
                                        .map((item) =>
                                        HospitalHit.fromJson(item.data))
                                        .toList();
                                    return _newList;
                                  },
                                  popupItemBuilder: (BuildContext context,
                                      HospitalHit? item, bool isSelected) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryVariant,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.0),
                                          ),
                                        ),
                                        child: ListTile(
                                          selected: isSelected,
                                          title: Text(item?.userName == null ? "" :"${item?.userName}"+ (item?.registerOnce.toLowerCase() == "false"?" (Not on Blockchain)":"") ),
                                          subtitle: Text(item?.walletAddress
                                              ?.toString() == null ?"":"${item?.walletAddress
                                              ?.toString().substring(0,6)}"+"..."+"${item?.walletAddress
                                              ?.toString().lastCharcfunc(5)}"),

                                        ),
                                      ),
                                    );
                                  },
                                  dropDownButton: Container(),
                                  dropdownSearchDecoration: InputDecoration(
                                    constraints: BoxConstraints.tightFor(
                                        width: 320, height: 60),
                                    // helperText: 'hello',
                                    labelText: "Hospital",
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        "assets/icons/wallet.png",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 20,
                                        height: 10,
                                        scale: 0.2,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  dropdownBuilder:
                                      (context, selectedItems) {
                                    var walletAddress =
                                    selectedItems?.walletAddress.toString();

                                    return Text(
                                      walletAddress.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    );

                                    // return Wrap(
                                    //   children: selectedItems.map((e) => item(e)).toList(),
                                    // );
                                  },
                                  onChanged: (data) {
                                    setState(() {
                                      algoliaPatientAddress =
                                          data!.walletAddress.toString();
                                    });
                                    print(data?.walletAddress.toString());
                                  },
                                ),
                              ),
                            ],
                          )),
                      ListTile(
                        trailing: Image.asset("assets/icons/forward-100.png",
                            color: Theme.of(context).primaryColor,
                            width: 25,
                            height: 25),
                        title: Text('View Pharmacy',
                            style: Theme.of(context).textTheme.bodyText1),
                        onTap: () async {
                          _formKey.currentState?.save();
                          if (_formKey.currentState?.validate() != false) {
                            // Credentials credentialsNew;
                            // EthereumAddress myAddress;
                            // var dbResponse =
                            // await WalletSharedPreference
                            //     .getWalletDetails();
                            // print(_formKey.currentState?.value["address"]);
                            // Wallet newWallet = Wallet.fromJson(
                            //     dbResponse!['walletEncryptedKey']
                            //         .toString(),
                            //     _formKey.currentState
                            //         ?.value["password"]);
                            // credentialsNew = newWallet.privateKey;
                            // myAddress = await credentialsNew
                            //     .extractAddress();
                            // uploadImage(credentialsNew, myAddress);
                            // String address =
                            //     _formKey.currentState?.value["address"];
                            // setState(() {
                            //   patientAddress;
                            // });
                            fetchPharmacyData(EthereumAddress.fromHex(algoliaPatientAddress));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
                          "Enter ",
                          style: GoogleFonts.montserrat(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          "Pharmacy Address",
                          style: GoogleFonts.montserrat(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 25,
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



            ],
          ),
        ),
      ),
    );
  }
}


extension E on String {
  String lastCharcfunc(int n) => substring(length - n);
}
