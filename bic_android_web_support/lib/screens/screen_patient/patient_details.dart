import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/provider_firebase/model_firebase.dart';
import 'package:bic_android_web_support/providers/provider_pharmacy/model_pharmacy.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/screens/Widgets/WalletAddressInputFile.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:algolia/algolia.dart';
import '../../model_class/hospital.dart';
import '../Widgets/FlutterDropdownSearch.dart';

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: '4ZUDJZ4TXK',
    apiKey: 'e5b22538596c47fb6a45afa521e3f006',
  );
}

class PatientStoreDetails extends StatefulWidget {

  static const routeName = '/patient-store-details';

  final String? patientName;
  final String? patientHospitalAddress;
  final String? patientDoctorAddress;
  final String? patientAddress;
  final String? patientAge;
  final String? patientPhoneNo;

  const PatientStoreDetails({
    required this.patientName,
    required this.patientHospitalAddress,
    required this.patientDoctorAddress,
    required this.patientAddress,
    required this.patientAge,
    required this.patientPhoneNo,
  });

  @override
  _PatientStoreDetailsState createState() => _PatientStoreDetailsState();
}

class _PatientStoreDetailsState extends State<PatientStoreDetails> {
  Algolia algolia = Application.algolia;
  final _formKey = GlobalKey<FormBuilderState>();
  String _searchText = "";
  List<HospitalHit> _hitsList = [];

  TextEditingController _textFieldController = TextEditingController();


  Future<void> _getSearchResult(String filter) async {
    AlgoliaQuery query = algolia.instance.index('Hospitals').query(filter);
        // var models = HospitalHit.fromJson(query.parameters);
    // Get Result/Objects
    AlgoliaQuerySnapshot snap = await query.getObjects();

    // print(snap.hits);
    // AlgoliaObjectSnapshot _list = snap.hits t;
    print(snap.hits.map((e) => print(e.data)));
    var hitsList = snap.hits.map((item) => HospitalHit.fromJson(item.data)).toList();
    setState(() {
      _hitsList = hitsList;
    });
  }

  String walletAdd = '';
  final TextEditingController hospitalAddress =
      TextEditingController.fromValue(TextEditingValue.empty);

  final TextEditingController doctorAddress =
      TextEditingController.fromValue(TextEditingValue.empty);

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
  void initState() {
    getWalletFromDatabase();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    _textFieldController.addListener(() {
      if (_searchText != _textFieldController.text) {
        setState(() {
          _searchText = _textFieldController.text;
        });
        _getSearchResult(_searchText);
      }
    });
    // _getSearchResult('');
  }

  Future<void> getWalletFromDatabase() async {
    var dbResponse = await WalletSharedPreference.getWalletDetails();
    walletAdd = dbResponse!['walletAddress'].toString();

    setState(() {
      walletAdd;
      hospitalAddress.text = widget.patientHospitalAddress!;
      doctorAddress.text = widget.patientDoctorAddress!;
    });
  }

  Future<void> estimateGasFunction(
      String patientName,
      String ipfsHash,
      EthereumAddress hospitalAddress,
      EthereumAddress doctorAddress,
      EthereumAddress walletAddress,
      Credentials credentials) async {
    var gasEstimation =
        await Provider.of<GasEstimationModel>(context, listen: false)
            .estimateGasForContractFunction(walletAddress, "storePatient", [
      patientName,
      ipfsHash,
      hospitalAddress,
      doctorAddress,
      walletAddress,
    ]);

    print(gasEstimation);
    var hospitalDetails =
        await Provider.of<FirebaseModel>(context, listen: false)
            .checkIfHospitalIsPresent(hospitalAddress.hex);
    var doctorDetails = await Provider.of<FirebaseModel>(context, listen: false)
        .checkIfDoctorIsPresent(doctorAddress.hex);
    if (hospitalDetails == true) {
      if(doctorDetails == true) {
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
                          Row(children: const <Widget>[
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
                              const Flexible(
                                fit: FlexFit.loose,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
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
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(children: const <Widget>[
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
                          executeTransaction(
                              patientName,
                              ipfsHash,
                              hospitalAddress,
                              doctorAddress,
                              walletAddress,
                              credentials

                              );
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
      } else {
        _showErrorDialog("Doctor Address is Incorrect");
      }
    } else {
      _showErrorDialog("Hospital Address is Incorrect");
    }

  }


  Future<void> executeTransaction(
      String patientName,
      String ipfsHash,
      EthereumAddress hospitalAddress,
      EthereumAddress doctorAddress,
      EthereumAddress walletAddress,
      Credentials credentials) async {
    var status = await Provider.of<FirebaseModel>(context, listen: false)
        .storeUserRegistrationStatus(walletAddress.hex);

    if (status == true) {
      var transactionHash =
          await Provider.of<WalletModel>(context, listen: false).writeContract(
              "storePatient",
              [
                patientName,
                ipfsHash,
                hospitalAddress,
                doctorAddress,
                walletAddress
              ],
              credentials);

        Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);

    } else if (status == false) {
      var transactionHash =
          await Provider.of<WalletModel>(context, listen: false).writeContract(
              "storePatient",
              [
                patientName,
                ipfsHash,
                hospitalAddress,
                doctorAddress,
                walletAddress
              ],
              credentials);
      var hospitalRequest =
          await Provider.of<FirebaseModel>(context, listen: false)
              .sendHospitalRequest(hospitalAddress.hex, walletAddress.hex);
      var addToDoctorList =
          await Provider.of<FirebaseModel>(context, listen: false)
              .addPatientToDoctorList(
                  doctorAddress.hex, walletAddress.hex, patientName);
      var firebaseStatus =
          await Provider.of<FirebaseModel>(context, listen: false)
              .storeTransaction(transactionHash);

      if (firebaseStatus) {
        Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      }
    }
  }

  InputDecoration dynamicInputDecoration(String labelText, Image? icon) {
    return InputDecoration(
      // helperText: 'hello',
      labelText: labelText,
      prefixIcon: icon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF6200EE),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF6200EE)),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF6200EE)),
        borderRadius: BorderRadius.circular(20.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF6200EE)),
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
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
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            'Patient Detail Form',
                            style: Theme.of(context).textTheme.headline1,
                          ),
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
                                          widget.patientName.toString() == ''
                                              ? 'Patient A'
                                              : widget.patientName.toString(),
                                          'patient_name',
                                          'Patient Name',
                                          Image.asset(
                                              "assets/icons/pharmacy-shop-100.png",
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
                                  // FlutterDropdownSearch(
                                  //   textController: _textFieldController,
                                  //   items:_hitsList ,
                                  //   dropdownHeight: 300,
                                  // ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: DropdownSearch<HospitalHit>(

                                    label: "Hospital Address",

                                    mode: Mode.BOTTOM_SHEET,
                                    showSearchBox: true,
                                    onFind: (String? filter) async {
                                      AlgoliaQuery query = algolia.instance.index('Hospitals').query(filter!);
                                      query = query.facetFilter('registerOnce');
                                      // var models = HospitalHit.fromJson(query.parameters);
                                      // Get Result/Objects
                                      AlgoliaQuerySnapshot snap = await query.getObjects();


                                      List _list= snap.hits;
                                      List<HospitalHit> _newList =  snap.hits.map((item) => HospitalHit.fromJson(item.data)).toList();
                                      return _newList;
                                    },

                                    popupItemBuilder: (
                                        BuildContext context, HospitalHit? item, bool isSelected) {
                                      return Container(


                                        child: ListTile(
                                          selected: isSelected,
                                          title: Text(item?.userName ?? ''),
                                          subtitle: Text(item?.walletAddress?.toString() ?? ''),
                                          leading: CircleAvatar(
                                            // this does not work - throws 404 error
                                            // backgroundImage: NetworkImage(item.avatar ?? ''),
                                          ),
                                        ),
                                      );
                                    },
                                    dropDownButton: Container(),
                                    dropdownSearchDecoration: InputDecoration(
                                      constraints: BoxConstraints.tightFor(width: 320,height: 60),
                                      // helperText: 'hello',
                                      labelText: "Hospital",
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          "assets/icons/wallet.png",
                                          color:
                                          Theme.of(context).colorScheme.primary,
                                          width: 20,height: 10,scale: 0.2,fit: BoxFit.contain,
                                        ),
                                      ),



                                    ),
                                    dropdownBuilder: (context,selectedItems) {
                                      var walletAddress = selectedItems?.userName.toString();

                                      return
                                            Text(
                                              walletAddress.toString(),

                                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                            );

                                      // return Wrap(
                                      //   children: selectedItems.map((e) => item(e)).toList(),
                                      // );
                                    },
                                    onChanged: (data) {
                                      print(data?.walletAddress.toString());
                                    },
                                  ),
                                ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: DropdownSearch<HospitalHit>(

                                      label: "Doctor Address",

                                      mode: Mode.BOTTOM_SHEET,
                                      showSearchBox: true,
                                      onFind: (String? filter) async {
                                        AlgoliaQuery query = algolia.instance.index('Doctors').query(filter!);
                                        query = query.facetFilter('registerOnce');
                                        // var models = HospitalHit.fromJson(query.parameters);
                                        // Get Result/Objects
                                        AlgoliaQuerySnapshot snap = await query.getObjects();


                                        List _list= snap.hits;
                                        List<HospitalHit> _newList =  snap.hits.map((item) => HospitalHit.fromJson(item.data)).toList();
                                        return _newList;
                                      },

                                      popupItemBuilder: (
                                          BuildContext context, HospitalHit? item, bool isSelected) {
                                        return Container(


                                          child: ListTile(
                                            selected: isSelected,
                                            title: Text(item?.userName ?? ''),
                                            subtitle: Text(item?.walletAddress?.toString() ?? ''),
                                            leading: CircleAvatar(
                                              // this does not work - throws 404 error
                                              // backgroundImage: NetworkImage(item.avatar ?? ''),
                                            ),
                                          ),
                                        );
                                      },
                                      dropDownButton: Container(),
                                      dropdownSearchDecoration: InputDecoration(
                                        constraints: BoxConstraints.tightFor(width: 320,height: 60),
                                        // helperText: 'hello',
                                        labelText: "Hospital",
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            "assets/icons/wallet.png",
                                            color:
                                            Theme.of(context).colorScheme.primary,
                                            width: 20,height: 10,scale: 0.2,fit: BoxFit.contain,
                                          ),
                                        ),



                                      ),
                                      dropdownBuilder: (context,selectedItems) {
                                        var walletAddress = selectedItems?.userName.toString();

                                        return
                                          Text(
                                            walletAddress.toString(),

                                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                          );

                                        // return Wrap(
                                        //   children: selectedItems.map((e) => item(e)).toList(),
                                        // );
                                      },
                                      onChanged: (data) {
                                        print(data?.walletAddress.toString());
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: WalletAddressInputField(
                                      controller: hospitalAddress,
                                      hintText: "Hospital Address",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: WalletAddressInputField(
                                      controller: doctorAddress,
                                      hintText: "Doctor Address",
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: formBuilderTextFieldWidget(
                                          TextInputType.streetAddress,
                                          widget.patientAddress.toString() == ''
                                              ? 'A-103, Rituraj building,Om sai complex, Bhayandar west'
                                              : widget.patientAddress
                                                  .toString(),
                                          'patient_address',
                                          'Patient Address',
                                          Image.asset(
                                              "assets/icons/address-100.png",
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
                                    child: FormBuilderDateTimePicker(
                                      name: 'dateOfBirth',
                                      // onChanged: _onChanged,
                                      inputType: InputType.date,
                                      decoration: dynamicInputDecoration(
                                        'Date of Birth',
                                        Image.asset("assets/icons/key-100.png",
                                            color:
                                            Theme.of(context).colorScheme.primary,
                                            scale: 4,
                                            width: 15,
                                            height: 15),
                                      ),

                                      initialValue: DateTime.now(),
                                      // enabled: true,
                                    ),
                                  ),
                                  // Padding(
                                  //     padding: const EdgeInsets.all(15),
                                  //     child: formBuilderTextFieldWidget(
                                  //         TextInputType.number,
                                  //         widget.patientAge.toString() == ''
                                  //             ? "22"
                                  //             : widget.patientAge.toString(),
                                  //         'patient_age',
                                  //         'Patient Age',
                                  //         Image.asset(
                                  //             "assets/icons/year-view-100.png",
                                  //             color: Theme.of(context)
                                  //                 .colorScheme
                                  //                 .primary,
                                  //             scale: 4,
                                  //             width: 15,
                                  //             height: 15),
                                  //         false,
                                  //         [
                                  //           FormBuilderValidators.required(
                                  //               context),
                                  //         ])),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: FormBuilderDropdown(
                                      initialValue: 'Female',
                                      name: 'patient_gender',
                                      decoration: InputDecoration(
                                        labelText: "Gender",
                                        prefixIcon: Image.asset(
                                            "assets/icons/icons8-gender-100.png",
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
                                        'Male',
                                        'Female',
                                      ]
                                          .map((gender) => DropdownMenuItem(
                                        value: gender,
                                        child: Text('$gender'),
                                      ))
                                          .toList(),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: formBuilderTextFieldWidget(
                                          TextInputType.number,
                                          widget.patientPhoneNo.toString() == ''
                                              ? "7123456789"
                                              : widget.patientPhoneNo
                                                  .toString(),
                                          'patient_phone_no',
                                          'Patient Phone Number',
                                          Image.asset(
                                              "assets/icons/phone-100.png",
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
                                            FormBuilderValidators.minLength(
                                                context, 10),
                                            FormBuilderValidators.maxLength(
                                                context, 13),
                                          ])),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: formBuilderTextFieldWidget(
                                        TextInputType.number,
                                        'Password@123',
                                        'password',
                                        'Wallet Password',
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
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            height: 50,
                            width: size.width * 0.8,
                            child: FloatingActionButton.extended(
                              heroTag: "patientStoreDetailsButton",
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              onPressed: () async {
                                _formKey.currentState?.save();
                                if (_formKey.currentState?.validate() !=
                                    false) {
                                  // _formKey.currentState?.value["name"];
                                  // _formKey.currentState?.value["age"];
                                  // _formKey.currentState?.value["address"];
                                  // _formKey.currentState?.value["gender"];

                                  Map<String, dynamic> objText = {
                                    "patient_name": _formKey
                                        .currentState?.value["patient_name"],
                                    "patient_hospital_address":
                                        hospitalAddress.text,
                                    "patient_doctor_address":
                                        doctorAddress.text,
                                    "patient_address": _formKey
                                        .currentState?.value["patient_address"],
                                    "patient_dateOfBirth": _formKey
                                        .currentState?.value["dateOfBirth"].toString(),
                                    "patient_phone_no": _formKey.currentState
                                        ?.value["patient_phone_no"],
                                    "patient_gender": _formKey.currentState
                                        ?.value["patient_gender"],

                                    "wallet_address": walletAdd,

                                    // "lastName4": ["Coutinho", "Coutinho", "Coutinho"],
                                    // "age": 30
                                  };
                                  var hashReceived =
                                      await Provider.of<IPFSModel>(context,
                                              listen: false)
                                          .sendData(objText);
                                  print("hashReceived ------" +
                                      hashReceived.toString());
                                  if (hashReceived != null) {
                                    Credentials credentialsNew;
                                    EthereumAddress myAddress;
                                    var dbResponse =
                                        await WalletSharedPreference
                                            .getWalletDetails();
                                    print(_formKey
                                        .currentState?.value["password"]);
                                    Wallet newWallet = Wallet.fromJson(
                                        dbResponse!['walletEncryptedKey']
                                            .toString(),
                                        _formKey
                                            .currentState?.value["password"]);
                                    credentialsNew = newWallet.privateKey;
                                    myAddress =
                                        await credentialsNew.extractAddress();

                                    var hospitalAddressEth =
                                        EthereumAddress.fromHex(hospitalAddress.text);
                                    var doctorAddressEth = EthereumAddress.fromHex(doctorAddress.text);
                                    estimateGasFunction(
                                        _formKey.currentState
                                            ?.value["patient_name"],
                                        hashReceived,
                                        hospitalAddressEth,
                                        doctorAddressEth,
                                        myAddress,
                                        credentialsNew);
                                  }
                                } else {
                                  print("validation failed");
                                }
                              },
                              icon: Image.asset("assets/icons/sign_in.png",
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 25,
                                  fit: BoxFit.fill,
                                  height: 25),
                              label: const Text('Store Details'),
                            ),
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
