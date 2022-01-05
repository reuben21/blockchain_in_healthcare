import 'dart:async';
import 'package:bic_android_web_support/databases/hive_database.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:bic_android_web_support/screens/screens_auth/textfieldcontainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Background(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Signup',
                    style: TextStyle(fontSize: 20, color: Colors.purple),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/icons/signup.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldContainer(
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(
                          FontAwesomeIcons.users,
                          color: Theme.of(context).primaryColor,
                        ),
                        border: InputBorder.none,
                        hintText: "Your email",
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {},
                        child: Text("login"),
                      ),
                    ),
                  )
                ],
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
                // icon: Image.asset(
                //   "assets/icons/sign_in.png",
                //   color: Theme.of(context).backgroundColor,
                //   width: 32,
                //   height: 32,
                // ),
                icon: Icon(FontAwesomeIcons.signInAlt),
                label: const Text('Sign In'),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
