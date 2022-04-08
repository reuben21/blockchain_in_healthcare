import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/provider_firebase/model_firebase.dart';
import 'package:bic_android_web_support/providers/provider_pharmacy/model_pharmacy.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_single_medical_view.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

import '../../helpers/Algolia.dart';
import '../../model_class/hospital.dart';
import 'doctor_patient_medical_view_single.dart';

class DoctorPatientMedicalRecordView extends StatefulWidget {
  static const routeName = '/patient-medical-records';


  @override
  _DoctorPatientMedicalRecordViewState createState() => _DoctorPatientMedicalRecordViewState();
}

class _DoctorPatientMedicalRecordViewState extends State<DoctorPatientMedicalRecordView> {
  Algolia algolia = Application.algolia;
  String algoliaPatientAddress = "";
  TextEditingController _textFieldController = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();

  String walletAdd = '';
  String patientAddress = '';
  BigInt medicalRecordCount = BigInt.from(0);

  // File file

  @override
  void initState() {
    getWalletFromDatabase();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  Future<void> uploadImage(
      Credentials credentials, EthereumAddress walletAddress) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path.toString());
      var hashReceived =
      await Provider.of<IPFSModel>(context, listen: false).sendFile(file);
      print("hashReceived ------" + hashReceived.toString());
      if (hashReceived.toString().isNotEmpty) {
        estimateGasFunction(hashReceived, walletAddress, credentials);
      }
    } else {
      // User canceled the picker
    }
  }
  Future<void> getWalletFromDatabase() async {
    Credentials credentialsNew;
    EthereumAddress address;

    credentialsNew =
        Provider.of<WalletModel>(context, listen: false).walletCredentials;
    address = await credentialsNew.extractAddress();

    var data = await Provider.of<PharmacyModel>(context, listen: false)
        .readContract("getMedicalRecordCountForPatient", [address]);
    print(data);
    setState(() {
      walletAdd = address.hex.toString();
      medicalRecordCount = data[0];
    });
  }

  Future<void> getMedicalRecordForPatient(EthereumAddress address) async {



    var data = await Provider.of<PharmacyModel>(context, listen: false)
        .readContract("getMedicalRecordCountForPatient", [address]);
    print(data);
    setState(() {
      medicalRecordCount = data[0];
    });
  }


  Future<void> estimateGasFunction(String medicalRecordHash,
      EthereumAddress walletAddress, Credentials credentials) async {
    var gasEstimation =
    await Provider.of<GasEstimationModel>(context, listen: false)
        .estimateGasForContractFunction(
        walletAddress,
        "setMedicalRecordByPatient",
        [medicalRecordHash, walletAddress]);
    print(gasEstimation);

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: EdgeInsets.all(15),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          "Confirmation Screen",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Colors.purpleAccent.withOpacity(0.9),
                            // Colors.lightBlueAccent,
                          ]),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 65,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Colors.purpleAccent.withOpacity(0.9),
                                    // Colors.lightBlueAccent,
                                  ]),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: ListTile(
                              leading: Image.asset("assets/icons/wallet.png",
                                  color:
                                  Theme.of(context).colorScheme.secondary,
                                  width: 35,
                                  height: 35),
                              title: Text('From Wallet Address',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    Theme.of(context).colorScheme.secondary,
                                  )),
                              subtitle: Text(
                                walletAddress.hex.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: Text(
                            //     widget.address,style: TextStyle(fontSize: 20),
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.purpleAccent.withOpacity(0.9),
                            Theme.of(context).colorScheme.primary,

                            // Colors.lightBlueAccent,
                          ]),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 65,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.purpleAccent.withOpacity(0.9),
                                    Theme.of(context).colorScheme.primary,

                                    // Colors.lightBlueAccent,
                                  ]),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: ListTile(
                              trailing: Image.asset("assets/icons/wallet.png",
                                  color:
                                  Theme.of(context).colorScheme.secondary,
                                  width: 35,
                                  height: 35),
                              title: Text('To Wallet Address',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    Theme.of(context).colorScheme.secondary,
                                  )),
                              subtitle: Text(
                                gasEstimation['contractAddress'].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: Text(
                            //     widget.address,style: TextStyle(fontSize: 20),
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Ether Amount: ",
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                gasEstimation['actualAmountInWei'].toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Expanded(child: Divider()),
                      Row(children: <Widget>[
                        Expanded(child: Divider()),
                      ]),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Gas Estimate: ",
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                gasEstimation['gasEstimate'].toString() +
                                    " units",
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(children: <Widget>[
                        Expanded(child: Divider()),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Gas Price: ",
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                gasEstimation['gasPrice'].toString() + " Wei",
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(children: <Widget>[
                        Expanded(
                          child: Divider(
                            // thickness: 2,
                            // color: Colors.grey,
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "(Approx.) Total Ether Amount: ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                gasEstimation['totalAmount'].toString() +
                                    " ETH",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(children: <Widget>[
                        Expanded(child: Divider()),
                      ]),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  FloatingActionButton.extended(
                    heroTag: "confirmPay",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      executeTransaction(
                          medicalRecordHash, walletAddress, credentials);
                    },
                    icon: const Icon(Icons.add_circle_outline_outlined),
                    label: const Text('Confirm Pay'),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(ctx).pop();
          //   },
          //   child: const Text("okay"),
          // ),
        ],
      ),
    );
  }

  Future<void> executeTransaction(String medicalRecordHash,
      EthereumAddress walletAddress, Credentials credentials) async {
    var transactionHash =
    await Provider.of<PharmacyModel>(context, listen: false).writeContract(
        "setMedicalRecordByPatient",
        [
          medicalRecordHash,
          walletAddress,
        ],
        credentials);

    var firebaseStatus =
    await Provider.of<FirebaseModel>(context, listen: false)
        .storeTransaction(transactionHash);

    if (firebaseStatus) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    }
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Background(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              elevation:4,
                              borderOnForeground: true,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(
                                //     color:
                                //     Theme.of(context).colorScheme.primary,
                                //     width: 2),
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
                                              selectedItem:HospitalHit(walletAddress:algoliaPatientAddress==""?"Select Address":algoliaPatientAddress,  userEmail: '', registerOnce: '', userName: ''),

                                              label: "Patient Address",
                                              isFilteredOnline: true,
                                              mode: Mode.DIALOG,
                                              showSearchBox: true,
                                              onFind: (String? filter) async {
                                                AlgoliaQuery query = algolia.instance
                                                    .index('Patients')
                                                    .query(filter!)
                                                    .setLength(1);

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
                                                          ?.toString().lastCharc(5)}"),

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
                                    trailing: Image.asset(
                                        "assets/icons/forward-100.png",
                                        color: Theme.of(context).primaryColor,
                                        width: 25,
                                        height: 25),
                                    title: Text('View Medical Record',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    onTap: () async {
                                      _formKey.currentState?.save();
                                      if (_formKey.currentState?.validate() !=
                                          false) {

                                        getMedicalRecordForPatient(EthereumAddress.fromHex(algoliaPatientAddress));

                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              trailing: Image.asset(
                                  "assets/icons/icons8-medical-history-100.png",
                                  color: Theme.of(context)
                                      .primaryColor,
                                  width: 25,
                                  height: 25),
                              title: Text(
                                  "Found ${medicalRecordCount.toString()} Medical Records ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                width: double.infinity,
                                height: size.height - 400,
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: medicalRecordCount.toInt(),
                                      itemBuilder:
                                          (BuildContext context, int position) {
                                        return Card(
                                          elevation: 4,
                                          borderOnForeground: true,
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            // side: BorderSide(
                                            //     color: Theme.of(context)
                                            //         .colorScheme
                                            //         .primary,
                                            //     width: 2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                trailing: Image.asset(
                                                    "assets/icons/forward-100.png",
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 25,
                                                    height: 25),
                                                title: Text(
                                                    'Medical Record ${position + 1}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DoctorPatientMedicalRecordViewSingle(
                                                            recordNumber: position + 1,
                                                            walletAddress:
                                                            EthereumAddress.fromHex(
                                                                algoliaPatientAddress),
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                )),
                          )
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
  String lastCharc(int n) => substring(length - n);
}