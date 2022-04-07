import 'dart:convert';
import 'dart:typed_data';
import 'package:algolia/algolia.dart';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/provider_doctor/model_doctor.dart';
import 'package:bic_android_web_support/screens/screen_doctor/doctor_prescription_form.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/Algolia.dart';
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

import '../../model_class/hospital.dart';
import '../Widgets/CustomButtonGen.dart';
import '../Widgets/CustomCard.dart';
import 'doctor_change_hospital.dart';
import 'doctor_patient_list.dart';
import 'doctor_patient_medical_view.dart';

class DoctorReadScreen extends StatefulWidget {
  static const routeName = '/doctor-record-screen';

  @override
  _DoctorReadScreenState createState() {
    return _DoctorReadScreenState();
  }
}

class _DoctorReadScreenState extends State<DoctorReadScreen> {
  Algolia algolia = Application.algolia;
  String algoliaDoctorAddress = "";
  final _formKey = GlobalKey<FormBuilderState>();
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
    // fetchDoctorData();
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

  Future<void> fetchDoctorData(EthereumAddress address) async {
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

  Widget formBuilderTextFieldWidget(
      TextInputType inputTextType,
      String initialValue,
      String fieldName,
      String labelText,
      Image icon,
      bool obscure,
      List<FormFieldValidator> validators) {
    return FormBuilderTextField(
      keyboardType: inputTextType,
      initialValue: initialValue,
      obscureText: obscure,
      maxLines: 1,
      name: fieldName,
      // allowClear:
      // color:Colors.grey,

      decoration: InputDecoration(
        // helperText: 'hello',
        labelText: labelText,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF6200EE),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),

      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose(validators),
    );
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
            height: 800,
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
                                    selectedItem:HospitalHit(walletAddress:algoliaDoctorAddress==""?"Select Address":algoliaDoctorAddress,  userEmail: '', registerOnce: '', userName: ''),

                                    label: "Doctor Address",
                                    isFilteredOnline: true,
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    onFind: (String? filter) async {
                                      AlgoliaQuery query = algolia.instance
                                          .index('Doctors')
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
                                      return Container(
                                        child: ListTile(
                                          selected: isSelected,
                                          title: Text(item?.userName ?? ''),
                                          subtitle: Text(item?.walletAddress
                                              .toString() ??
                                              ''),

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
                                        algoliaDoctorAddress =
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
                          title: Text('View Medical Record',
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
                              fetchDoctorData(EthereumAddress.fromHex(algoliaDoctorAddress));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                doctorIpfsHash['doctor_name'] == ''
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 500,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
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
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: SvgPicture.asset(
                                  "assets/images/undraw_doctor.svg",
                                  height: 200,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "View Doctor\'s Data",
                                    style: GoogleFonts.montserrat(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    "By Entering",
                                    style: GoogleFonts.montserrat(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    "His Wallet Address",
                                    style: GoogleFonts.montserrat(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 520,
                          child: Card(
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
                                // ListTile(
                                //   leading: Image.asset(
                                //       "assets/icons/checked-user-male-100.png",
                                //       color:
                                //           Theme.of(context).colorScheme.primary,
                                //       width: 35,
                                //       height: 35),
                                //   title: Text('Role', style: textStyleForName),
                                //   subtitle: Text(
                                //     role.toString(),
                                //     style: GoogleFonts.montserrat(
                                //       color: Colors.black.withOpacity(0.6),
                                //       fontSize: 15,
                                //     ),
                                //   ),
                                // ),
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
                                    doctorIpfsHash['doctor_name'],
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child:  ListTile(
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
