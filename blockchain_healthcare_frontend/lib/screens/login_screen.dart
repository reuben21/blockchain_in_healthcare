import 'dart:async';
import 'package:blockchain_healthcare_frontend/providers/patient.dart';
import 'package:blockchain_healthcare_frontend/theme.dart';
import 'package:blockchain_healthcare_frontend/widgets/forms/login_form.dart';
import 'package:blockchain_healthcare_frontend/widgets/forms/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final _formKey = GlobalKey<FormBuilderState>();


  Future<void> login() {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 80,),
                      Center(child: Image.asset("assets/images/sign_in.png")),
                      const SizedBox(
                        height: 80,
                      ),
                      Text(
                        'Welcome Back',
                        style: titleText,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(height: 35,),
                      FormBuilderTextField(
                        maxLines: 1,
                        name: 'name',
                        decoration: const InputDecoration(

                          prefixIcon: Icon(Icons.badge),
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            color: Color(0xFF6200EE),
                          ),
                          helperText: 'Helper text',

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 20),
                        ]),
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 15,),

                      FormBuilderTextField(
                        maxLines: 1,
                        name: 'PIN',
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          labelText: 'PIN',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: Color(0xFF6200EE),
                          ),
                          helperText: 'Enter a 6 Digit PIN',

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),


                          FormBuilderValidators.maxLength(context, 6)
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15,),
                      FormBuilderTextField(
                        maxLines: 1,
                        name: 'privateAddress',
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_balance_wallet,
                          ),
                          labelText: 'Your Private Address',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: Color(0xFF6200EE),
                          ),
                          helperText: 'Enter Hex Private Address',

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),

                        ]),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            //Center Row contents vertically,
            children: <Widget>[
              MaterialButton(
                minWidth: 50.0,
                color: Theme
                    .of(context)
                    .accentColor,
                child: const Text(
                  "Login",
                  style: TextStyle(color: justBlue),
                ),
                onPressed: () async {
                  _formKey.currentState.save();
                  if (_formKey.currentState.validate()) {
                    print(_formKey.currentState.value["privateAddress"]);



                    Credentials credentials = EthPrivateKey.fromHex(
                        _formKey.currentState.value["privateAddress"]);
                    EthereumAddress publicKey = await credentials
                        .extractAddress();

                    Provider.of<PatientsModel>(context, listen: false)
                        .getSignatureHash(
                        Patient(
                            walletAddress: publicKey
                        ));

                  } else {
                    print("validation failed");
                  }
                },
              ),




            ],
          )
        ],
      ),
    ));
  }
}
