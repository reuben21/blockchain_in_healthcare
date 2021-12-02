import 'dart:io';

import 'package:blockchain_healthcare_frontend/providers/wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/view_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:blockchain_healthcare_frontend/helpers/http_exception.dart' as exception;

class CreateWallet extends StatefulWidget {
  CreateWallet({Key key}) : super(key: key);

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {

  void _submit(String password) async {
    try {
      await Provider.of<WalletModel>(context, listen: false)
          .createWallet(password);

      _showErrorDialog("Wallet Has Been Created");
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
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child:
                        Center(child: Image.asset("assets/images/undraw_wallet.png")),
                  ),
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
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                     Flexible(
                       fit: FlexFit.tight,
                       child: FormBuilder(

                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: FormBuilderTextField(

                                  maxLines: 1,
                                  name: 'password',
                                  obscureText: true,
                                  decoration: const InputDecoration(

                                    prefixIcon: Icon(Icons.password),
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                  ),

                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context),
                                    FormBuilderValidators.maxLength(context, 15)
                                  ]),
                                  keyboardType: TextInputType.visiblePassword,
                                ))),
                     ),

                  ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: HStack(
                      [
                        FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.secondary,
                          onPressed: () async {
                            _formKey.currentState.save();
                            if (_formKey.currentState.validate()) {
                              _submit(_formKey.currentState.value["password"]);
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline_outlined),
                          label: const Text('Create Wallet'),
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
