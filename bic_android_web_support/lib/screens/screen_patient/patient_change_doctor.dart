import 'package:algolia/algolia.dart';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/provider_doctor/model_doctor.dart';
import 'package:bic_android_web_support/providers/provider_firebase/model_firebase.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

import '../../helpers/Algolia.dart';
import '../../model_class/hospital.dart';

class PatientChangeDoctor extends StatefulWidget {
  static const routeName = '/patient-change-doctor';


  final String? oldHospitalAddress;


  const PatientChangeDoctor({

    required this.oldHospitalAddress,
  });

  @override
  _PatientChangeDoctorState createState() => _PatientChangeDoctorState();
}

class _PatientChangeDoctorState extends State<PatientChangeDoctor> {
  Algolia algolia = Application.algolia;
  String algoliaHospitalAddress = "";
  String algoliaDoctorAddress = "";
  TextEditingController _textFieldController = TextEditingController();

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

  Future<void> estimateGasFunction(
      EthereumAddress oldHospitalAddress,
      EthereumAddress newHospitalAddress,
      EthereumAddress walletAddress,
      Credentials credentials) async {
    try {
      var gasEstimation =
      await Provider.of<GasEstimationModel>(context, listen: false)
          .estimateGasForContractFunction(walletAddress, "changeDoctorForPatient",
          [oldHospitalAddress, newHospitalAddress, walletAddress]);
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
                                  walletAddress.hex.toString(),
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
                                  gasEstimation['contractAddress'].toString(),
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
                        Row(children: <Widget>[
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
                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: <Widget>[
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
                        executeTransaction(oldHospitalAddress,newHospitalAddress, walletAddress,
                            credentials);
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

  Future<void> executeTransaction(
      EthereumAddress oldHospitalAddress,
      EthereumAddress newHospitalAddress,
      EthereumAddress walletAddress,
      Credentials credentials) async {
    var transactionHash = await Provider.of<WalletModel>(context, listen: false)
        .writeContract("changeDoctorForPatient",
        [oldHospitalAddress, newHospitalAddress, walletAddress], credentials);

    var firebaseStatus =
    await Provider.of<FirebaseModel>(context, listen: false)
        .storeTransaction(transactionHash);

    if (firebaseStatus) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    }
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
                          'Change Doctor',
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
                                              Theme.of(context).colorScheme.primary,
                                              Colors.purpleAccent.withOpacity(0.9),
                                              // Colors.lightBlueAccent,
                                            ]),
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Your Wallet Address: " + walletAdd,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: formBuilderTextFieldWidget(
                                          TextInputType.streetAddress,
                                          widget.oldHospitalAddress.toString(),
                                          'old_hospital_address',
                                          'Previous Doctor Address',
                                          Image.asset(
                                              "assets/icons/wallet.png",
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
                                    padding: const EdgeInsets.all(15.0),
                                    child: DropdownSearch<HospitalHit>(
                                      selectedItem:HospitalHit(walletAddress:algoliaDoctorAddress==""?"Select Address":algoliaDoctorAddress,  userEmail: '', registerOnce: '', userName: ''),

                                      label: "New Doctor Address",
                                      isFilteredOnline: true,
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      onFind: (String? filter) async {
                                        AlgoliaQuery query = algolia.instance
                                            .index('Doctors')
                                            .query(filter!)
                                            .setLength(1);
                                        query =
                                            query.facetFilter('registerOnce');
                                        // var models = HospitalHit.fromJson(query.parameters);
                                        // Get Result/Objects
                                        AlgoliaQuerySnapshot snap =
                                        await query.getObjects();

                                        List _list = snap.hits;
                                        List<HospitalHit> _newList = snap.hits
                                            .map((item) =>
                                            HospitalHit.fromJson(item.data))
                                            .toList();
                                        return _newList;
                                      },
                                      popupItemBuilder: (BuildContext context,
                                          HospitalHit? item, bool isSelected) {
                                        return Container(
                                          child: ListTile(
                                            selected: isSelected,
                                            title: Text(item?.userName ?? ''),
                                            subtitle: Text(item?.walletAddress
                                                .toString() ??
                                                ''),

                                          ),
                                        );
                                      },
                                      dropDownButton: Container(),
                                      dropdownSearchDecoration: InputDecoration(
                                        constraints: BoxConstraints.tightFor(
                                            width: 320, height: 60),
                                        // helperText: 'hello',
                                        labelText: "Hospital",
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            "assets/icons/wallet.png",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 20,
                                            height: 10,
                                            scale: 0.2,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      dropdownBuilder:
                                          (context, selectedItems) {
                                        var walletAddress =
                                        selectedItems?.walletAddress.toString();

                                        return Text(
                                          walletAddress.toString(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        );

                                        // return Wrap(
                                        //   children: selectedItems.map((e) => item(e)).toList(),
                                        // );
                                      },
                                      onChanged: (data) {
                                        setState(() {
                                          algoliaDoctorAddress =
                                              data!.walletAddress.toString();
                                        });
                                        print(data?.walletAddress.toString());
                                      },
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: formBuilderTextFieldWidget(
                                          TextInputType.number,
                                          'Password@123',
                                          'password',
                                          'Wallet Password',
                                          Image.asset(
                                              "assets/icons/key-100.png",
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: size.width * 0.8,
                          child: FloatingActionButton.extended(
                            heroTag: "doctorStoreDetailsButton",
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
                                print("hello wolrd");
                                Map<String, dynamic> objText = {


                                  "old_hospital_address": _formKey
                                      .currentState?.value["old_hospital_address"],
                                  "new_hospital_address": _formKey
                                      .currentState?.value["new_hospital_address"],
                                  "wallet_address": walletAdd,
                                  // "lastName4": ["Coutinho", "Coutinho", "Coutinho"],
                                  // "age": 30
                                };
                                print(
                                    objText);
                                // var hashReceived = await Provider.of<IPFSModel>(
                                //     context,
                                //     listen: false)
                                //     .sendData(objText);
                                // print("hashReceived ------" +
                                //     hashReceived.toString());
                                if (true) {
                                  Credentials credentialsNew;
                                  EthereumAddress myAddress;
                                  var dbResponse = await WalletSharedPreference
                                      .getWalletDetails();
                                  print(
                                      _formKey.currentState?.value["password"]);
                                  Wallet newWallet = Wallet.fromJson(
                                      dbResponse!['walletEncryptedKey']
                                          .toString(),
                                      _formKey.currentState?.value["password"]);

                                  credentialsNew = newWallet.privateKey;
                                  myAddress =
                                  await credentialsNew.extractAddress();

                                  var old_hospital_address = EthereumAddress.fromHex(_formKey
                                      .currentState?.value["old_hospital_address"]);
                                  var new_hospital_address = EthereumAddress.fromHex(algoliaDoctorAddress);
                                  // var doctorAddress = EthereumAddress.fromHex("  ");
                                  estimateGasFunction(
                                      old_hospital_address,
                                      new_hospital_address,
                                      myAddress,
                                      credentialsNew);
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
                            label: const Text('Change Hospital'),
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
