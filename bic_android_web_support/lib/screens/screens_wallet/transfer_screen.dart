import 'dart:convert';

import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:bic_android_web_support/screens/screens_wallet/confirmation_screen.dart';

import '../../providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:web3dart/credentials.dart';

class TransferScreen extends StatefulWidget {
  static const routeName = '/transfer-screen';

  final String address;

  const TransferScreen({required this.address});

  @override
  _TransferScreenState createState() {
    return _TransferScreenState();
  }
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  late QRViewController controller;

  late String dropDownCurrentValue;
  late String scannedAddress;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
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

  Widget formBuilderTextFieldWidget(String fieldName, String labelText,
      Image icon, bool obscure, List<FormFieldValidator> validators) {
    return FormBuilderTextField(
      obscureText: obscure,
      maxLines: 1,
      name: fieldName,
      decoration: InputDecoration(
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
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              // color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Center(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            "Transfer Ether",
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),

                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 30),
                          child: Text(
                            "From: ",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // widget.address
                      Container(
                        height: 40,
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
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.address,
                          ),
                        ),
                      ),
                      // Text((result != null)
                      //     ? "Ethereum Address: " + result.code.toString()
                      //     : "Scan for Address"),
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () {
                          // do something
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: Text(
                                "Show the QR Code",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              content: Container(
                                width: 300,
                                height: 500,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 300,
                                      height: 400,
                                      child: QRView(
                                        key: qrKey,
                                        onQRViewCreated: _onQRViewCreated,
                                      ),
                                    ),
                                    Text((result != null)
                                        ? "Ethereum Address: " +
                                            result.code.toString()
                                        : "Scan for Address"),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      scannedAddress = result.code.toString();
                                    });
                                  },
                                  child: Text("GET"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {},
                                  child: Text("okay"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Center(
                        child: FormBuilder(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: formBuilderTextFieldWidget(
                                      "address",
                                      "Receiver address",
                                      Image.asset(
                                          "assets/icons/at-sign-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          scale: 4,
                                          width: 15,
                                          height: 15),
                                      false,
                                      [
                                        FormBuilderValidators.required(context),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: formBuilderTextFieldWidget(
                                      "amount",
                                      "Amount ",
                                      Image.asset("assets/icons/pay-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          scale: 4,
                                          width: 15,
                                          height: 15),
                                      false,
                                      [
                                        FormBuilderValidators.required(context),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: formBuilderTextFieldWidget(
                                      "password",
                                      "Password",
                                      Image.asset("assets/icons/key-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          scale: 4,
                                          width: 15,
                                          height: 15),
                                      true,
                                      [
                                        FormBuilderValidators.required(context),
                                      ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 50,
                                  width: size.width * 0.8,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: ElevatedButton.icon(

                                      icon: Image.asset(
                                          "assets/icons/login-right-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          scale: 1,
                                          width: 25,
                                          height: 25),
                                      // padding: EdgeInsets.symmetric(
                                      //     vertical: 20, horizontal: 40),
                                      // color: Theme.of(context).colorScheme.primary,
                                      onPressed: () async {

                                        _formKey.currentState?.save();
                                        if (_formKey.currentState?.validate() !=
                                            null) {
                                          String amount = _formKey
                                              .currentState?.value["amount"];
                                          String receiverAddress = _formKey
                                              .currentState?.value["address"];
                                          String password = _formKey
                                              .currentState?.value["password"];
                                          // var dbResponse =
                                          // await DBProviderWallet.db.getWalletByWalletAddress(widget.address);
                                          // print(dbResponse);
                                          var dbResponse = await WalletSharedPreference.getWalletDetails();


                                          try {
                                            Credentials credentialsNew;
                                            EthereumAddress myAddress;

                                          Wallet newWallet = Wallet.fromJson(dbResponse!['walletEncryptedKey'].toString(), password);
                                          credentialsNew = newWallet.privateKey;
                                          myAddress = await credentialsNew.extractAddress();

                                          if (true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ConfirmationScreen(
                                                  receiverAddress:
                                                      receiverAddress,
                                                  credentials: credentialsNew,
                                                  amount: amount,

                                                  senderAddress: myAddress.hex,
                                                ),
                                              ),
                                            );
                                          }
                                        } catch(error) {

                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text(error.toString()),
                                            ));
                                          }

                                        }
                                      },
                                      label: const Text("Transfer",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),

                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
