import 'dart:io';

import 'package:blockchain_healthcare_frontend/providers/wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/view_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:blockchain_healthcare_frontend/helpers/http_exception.dart' as exception;

class WalletLogin extends StatefulWidget {
  static const routeName = '/wallet-login';
  // WalletLogin({Key key}) : super(key: key);

  @override
  State<WalletLogin> createState() => _WalletLoginState();
}

class _WalletLoginState extends State<WalletLogin> {

  @override
  void initState() {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  void _submit(String password,String address) async {
    try {
      // TODO: WALLET CREATION
      await Provider.of<WalletModel>(context, listen: false)
          .signInWithWallet(address,password);

      // _showErrorDialog("Wallet Has Been Created");
      Navigator.of(context).pushNamed(WalletView.routeName);
    }  on exception.HttpException catch (error)  {
      _showErrorDialog(error.toString());

    }


  }
  final _formKey = GlobalKey<FormBuilderState>();

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80,),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Let's Start By Creating Your Wallet",
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ]),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 50),
                  //   child:
                  //       Center(child: Image.asset("assets/images/undraw_wallet.png")),
                  // ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Enter Password",
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]),
                  Center(
                    child: FormBuilder(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(25),
                                child: FormBuilderTextField(
                                  obscureText: false,
                                  maxLines: 1,
                                  name: 'address',
                                  decoration: const InputDecoration(
                                    labelText:'Address',
                                    prefixIcon:
                                    Icon(Icons.account_balance_wallet_outlined),
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                  ),

                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose(
                                      [FormBuilderValidators.required(context)]),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(25),
                                child: FormBuilderTextField(
                                  obscureText: true,
                                  maxLines: 1,
                                  name: 'password',
                                  decoration: const InputDecoration(
                                      labelText:'Password',
                                    prefixIcon:
                                    Icon(Icons.account_balance_wallet_outlined),
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                  ),

                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose(
                                      [FormBuilderValidators.required(context)]),
                                )),

                           
                          ],
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: HStack(
                      [
                        FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.secondary,
                          onPressed: () async {

                            _formKey.currentState?.save();
                            if (_formKey.currentState?.validate() != null) {
                              String password = _formKey
                                  .currentState?.value["password"];
                              String address = _formKey
                                  .currentState?.value["address"];

                              _submit(password,address);

                            }

                          },
                          icon: const Icon(Icons.add_circle_outline_outlined),
                          label: const Text('Sign In'),
                        ),
                      ],
                      alignment: MainAxisAlignment.spaceAround,
                      axisSize: MainAxisSize.max,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
