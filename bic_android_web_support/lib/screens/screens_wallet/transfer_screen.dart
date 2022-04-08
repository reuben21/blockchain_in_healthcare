import 'dart:io';

import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/crypto_api.dart';
import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/screens/Widgets/WalletAddressInputFile.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:bic_android_web_support/screens/screens_wallet/confirmation_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../providers/provider_firebase/model_firebase.dart';
import '../../providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'package:web3dart/credentials.dart';

import '../Tabs/tabs_screen.dart';

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

  late String dropDownCurrentValue;
  late String scannedAddress;
  double? rsRate;

  final TextEditingController receiverAddress =
      TextEditingController.fromValue(TextEditingValue.empty);

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> getWalletFromDatabase() async {
  //   var crypto = await Provider.of<CryptoApiModel>(context,listen: false).getCryptoDataForEthInr();
  //
  // }

  Future<void> estimateGasFunction(

      String senderAddress,
      String receiverAddress,
      String amount,Credentials credentials) async {
    print(senderAddress+" "+receiverAddress+" "+amount);
    var gasEstimation =
    await Provider.of<WalletModel>(context, listen: false)
        .estimateGas(senderAddress,receiverAddress,amount);

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
                                senderAddress,
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
                                receiverAddress.toString(),
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
                      Row(children: const <Widget>[
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
                          const Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
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
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(children: const <Widget>[
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
                          amount,senderAddress,receiverAddress,credentials);
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

  Future<void> executeTransaction(
      String amount,
      String senderAddress,
      String receiverAddress,Credentials credentials) async {



      var txStatus = await Provider.of<WalletModel>(context,
          listen: false)
          .transferEther(credentials,senderAddress, receiverAddress, amount);


      if (txStatus) {
        Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
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
                          leading: Image.asset("assets/icons/wallet.png",
                              color: Theme.of(context).colorScheme.secondary,
                              width: 35,
                              height: 35),
                          title: Text('From Wallet Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              )),
                          subtitle: Text(
                            widget.address,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.secondary,
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
                      // Text((result != null)
                      //     ? "Ethereum Address: " + result.code.toString()
                      //     : "Scan for Address"),
                      // IconButton(
                      //   icon: const Icon(Icons.qr_code_scanner),
                      //   onPressed: () {
                      //     // do something
                      //     // _buildQrView(context);
                      //     scanBarcode();
                      //   },
                      // ),
                      const SizedBox(
                        height: 15,
                      ),

                      Center(
                        child: FormBuilder(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: WalletAddressInputField(
                                    controller: receiverAddress,
                                  ),
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
                                          String receiverAddressValue =
                                              receiverAddress.text;
                                          String password = _formKey
                                              .currentState?.value["password"];
                                          print(receiverAddressValue);
                                          // var dbResponse =
                                          // await DBProviderWallet.db.getWalletByWalletAddress(widget.address);
                                          // print(dbResponse);
                                          var dbResponse =
                                              await WalletSharedPreference
                                                  .getWalletDetails();

                                            try {
                                              Credentials credentialsNew;
                                              EthereumAddress myAddress;

                                            Wallet newWallet = Wallet.fromJson(dbResponse!['walletEncryptedKey'].toString(), password);
                                            credentialsNew = newWallet.privateKey;
                                            myAddress = await credentialsNew.extractAddress();

                                            estimateGasFunction(myAddress.hex, receiverAddressValue, amount,credentialsNew);
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
