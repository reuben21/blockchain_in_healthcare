import 'dart:math';

import 'package:bic_android_web_support/databases/hive_database.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/screens/screen_unusefull/create_wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../providers/patient.dart';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

import '../../theme.dart';

class SignUpScreen extends StatefulWidget {
  // SignUpScreen({Key key}) : super(key: key);

  static const routeName = '/sign-up-screen';

  @override
  _SignUpScreenState createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormBuilderState>();

  void _submit(String name, String emailId, String password) async {
    await Hive.openBox<WalletHive>('WalletHive');
    try {
      auth
          .createUserWithEmailAndPassword(email: emailId, password: password)
          .then((value) async => {
                if (value.user?.uid != null)
                  {
                    await Provider.of<WalletModel>(context, listen: false)
                        .createWalletInternally(
                            name, emailId, value.user?.uid, password)

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
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 35,
                    ),
                    Center(
                        child: kIsWeb
                            ? Image.asset(
                                "assets/images/sign_up.png",
                                width: 500,
                                height: 500,
                              )
                            : Image.asset("assets/images/sign_up.png")),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: FormBuilderTextField(
                          maxLines: 1,
                          name: 'name',
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(
                              Icons.person_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
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
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: FormBuilderTextField(
                          maxLines: 1,
                          name: 'emailId',
                          decoration: InputDecoration(
                            labelText: 'Email ID',
                            prefixIcon: Icon(Icons.alternate_email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
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

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            //Center Row contents vertically,
            children: <Widget>[
              FloatingActionButton.extended(
                heroTag: "signUpButtonOnSignUpScreen",
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () async {
                  _formKey.currentState?.save();
                  if (_formKey.currentState?.validate() != null) {
                    _submit(
                        _formKey.currentState?.value["name"],
                        _formKey.currentState?.value["emailId"],
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
                icon:  Image.asset("assets/icons/registration-100.png",
                    color: Theme.of(context).colorScheme.secondary, width: 25,fit: BoxFit.fill, height: 25),
                label: const Text('Register'),
              ),
              const SizedBox(
                width: 50,
              ),
              FloatingActionButton.extended(
                heroTag: "logInButtonOnSignUpScreen",
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                icon: Image.asset("assets/icons/sign_in.png",
                    color: Theme.of(context).colorScheme.secondary, width: 25,fit: BoxFit.fill, height: 25),
                label: const Text('Log In'),
              ),

            ],
          ),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
    ));
  }
}
