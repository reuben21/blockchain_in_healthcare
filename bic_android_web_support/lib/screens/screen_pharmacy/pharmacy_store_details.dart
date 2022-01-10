import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/provider_pharmacy/model_pharmacy.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

class PharmacyStoreDetails extends StatefulWidget {
  static const routeName = '/pharmacy-store-details';

  const PharmacyStoreDetails({Key? key}) : super(key: key);

  @override
  _PharmacyStoreDetailsState createState() => _PharmacyStoreDetailsState();
}

class _PharmacyStoreDetailsState extends State<PharmacyStoreDetails> {
  final _formKey = GlobalKey<FormBuilderState>();

  String walletAdd = '';

  @override
  void initState() {
    getWalletFromDatabase();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  Future<void> getWalletFromDatabase() async {
    var dbResponse = await WalletSharedPreference.getWalletDetails();
    walletAdd = dbResponse!['walletAddress'].toString();
    setState(() {
      walletAdd;
    });
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
      // appBar: AppBar(
      //   elevation: 0,
      // ),
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
                        Text(
                          'Pharmacy Detail',
                          style: Theme.of(context).textTheme.headline1,
                        ),

                        // SizedBox(height: size.height * 0.03),
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
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              Colors.purpleAccent
                                                  .withOpacity(0.9),
                                              // Colors.lightBlueAccent,
                                            ]),
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Wallet Address: " + walletAdd,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: formBuilderTextFieldWidget(
                                          TextInputType.text,
                                          'Pharmacy A',
                                          'pharmacy_name',
                                          'Pharmacy Name',
                                          Image.asset(
                                              "assets/icons/name-100.png",
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
                                          TextInputType.text,
                                          'Pharmacy A',
                                          'pharmacy_owner_name',
                                          'Name of Owner',
                                          Image.asset(
                                              "assets/icons/name-100.png",
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
                                          TextInputType.streetAddress,
                                          'Shop No 3, Happy Home Apartment, near J B Khot School, Mahavir Nagar, Borivali West, Mumbai, Maharashtra',
                                          'pharmacy_address',
                                          'Pharmacy Address',
                                          Image.asset(
                                              "assets/icons/key-100.png",
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
                                          TextInputType.number,
                                          '2012',
                                          'pharmacy_year_origin',
                                          'Pharmacy Year Origin',
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
                                          TextInputType.number,
                                          '2012',
                                          'pharmacy_phone_no',
                                          'Pharmacy Phone Number',
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
                                          TextInputType.number,
                                          'Password@123',
                                          'password',
                                          'Wallet Password',
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
                                  // Padding(
                                  //   padding: const EdgeInsets.all(15),
                                  //   child: FormBuilderDropdown(
                                  //     initialValue: 'Female',
                                  //     name: 'gender',
                                  //     decoration: InputDecoration(
                                  //       labelText: "Gender",
                                  //       prefixIcon: Image.asset(
                                  //           "assets/icons/user-100.png",
                                  //           color: Theme.of(context)
                                  //               .colorScheme
                                  //               .primary,
                                  //           scale: 4,
                                  //           width: 15,
                                  //           height: 15),
                                  //       border: OutlineInputBorder(
                                  //         borderRadius:
                                  //         BorderRadius.circular(25.0),
                                  //       ),
                                  //       labelStyle: const TextStyle(
                                  //         color: Color(0xFF6200EE),
                                  //       ),
                                  //       errorBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(
                                  //             color: Color(0xFF6200EE)),
                                  //         borderRadius:
                                  //         BorderRadius.circular(25.0),
                                  //       ),
                                  //       focusedErrorBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(
                                  //             color: Color(0xFF6200EE)),
                                  //         borderRadius:
                                  //         BorderRadius.circular(25.0),
                                  //       ),
                                  //       enabledBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(
                                  //             color: Color(0xFF6200EE)),
                                  //         borderRadius:
                                  //         BorderRadius.circular(25.0),
                                  //       ),
                                  //     ),
                                  //     // initialValue: 'Male',
                                  //
                                  //     allowClear: true,
                                  //
                                  //     validator: FormBuilderValidators.compose([
                                  //       FormBuilderValidators.required(context)
                                  //     ]),
                                  //     items: [
                                  //       'Male',
                                  //       'Female',
                                  //     ]
                                  //         .map((gender) => DropdownMenuItem(
                                  //       value: gender,
                                  //       child: Text('$gender'),
                                  //     ))
                                  //         .toList(),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: size.width * 0.8,
                          child: FloatingActionButton.extended(
                            heroTag: "pharmacyStoreDetailsButton",
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary,
                            onPressed: () async {
                              _formKey.currentState?.save();
                              if (_formKey.currentState?.validate() != null) {
                                // _formKey.currentState?.value["name"];
                                // _formKey.currentState?.value["age"];
                                // _formKey.currentState?.value["address"];
                                // _formKey.currentState?.value["gender"];

                                Map<String, dynamic> objText = {
                                  "pharmacy_name": _formKey
                                      .currentState?.value["pharmacy_name"],
                                  "pharmacy_owner_name": _formKey.currentState
                                      ?.value["pharmacy_owner_name"],
                                  "pharmacy_address": _formKey
                                      .currentState?.value["pharmacy_address"],
                                  "pharmacy_year_origin": _formKey.currentState
                                      ?.value["pharmacy_year_origin"],
                                  "pharmacy_phone_no": _formKey
                                      .currentState?.value["pharmacy_phone_no"],
                                  "wallet_address": walletAdd,
                                  // "lastName4": ["Coutinho", "Coutinho", "Coutinho"],
                                  // "age": 30
                                };
                                var hashReceived = await Provider.of<IPFSModel>(
                                        context,
                                        listen: false)
                                    .sendData(objText);
                                print("hashReceived ------" +
                                    hashReceived.toString());
                                if (hashReceived != null) {
                                  Credentials credentialsNew;
                                  EthereumAddress myAddress;
                                  var dbResponse = await WalletSharedPreference
                                      .getWalletDetails();

                                  Wallet newWallet = Wallet.fromJson(
                                      dbResponse!['walletEncryptedKey']
                                          .toString(),
                                      _formKey.currentState?.value["password"]);
                                  credentialsNew = newWallet.privateKey;
                                  myAddress =
                                      await credentialsNew.extractAddress();

                                  var gasEstimation =
                                      await Provider.of<GasEstimationModel>(
                                              context,
                                              listen: false)
                                          .estimateGasForContractFunction(
                                              myAddress, "storePharmacy", [
                                    _formKey
                                        .currentState?.value["pharmacy_name"].toString(),
                                    hashReceived,
                                    myAddress
                                  ]);
                                  var transactionHash =
                                  await Provider.of<PharmacyModel>(
                                      context,
                                      listen: false).writeContract("storePharmacy", [
                                    _formKey
                                        .currentState?.value["pharmacy_name"].toString(),
                                    hashReceived,
                                    myAddress
                                  ], credentialsNew);

                                  print(transactionHash);

                                }
                              } else {
                                print("validation failed");
                              }
                            },
                            icon: Image.asset("assets/icons/sign_in.png",
                                color: Theme.of(context).colorScheme.secondary,
                                width: 25,
                                fit: BoxFit.fill,
                                height: 25),
                            label: const Text('Store Details'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
