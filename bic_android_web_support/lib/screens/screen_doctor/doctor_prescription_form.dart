import 'package:algolia/algolia.dart';
import 'package:bic_android_web_support/databases/wallet_shared_preferences.dart';
import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/providers/provider_doctor/model_doctor.dart';
import 'package:bic_android_web_support/providers/provider_firebase/model_firebase.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../../helpers/Algolia.dart';
import '../../model_class/hospital.dart';

class DoctorPrescriptionForm extends StatefulWidget {
  static const routeName = '/doctor-prescription-screen';


  @override
  _DoctorPrescriptionFormState createState() {
    return _DoctorPrescriptionFormState();
  }
}

class _DoctorPrescriptionFormState extends State<DoctorPrescriptionForm> {
  Algolia algolia = Application.algolia;
  String algoliaPatientAddress = "";
  TextEditingController _textFieldController = TextEditingController();

  final _formPatient = GlobalKey<FormBuilderState>();
  final _formMedicine = GlobalKey<FormBuilderState>();
  final _formFieldForPassword = GlobalKey<FormBuilderState>();

  String walletAdd = '';
  String todayDateTime = DateTime.now().toIso8601String();

  @override
  void initState() {
    getWalletFromDatabase();
    super.initState();
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

  // TextEditingController name = TextEditingController();
  // TextEditingController email = TextEditingController();
  // TextEditingController pass = TextEditingController();
  // TextEditingController address = TextEditingController();
  // TextEditingController pincode = TextEditingController();

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
                            padding: const EdgeInsets.all(15.0),
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
                          SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DropdownSearch<HospitalHit>(
                              searchFieldProps: TextFieldProps(
                                controller: _textFieldController,
                                decoration: InputDecoration(
                                  labelText: "Enter Patient Name",
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      _textFieldController.clear();
                                    },
                                  ),
                                ),
                              ),
                              selectedItem:HospitalHit(walletAddress:algoliaPatientAddress==""?"Select Address":algoliaPatientAddress,  userEmail: '', registerOnce: '', userName: ''),

                              label: "Patient Address",
                              isFilteredOnline: true,
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              onFind: (String? filter) async {
                                AlgoliaQuery query = algolia.instance
                                    .index('Patients')
                                    .query(filter!)
                                    .setLength(1);

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
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    child: ListTile(
                                      selected: isSelected,
                                      title: Text(item?.userName == null ? "" :"${item?.userName}"+ (item?.registerOnce.toLowerCase() == "false"?" (Not on Blockchain)":"") ),
                                      subtitle: Text(item?.walletAddress
                                          .toString() == null ?"":"${item?.walletAddress
                                          .toString().substring(0,6)}"+"..."+"${item?.walletAddress
                                          .toString().lastCharc(5)}"),

                                    ),
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
                                  algoliaPatientAddress =
                                      data!.walletAddress.toString();
                                });
                                print(data?.walletAddress.toString());
                              },
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: FormBuilderTextField(
                                initialValue: todayDateTime,
                                obscureText: false,
                                maxLines: 1,
                                name: 'dateTimeToday',
                                decoration: dynamicInputDecoration(
                                  'Origin Time',
                                  Image.asset("assets/icons/icons8-alarm-on-100.png",
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
                              name: 'validTill',
                              // onChanged: _onChanged,
                              inputType: InputType.date,
                              decoration: dynamicInputDecoration(
                                'Valid Till',
                                Image.asset("assets/icons/icons8-alarm-off-100.png",
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
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
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
                                          "Your Wallet Address: " + walletAdd,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: FormBuilderTextField(
                                  initialValue: 'Medicine 1',
                                  maxLines: 1,
                                  name: 'medicineName',
                                  decoration: dynamicInputDecoration(
                                    'Medicine Name',
                                    null,
                                  ),
                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context)
                                  ]),
                                )),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: FormBuilderTextField(
                                        initialValue: '1-0-1',
                                        maxLines: 1,
                                        name: 'medicineTime',
                                        decoration: dynamicInputDecoration(
                                          'Time',
                                          null,
                                        ),
                                        // valueTransformer: (text) => num.tryParse(text),
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context)
                                        ]),
                                      )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: FormBuilderTextField(
                                        initialValue: '1',
                                        maxLines: 1,
                                        name: 'medicineQuantity',
                                        decoration: dynamicInputDecoration(
                                          'Quantity',
                                          null,
                                        ),
                                        // valueTransformer: (text) => num.tryParse(text),
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context)
                                        ]),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FloatingActionButton(
                                    heroTag: "patientPrescriptionAdd",
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
                                              .currentState
                                              ?.value["medicineName"],
                                          "medicineTime": _formMedicine
                                              .currentState
                                              ?.value["medicineTime"],
                                          "medicineQuantity": _formMedicine
                                              .currentState
                                              ?.value["medicineQuantity"],
                                        };
                                        medicineList.add(objText);
                                        setState(() {
                                          medicineList;
                                        });
                                      }
                                    },
                                    child: Image.asset(
                                        "assets/icons/icons8-add-100.png",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 25,
                                        fit: BoxFit.fill,
                                        height: 25),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 300,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16.0)),
                                          child: Container(
                                            height: 50,
                                            width: 200,
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: const Center(
                                                child: Text('Medicine Name')),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16.0)),
                                            child: Container(
                                              height: 50,
                                              width: 90,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: const Center(
                                                  child: Text(
                                                'Medicine Time',
                                                textAlign: TextAlign.center,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16.0)),
                                          child: Container(
                                            height: 50,
                                            width: 90,
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: const Center(
                                                child: Text(
                                              'Medicine Quantity',
                                              textAlign: TextAlign.center,
                                            )),
                                          ),
                                        ),
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
                                          // print(medicineList[index]
                                          //     ['medicineName']);
                                          return Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Container(
                                              height: 50,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    16.0)),
                                                        child: Container(
                                                          height: 50,
                                                          width: 180,
                                                          color: Color.fromRGBO(
                                                              234, 206, 242, 1),
                                                          child: Center(
                                                              child: Text(
                                                            "${medicineList[index]['medicineName']}",
                                                            style:
                                                                Theme.of(context)
                                                                    .textTheme
                                                                    .bodyText1,
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 5,left: 8,right: 10),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    16.0)),
                                                        child: Container(
                                                          height: 50,
                                                          width: 110,
                                                          color: Color.fromRGBO(
                                                              234, 206, 242, 1),
                                                          child: Center(
                                                              child: Text(
                                                            "${medicineList[index]['medicineTime']}",
                                                            style:
                                                                Theme.of(context)
                                                                    .textTheme
                                                                    .bodyText1,
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 5,left: 3),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(
                                                                    16.0)),
                                                        child: Container(
                                                          height: 50,
                                                          width: 110,
                                                          color: Color.fromRGBO(
                                                              234, 206, 242, 1),
                                                          child: Center(
                                                              child: Text(
                                                            "${medicineList[index]['medicineQuantity']}",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyText1,
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                        "Patient Wallet Address: ${algoliaPatientAddress}",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child:   Container(
                    height: 300,
                    child: Column(
                      children: <Widget>[
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  color:
                                  Theme.of(context).primaryColor,
                                  child: const Center(
                                      child: Text('Medicine Name')),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(16.0)),
                                  child: Container(
                                    height: 50,
                                    width: 90,
                                    color: Theme.of(context)
                                        .primaryColor,
                                    child: const Center(
                                        child: Text(
                                          'Medicine Time',
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                child: Container(
                                  height: 50,
                                  width: 90,
                                  color:
                                  Theme.of(context).primaryColor,
                                  child: const Center(
                                      child: Text(
                                        'Medicine Quantity',
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),
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
                                // print(medicineList[index]
                                //     ['medicineName']);
                                return Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: ClipRRect(
                                              borderRadius:
                                              const BorderRadius
                                                  .all(
                                                  Radius.circular(
                                                      16.0)),
                                              child: Container(
                                                height: 50,
                                                width: 180,
                                                color: Color.fromRGBO(
                                                    234, 206, 242, 1),
                                                child: Center(
                                                    child: Text(
                                                      "${medicineList[index]['medicineName']}",
                                                      style:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5,left: 8,right: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                              const BorderRadius
                                                  .all(
                                                  Radius.circular(
                                                      16.0)),
                                              child: Container(
                                                height: 50,
                                                width: 110,
                                                color: Color.fromRGBO(
                                                    234, 206, 242, 1),
                                                child: Center(
                                                    child: Text(
                                                      "${medicineList[index]['medicineTime']}",
                                                      style:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5,left: 3),
                                            child: ClipRRect(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(
                                                      16.0)),
                                              child: Container(
                                                height: 50,
                                                width: 110,
                                                color: Color.fromRGBO(
                                                    234, 206, 242, 1),
                                                child: Center(
                                                    child: Text(
                                                      "${medicineList[index]['medicineQuantity']}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                FormBuilder(
                  key: _formFieldForPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: FormBuilderTextField(
                                initialValue: 'Password@123',
                                obscureText: true,
                                maxLines: 1,
                                name: 'password',
                                decoration: dynamicInputDecoration(
                                  'Password',
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
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: 50,
                    width: 100,
                    child: FloatingActionButton.extended(
                      heroTag: "patientStoreDetailsButton",
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      onPressed: () async {
                        _formPatient.currentState?.save();
                        _formMedicine.currentState?.save();
                        _formFieldForPassword.currentState?.save();
                        if (_formPatient.currentState?.validate() != false) {
                          // _formKey.currentState?.value["name"];
                          // _formKey.currentState?.value["age"];
                          // _formKey.currentState?.value["address"];
                          // _formKey.currentState?.value["gender"];
                          var doctorHospitalAddress =
                              Provider.of<DoctorModel>(context, listen: false)
                                  .doctorHospitalAddress;
                          print(doctorHospitalAddress?.hex);
                          Map<String, dynamic> objText = {
                            "patientAddress":algoliaPatientAddress,
                            "doctorAddress": walletAdd,
                            "dateOfPrescription": _formPatient
                                .currentState?.value["dateTimeToday"],
                            "validTill": _formPatient
                                .currentState?.value["validTill"]
                            .toIso8601String(),
                            "medicineList": medicineList,
                            "description": "Other Details",
                          };
                          print(objText);
                          var hashReceived = await Provider.of<IPFSModel>(
                                  context,
                                  listen: false)
                              .sendData(objText);
                          print(
                              "hashReceived ------" + hashReceived.toString());
                          if (hashReceived != null) {
                            Credentials credentialsNew;
                            EthereumAddress myAddress;
                            var dbResponse =
                                await WalletSharedPreference.getWalletDetails();
                            print(_formFieldForPassword
                                .currentState?.value["password"]);
                            Wallet newWallet = Wallet.fromJson(
                                dbResponse!['walletEncryptedKey'].toString(),
                                _formFieldForPassword
                                    .currentState?.value["password"]);
                            credentialsNew = newWallet.privateKey;
                            myAddress = await credentialsNew.extractAddress();

                            try {
                              EthereumAddress patientAddress =
                              EthereumAddress.fromHex(algoliaPatientAddress);
                              estimateGasFunction(
                                  hashReceived,
                                  myAddress,
                                  patientAddress,
                                  _formPatient.currentState?.value["validTill"],
                                  credentialsNew);
                            } catch (error) {
                              _showErrorDialog("Check your details!");
                            }
                          
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
                ),
              ],
            )))
      ];

  Future<void> estimateGasFunction(
      String _prescriptionRecordHash,
      EthereumAddress doctorAddress,
      EthereumAddress patientAddress,
      DateTime expiryDateTime,
      Credentials credentials) async {
    var gasEstimation =
        await Provider.of<GasEstimationModel>(context, listen: false)
            .estimateGasForContractFunction(
                doctorAddress, "setPrescriptionRecord", [
      _prescriptionRecordHash,
      doctorAddress,
      patientAddress,
      expiryDateTime.toIso8601String()
    ]);
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
                                doctorAddress.hex.toString(),
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
                      executeTransaction(
                          _prescriptionRecordHash,
                          doctorAddress,
                          patientAddress,
                          expiryDateTime.toIso8601String(),
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
  }

  Future<void> executeTransaction(
      String _prescriptionRecordHash,
      EthereumAddress doctorAddress,
      EthereumAddress patientAddress,
      String expiryDateTime,
      Credentials credentials) async {
    var transactionHash = await Provider.of<WalletModel>(context, listen: false)
        .writeContract(
            "setPrescriptionRecord",
            [
              _prescriptionRecordHash,
              doctorAddress,
              patientAddress,
              expiryDateTime
            ],
            credentials);

    var firebaseStatus =
        await Provider.of<FirebaseModel>(context, listen: false)
            .storeTransaction(transactionHash);

    if (firebaseStatus) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: const Text("Prescription Generation"),
      // ),
      body: Center(
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _activeCurrentStep,
          steps: stepList(),
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: <Widget>[
                  TextButton(
                    onPressed: details.onStepContinue,
                    child: const Text('NEXT'),
                  ),
                ],
              ),
            );
          },
          onStepContinue: () {
            if (_activeCurrentStep < (stepList().length - 1)) {
              print(_activeCurrentStep);
              if (_activeCurrentStep == 0) {
                _formPatient.currentState?.save();

                if (_formPatient.currentState?.validate() != false) {
                  print(_formPatient.currentState?.value['patientAddress']);
                }
              }
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
            print(index);
            setState(() {
              _activeCurrentStep = index;
            });
          },
        ),
      ),
    );
  }
}

extension E on String {
  String lastCharc(int n) => substring(length - n);
}