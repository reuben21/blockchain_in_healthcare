import 'package:algolia/algolia.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_change_doctor.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_change_hospital.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/Algolia.dart';
import '../../helpers/keys.dart' as keys;
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../../model_class/hospital.dart';
import '../Widgets/CustomButtonGen.dart';
import '../Widgets/CustomCard.dart';
import '../screen_doctor/doctor_read_screen.dart';
import '../screen_hospital/hospital_read_screen.dart';

class PatientReadScreen extends StatefulWidget {
  static const routeName = '/patient-record-screen';

  @override
  _PatientReadScreenState createState() {
    return _PatientReadScreenState();
  }
}

class _PatientReadScreenState extends State<PatientReadScreen> {
  Algolia algolia = Application.algolia;
  String algoliaPatientAddress = "";
  TextEditingController _textFieldController = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();
  
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
    super.initState();
  }

  Future<void> fetchPatientData(EthereumAddress address) async {




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
                                      labelText: "Enter Patient Name",
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          _textFieldController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                  label: "Patient Address",
                                  isFilteredOnline: true,
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  onFind: (String? filter) async {
                                    AlgoliaQuery query = algolia.instance
                                        .index('Patients')
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
                                              ?.toString().subStringLastChars(5)}"),

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
                            fetchPatientData(EthereumAddress.fromHex(algoliaPatientAddress));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
                                "Entering",
                                style: GoogleFonts.montserrat(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "Patient Address",
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
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
