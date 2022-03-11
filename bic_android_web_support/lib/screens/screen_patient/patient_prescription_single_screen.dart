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
      // print(hospitalData);

      List<Map<String, dynamic>> medicineList1 = [];

      hospitalData!['medicineList']
          .forEach((value) => {medicineList1.add(value)});
      setState(() {
        medicineList = medicineList1;
      });
    } else {}
    setState(() {
      walletAdd = address.hex.toString();
      medicalRecordCount = data[0][0];
      medicalRecordHash = data[0][1].toString();
      dateTime = data[0][2];
    });
    print(medicineList);
  }

  Future<void> estimateGasFunction(String medicalRecordHash,
      EthereumAddress walletAddress, Credentials credentials) async {
    var gasEstimation =
        await Provider.of<GasEstimationModel>(context, listen: false)
            .estimateGasForContractFunction(
                walletAddress,
                "setMedicalRecordByPatient",
                [medicalRecordHash, walletAddress]);
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
                      executeTransaction(
                          medicalRecordHash, walletAddress, credentials);
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

  Future<void> executeTransaction(String medicalRecordHash,
      EthereumAddress walletAddress, Credentials credentials) async {
    var transactionHash =
        await Provider.of<PharmacyModel>(context, listen: false).writeContract(
            "setMedicalRecordByPatient",
            [
              medicalRecordHash,
              walletAddress,
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
                        endTime: DateTime.parse(dateTime.toString()),
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
                        borderOnForeground: true,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
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
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 10),
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
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0)),
                                        child: Container(
                                          height: 50,
                                          width: 130,
                                          color: Theme.of(context).primaryColor,
                                          child: const Center(
                                              child: Text('Medicine Time')),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 50,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 28, top: 2),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5, top: 2),
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
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
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
                                +DateTime.parse(dateTime.toString()).year.toString(),
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
