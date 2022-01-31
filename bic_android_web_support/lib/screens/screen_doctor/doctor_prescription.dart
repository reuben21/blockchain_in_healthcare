import 'dart:convert';
import 'dart:typed_data';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  static const routeName = '/doctor-prescription-screen';

  @override
  _DoctorPrescriptionScreenState createState() {
    return _DoctorPrescriptionScreenState();
  }
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
  final _formPatient = GlobalKey<FormBuilderState>();
  final _formMedicine = GlobalKey<FormBuilderState>();

  String walletAdd = '';
  String todayDateTime = DateTime.now().toIso8601String();

  @override
  void initState() {
    getWalletFromDatabase();
    super.initState();
  }

  Future<void> getWalletFromDatabase() async {
    var dbResponse = await WalletSharedPreference.getWalletDetails();
    walletAdd = dbResponse!['walletAddress'].toString();
    setState(() {
      walletAdd;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _activeCurrentStep = 0;

  InputDecoration dynamicInputDecoration(String labelText, Image icon) {
    return InputDecoration(
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
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();

  List<Map<String, dynamic>> medicineList = [];

  List<Step> stepList() => [
        // This is step1 which is called Account.
        // Here we will fill our personal details
        Step(
          state:
              _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 0,
          title: const Text('Patient'),
          content: SizedBox(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilder(
                  key: _formPatient,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
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
                              child: FormBuilderTextField(
                                initialValue:
                                    '0x1072f3b15da7fecfce1120d605d299f185d0fe1b',
                                maxLines: 1,
                                name: 'patientAddress',
                                decoration: dynamicInputDecoration(
                                  'Patient Address',
                                  Image.asset("assets/icons/at-sign-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      scale: 4,
                                      width: 15,
                                      height: 15),
                                ),
                                // valueTransformer: (text) => num.tryParse(text),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(context)]),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: FormBuilderTextField(
                                initialValue: todayDateTime,
                                obscureText: false,
                                maxLines: 1,
                                name: 'password',
                                decoration: dynamicInputDecoration(
                                  'Date Time',
                                  Image.asset("assets/icons/key-100.png",
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      scale: 4,
                                      width: 15,
                                      height: 15),
                                ),

                                // valueTransformer: (text) => num.tryParse(text),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(context)]),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: FormBuilderDateTimePicker(
                              name: 'date',
                              // onChanged: _onChanged,
                              inputType: InputType.date,
                              decoration: dynamicInputDecoration(
                                'Valid Till',
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
        ),
        // This is Step2 here we will enter our address
        Step(
            state: _activeCurrentStep <= 1
                ? StepState.editing
                : StepState.complete,
            isActive: _activeCurrentStep >= 1,
            title: const Text('Medicine'),
            content: Container(
              child: Column(
                children: [
                  FormBuilder(
                    key: _formMedicine,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
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
                                padding: const EdgeInsets.all(10),
                                child: FormBuilderTextField(
                                  initialValue: 'Medicine 1',
                                  maxLines: 1,
                                  name: 'medicineName',
                                  decoration: dynamicInputDecoration(
                                    'Medicine Name',
                                    Image.asset("assets/icons/at-sign-100.png",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        scale: 4,
                                        width: 15,
                                        height: 15),
                                  ),
                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context)
                                  ]),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: FormBuilderTextField(
                                  initialValue: '1-0-1',
                                  maxLines: 1,
                                  name: 'medicineTime',
                                  decoration: dynamicInputDecoration(
                                    'Medicine Time',
                                    Image.asset("assets/icons/at-sign-100.png",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        scale: 4,
                                        width: 15,
                                        height: 15),
                                  ),
                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context)
                                  ]),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Container(
                                height: 50,
                                width: 100,
                                child: FloatingActionButton.extended(
                                  heroTag: "patientStoreDetailsButton",
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  onPressed: () async {
                                    _formMedicine.currentState?.save();
                                    if (_formMedicine.currentState
                                            ?.validate() !=
                                        false) {
  Map<String, dynamic> objText = {
    "medicineName": _formMedicine
        .currentState?.value["medicineName"],
    "medicineTime": _formMedicine
        .currentState
        ?.value["medicineTime"]
  };
  medicineList.add(objText);
  setState(() {
    medicineList;
  });
                                    }
                                  },
                                  icon: Image.asset("assets/icons/sign_in.png",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 25,
                                      fit: BoxFit.fill,
                                      height: 25),
                                  label: const Text('Add'),
                                ),
                              ),
                            ),
                            Container(
                              height: 300,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 230,
                                        color: Color(0xFF6200EE),
                                        child: const Center(
                                            child: Text('Medicine Name')),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 110,
                                        color: Color(0xFF6200EE),
                                        child: const Center(
                                            child: Text('Medicine Time')),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: medicineList.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          print(medicineList[index]['medicineName']);
                                          return Container(
                                            height: 50,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 230,

                                                  child:  Center(
                                                      child: Text(
                                                          "${medicineList[index]['medicineName']}",style: Theme.of(context).textTheme.bodyText1,)),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 110,

                                                  child: Center(
                                                      child: Text(
                                                          "${medicineList[index]['medicineTime']}",style: Theme.of(context).textTheme.bodyText1,)),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
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
            )),

        // This is Step3 here we will display all the details
        // that are entered by the user
        Step(
            state: StepState.complete,
            isActive: _activeCurrentStep >= 2,
            title: const Text('Confirmation'),
            content: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Name: ${name.text}',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 15)),
                Text('Email: ${email.text}',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 15)),
                Text('Password: ${pass.text}',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 15)),
                Text('Address : ${address.text}',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 15)),
                Text('PinCode : ${pincode.text}',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 15)),
              ],
            )))
      ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Prescription Generation"),
      ),
      body: Center(
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _activeCurrentStep,
          steps: stepList(),
          onStepContinue: () {
            if (_activeCurrentStep < (stepList().length - 1)) {
              setState(() {
                _activeCurrentStep += 1;
              });
            }
          },
          onStepCancel: () {
            if (_activeCurrentStep == 0) {
              return;
            }
            setState(() {
              _activeCurrentStep -= 1;
            });
          },
          onStepTapped: (int index) {
            setState(() {
              _activeCurrentStep = index;
            });
          },
        ),
      ),
    );
  }
}
