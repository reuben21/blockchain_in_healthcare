import 'package:bic_android_web_support/providers/gas_estimation.dart';
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/provider_firebase/model_firebase.dart';
import 'package:bic_android_web_support/providers/provider_pharmacy/model_pharmacy.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/Tabs/tabs_screen.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';
import '../Widgets/TimerCountdown.dart';

class PatientPrescriptionSingleScreen extends StatefulWidget {
  static const routeName = '/patient-medical-records';

  int recordNumber;
  EthereumAddress walletAddress;

  PatientPrescriptionSingleScreen(
      {required this.recordNumber, required this.walletAddress});

  @override
  _PatientPrescriptionSingleScreenState createState() =>
      _PatientPrescriptionSingleScreenState();
}

class _PatientPrescriptionSingleScreenState
    extends State<PatientPrescriptionSingleScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  String walletAdd = '';
  String medicalRecordHash = '';
  BigInt medicalRecordCount = BigInt.from(0);
  String dateTime = " ";

  List<Map<String, dynamic>> medicineList = [];

  // File file

  @override
  void initState() {
    // This captures errors reported by the FLUTTER framework.
    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    FlutterError.onError = (FlutterErrorDetails details) {
      print("CAUGHT FLUTTER ERROR");
      // Send report
      // NEVER REACHES HERE - WHY?
    };
    getWalletFromDatabase();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  Future<void> getWalletFromDatabase() async {
    Credentials credentialsNew;
    EthereumAddress address;

    credentialsNew =
        Provider.of<WalletModel>(context, listen: false).walletCredentials;
    address = await credentialsNew.extractAddress();

    var data = await Provider.of<PharmacyModel>(context, listen: false)
        .readContract("getPrescriptions",
            [widget.walletAddress, BigInt.from(widget.recordNumber)]);
    // print(data);
    if (data[0].toString() != '') {
      var hospitalData = await Provider.of<IPFSModel>(context, listen: false)
          .receiveData(data[0][1].toString());
      print(hospitalData);

      List<Map<String, dynamic>> medicineList1 = [];

      hospitalData!['medicineList']
          .forEach((value) => {medicineList1.add(value)});
      setState(() {
        medicineList = medicineList1;
      });
      setState(() {
        walletAdd = address.hex.toString();
        medicalRecordCount = data[0][0];
        medicalRecordHash = data[0][1].toString();
        dateTime = hospitalData["validTill"];
      });
    } else {}

    // print(hospitalData);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textStyleForName = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary);



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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 110,
                      ),
                      ListTile(
                        title: Text(
                          "Prescription Expiry In",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),

                      TimerCountdown(
                        format: CountDownTimerFormat.daysHoursMinutesSeconds,
                        endTime:  DateTime.parse(dateTime) ,
                        timeTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        colonsTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        descriptionTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                        ),
                        spacerWidth: 20,
                        daysDescription: "Days",
                        hoursDescription: "Hours",
                        minutesDescription: "Minutes",
                        secondsDescription: "Seconds",
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Card(
                        // color: Color.fromRGBO(0, 0, 0,0),
                        borderOnForeground: true,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //     color: Theme.of(context).colorScheme.primary,
                          //     width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "Prescription Record ID: ${medicalRecordCount.toString()}",
                                style: textStyleForName,
                              ),
                              subtitle: Text(
                                "Medicine Prescribed: ",
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 300,
                              child: Column(
                                children: <Widget>[

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
                                            padding: const EdgeInsets.all(8.0),
                                            child:  Container(
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
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        borderOnForeground: true,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //     color: Theme.of(context).colorScheme.primary,
                          //     width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            "Expiry Date: ",
                            style: textStyleForName,
                          ),
                          subtitle: Text(

                            DateTime.parse(dateTime.toString()).day.toString()
                                +"/"+
                                DateTime.parse(dateTime.toString()).month.toString()
                                +"/"
                                +DateTime.parse(dateTime.toString()).year.toString() ,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red.withOpacity(0.6)),
                          ),
                        ),
                      ),
                    ],
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


bool isDate(String input, String format) {
  try {
    final DateTime d = DateFormat(format).parseStrict(input);
    //print(d);
    return true;
  } catch (e) {
    //print(e);
    return false;
  }
}

// bool isDate(String str) {
//   try {
//     DateTime.parse(str);
//     return true;
//   } catch (e) {
//     return false;
//   }
// }