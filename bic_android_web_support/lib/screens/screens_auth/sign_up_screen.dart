import 'dart:math';


import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen_patient.dart';
import 'package:bic_android_web_support/screens/screen_unusefull/create_wallet.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormBuilderState>();

  void _submit(
      String name, String emailId, String password, String userType) async {
    // await Hive.openBox<WalletHive>('WalletHive');
    try {
      print(name + " " + emailId + " " + password + " " + userType);
      auth
          .createUserWithEmailAndPassword(email: emailId, password: password)
          .then((value) async => {
                if (value.user?.uid != null)
                  {
                    await Provider.of<WalletModel>(context, listen: false)
                        .createWalletInternally(
                            name, emailId, value.user?.uid, password, userType)

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
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Background(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   'Signup',
                      //   style: TextStyle(fontSize: 20, color: Colors.purple),
                      // ),
                      // SizedBox(height: size.height * 0.03),
                      SvgPicture.asset(
                        "assets/icons/signup.svg",
                        height: size.height * 0.35,
                      ),
                      SizedBox(height: size.height * 0.03),
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
                                // Center(
                                //     child: kIsWeb
                                //         ? Image.asset(
                                //             "assets/icons/signup.svg",
                                //             width: 500,
                                //             height: 500,
                                //           )
                                //         : Image.asset("assets/images/sign_up.png")),
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
                                    child: formBuilderTextFieldWidget(
                                        'name',
                                        'Full Name',
                                        Image.asset("assets/icons/name-100.png",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            scale: 4,
                                            width: 15,
                                            height: 15),
                                        false,
                                        [
                                          FormBuilderValidators.required(
                                              context),
                                        ])),
                                Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: formBuilderTextFieldWidget(
                                        'emailId',
                                        'Email ID',
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
                                          FormBuilderValidators.required(
                                              context),
                                        ])),
                                Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: formBuilderTextFieldWidget(
                                        'password',
                                        'Password',
                                        Image.asset("assets/icons/key-100.png",
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
                                        ])),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: FormBuilderDropdown(
                                    name: 'userType',
                                    decoration: InputDecoration(
                                      labelText: "Type of User",
                                      prefixIcon: Image.asset(
                                          "assets/icons/user-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          scale: 4,
                                          width: 15,
                                          height: 15),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Color(0xFF6200EE),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF6200EE)),
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF6200EE)),
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF6200EE)),
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    // initialValue: 'Male',

                                    allowClear: true,

                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context)
                                    ]),
                                    items: [
                                      'Patient',
                                      'Doctor',
                                      'Hospital',
                                      'Pharmacy'
                                    ]
                                        .map((gender) => DropdownMenuItem(
                                              value: gender,
                                              child: Text('$gender'),
                                            ))
                                        .toList(),
                                  ),
                                ),
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
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary,
                            onPressed: () async {
                              _formKey.currentState?.save();
                              if (_formKey.currentState?.validate() != null) {
                                _submit(
                                    _formKey.currentState?.value["name"],
                                    _formKey.currentState?.value["emailId"],
                                    _formKey.currentState?.value["password"],
                                    _formKey.currentState?.value["userType"]);
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
                                "assets/icons/registration-100.png",
                                color: Theme.of(context).colorScheme.secondary,
                                width: 25,
                                fit: BoxFit.fill,
                                height: 25),
                            label: const Text('Register'),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          FloatingActionButton.extended(
                            heroTag: "logInButtonOnSignUpScreen",
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary,
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            icon: Image.asset("assets/icons/sign_in.png",
                                color: Theme.of(context).colorScheme.secondary,
                                width: 25,
                                fit: BoxFit.fill,
                                height: 25),
                            label: const Text('Log In'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
