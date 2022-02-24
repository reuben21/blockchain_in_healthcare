import 'dart:io';

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
  late Barcode? result;
  late QRViewController? controller;

  late String dropDownCurrentValue;
  late String scannedAddress;
  late String receiverAddress;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    receiverAddress= "";
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }


  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if(scanData.code.toString().startsWith("ethereum:")) {
        print(scanData.code.toString().substring(8));
        receiverAddress = scanData.code.toString().substring(8);
        setState(() {

        });
      }
      
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
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
                      const SizedBox(
                        height: 80,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(
                            "Transfer ETH",
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),


                      const SizedBox(
                        height: 15,
                      ),

                      // widget.address
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
                          leading: Image.asset(
                              "assets/icons/wallet.png",
                              color:
                              Theme.of(context).colorScheme.secondary,
                              width: 35,
                              height: 35),
                          title: Text('From Wallet Address', style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold,color:
                          Theme.of(context).colorScheme.secondary,)),
                          subtitle: Text(
                            widget.address,
                            style: TextStyle(
                                fontSize: 15,
                              color:
                              Theme.of(context).colorScheme.secondary,),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Text(
                        //     widget.address,style: TextStyle(fontSize: 20),
                        //   ),
                        // ),
                      ),
                      // Text((result != null)
                      //     ? "Ethereum Address: " + result.code.toString()
                      //     : "Scan for Address"),
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () {
                          // do something
                          // _buildQrView(context);
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
                                    // Text((result?.code.toString() != null)
                                    //     ? "Ethereum Address: " +
                                    //        result!.code.toString()
                                    //     : "Scan for Address"),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                // ElevatedButton(
                                //   onPressed: () async {
                                //     // setState(() {
                                //     //   scannedAddress = result!.code.toString();
                                //     // });
                                //   },
                                //   child: Text("GET"),
                                // ),
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
                                      TextInputType.text,
                                      receiverAddress,

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
                                      TextInputType.text,
                                      "5.0",
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
                                      TextInputType.text,
                                      "Password@123",
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
                                          "assets/icons/money-transfer-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          scale: 1,
                                          width: 32,
                                          height: 32),
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
