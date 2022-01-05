import 'dart:async';
import 'package:bic_android_web_support/databases/hive_database.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import '../../providers/patient.dart';
import '../../theme.dart';
import '../../widgets/forms/login_form.dart';
import '../../widgets/forms/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/screen-login';
  // const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormBuilderState>();

  void _submit(String emailId, String password) async {
    print(emailId + " " + password);
    try {
      await Hive.openBox<WalletHive>('WalletHive');
      auth
          .signInWithEmailAndPassword(email: emailId, password: password)
          .then((value) async => {
                if (value.user?.uid != null)
                  {
                    await Provider.of<WalletModel>(context, listen: false)
                        .signInWithWallet(value.user?.uid, password)

                    // _showErrorDialog("Wallet Has Been Created");
                  }
              });
      Navigator.of(context).pushNamed(TabsScreen.routeName);
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An Error Occurred'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
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
                      const SizedBox(
                        height: 40,
                      ),
                      Center(child: Image.asset("assets/images/sign_in.png")),
                      const SizedBox(
                        height: 80,
                      ),
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: FormBuilderTextField(
                            maxLines: 1,
                            name: 'emailId',
                            decoration: InputDecoration(
                              labelText: 'Email ID',
                              prefixIcon: Icon(
                                FontAwesomeIcons.at,
                                color: Theme.of(context).primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelStyle: TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),

                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: FormBuilderTextField(
                            obscureText: true,
                            maxLines: 1,
                            name: 'password',
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.password,
                                color: Theme.of(context).primaryColor,
                              ),
                              border: const OutlineInputBorder(),
                              labelStyle: const TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),

                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                          )),
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
              FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () async {
                  _formKey.currentState?.save();
                  if (_formKey.currentState?.validate() != null) {
                    _submit(_formKey.currentState?.value["emailId"],
                        _formKey.currentState?.value["password"]);
                  } else {
                    print("validation failed");
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => WalletLogin(),
                  //   ),
                  // );
                },
                icon: Image.asset(
                  "assets/icons/sign_in.png",
                  color: Theme.of(context).backgroundColor,
                  width: 32,
                  height: 32,
                ),
                label: const Text('Sign In'),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
