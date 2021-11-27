import 'package:blockchain_healthcare_frontend/providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateWallet extends StatefulWidget {
  CreateWallet({Key key}) : super(key: key);

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Let's Start By Creating your wallet",
              style: TextStyle(
                color: Color(0xFF6200EE),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child:
                  Center(child: Image.asset("assets/images/undraw_wallet.png")),
            ),
            Text(
              "Enter Password",
              style: TextStyle(
                color: Color(0xFF6200EE),
              ),
            ),
            FormBuilder(
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
            Align(
              alignment: Alignment.bottomCenter,
              child: HStack(
                [
                  FloatingActionButton.extended(
                    backgroundColor: const Color(0xFF6200EE),
                    foregroundColor: Colors.white,
                    onPressed: () async {
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()) {
                        print(_formKey.currentState.value["password"]);
                        Provider.of<WalletModel>(context, listen: false)
                            .createWallet(
                                _formKey.currentState.value["password"]);
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
    );
  }
}
