import 'dart:io';

import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/provider_firebase/model_firebase.dart';
import 'package:bic_android_web_support/providers/provider_pharmacy/model_pharmacy.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

import '../Widgets/ErrorWidget.dart';

class PatientMedicalRecords extends StatefulWidget {
  static const routeName = '/patient-medical-records';

  @override
  _PatientMedicalRecordsState createState() => _PatientMedicalRecordsState();
}

class _PatientMedicalRecordsState extends State<PatientMedicalRecords> {
  final _formKey = GlobalKey<FormBuilderState>();
  var file;
  bool imageSet = false;

  String walletAdd = '';

  // File file

  @override
  void initState() {
    getWalletFromDatabase();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'))
          ],
        ));
  }


  Future<void> uploadFirstImage(
      ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File _file = File(result.files.single.path.toString());
      setState(() {
        file = _file;
        imageSet = true;
      });
      // var hashReceived =
      // await Provider.of<IPFSModel>(context, listen: false).sendFile(file);
      // print("hashReceived ------" + hashReceived.toString());
      // if (hashReceived.toString().isNotEmpty) {
      //   estimateGasFunction(hashReceived, walletAddress, credentials);
      // }
    } else {
      // User canceled the picker
    }
  }
  Future<void> uploadImage(
      Credentials credentials, EthereumAddress walletAddress) async {

    if (file.isAbsolute != null) {

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
    var dbResponse = await WalletSharedPreference.getWalletDetails();
    walletAdd = dbResponse!['walletAddress'].toString();
    setState(() {
      walletAdd;
    });
  }

  Future<void> estimateGasFunction(String medicalRecordHash,
      EthereumAddress walletAddress, Credentials credentials) async {
    try {
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
    } catch (error) {
        _showErrorDialog(error.toString());
    }

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
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                subtitle: Text(
                                  walletAdd.toString(),
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
                          ),
                          file == null ? Container() : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(file),
                          ),
                          imageSet ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              elevation: 4,
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
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  FormBuilder(
                                      key: _formKey,
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: formBuilderTextFieldWidget(
                                              TextInputType.text,
                                              'Password@123',
                                              'password',
                                              'Wallet Password',
                                              Image.asset(
                                                  "assets/icons/key-100.png",
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  scale: 4,
                                                  width: 15,
                                                  height: 15),
                                              true,
                                              [
                                                FormBuilderValidators.required(
                                                    context),
                                              ]))),
                                  ListTile(
                                    trailing: Image.asset(
                                        "assets/icons/forward-100.png",
                                        color: Theme.of(context).primaryColor,
                                        width: 25,
                                        height: 25),
                                    title: Text('Upload Medical Record',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    onTap: () async {
                                      _formKey.currentState?.save();
                                      if (_formKey.currentState?.validate() !=
                                          false) {
                                        Credentials credentialsNew;
                                        EthereumAddress myAddress;
                                        var dbResponse =
                                        await WalletSharedPreference
                                            .getWalletDetails();
                                        print(_formKey
                                            .currentState?.value["password"]);
                                        try {
                                          Wallet newWallet = Wallet.fromJson(
                                              dbResponse!['walletEncryptedKey']
                                                  .toString(),
                                              _formKey.currentState
                                                  ?.value["password"]);
                                          credentialsNew = newWallet.privateKey;
                                          myAddress = await credentialsNew
                                              .extractAddress();
                                          uploadImage(credentialsNew, myAddress);
                                        } catch
                                      (error) {
                                          print(error);
                                          showErrorDialogWidget(context,error.toString());
                                        }

                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ): Padding(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              elevation: 4,
                              borderOnForeground: true,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(
                                //     color:
                                //         Theme.of(context).colorScheme.primary,
                                //     width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  ListTile(
                                    trailing: Image.asset(
                                        "assets/icons/forward-100.png",
                                        color: Theme.of(context).primaryColor,
                                        width: 25,
                                        height: 25),
                                    title: Text('Upload Image of Medical Record',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    onTap: () async {

                                        uploadFirstImage();

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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
