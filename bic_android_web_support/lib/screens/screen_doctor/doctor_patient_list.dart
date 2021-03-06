import 'package:bic_android_web_support/screens/screen_hospital/grant_access_to_patient_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../databases/wallet_shared_preferences.dart';
import '../../helpers/http_exception.dart' as exception;
import '../../helpers/keys.dart' as keys;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class DoctorPatientList extends StatefulWidget {
  static const routeName = '/hospital-access-list';

  @override
  _DoctorPatientListState createState() => _DoctorPatientListState();
}

class _DoctorPatientListState extends State<DoctorPatientList> {
  final String screenName = "view_wallet.dart";
  FirebaseAuth auth = FirebaseAuth.instance;
  firestore.CollectionReference? users;
  String? walletAddress;

  Future<firestore.CollectionReference?> getFirestoreDocument(
      String userType) async {
    if (userType == 'Patient') {
      firestore.CollectionReference patientFirestore =
      firestore.FirebaseFirestore.instance.collection('Patient');
      return patientFirestore;
    } else if (userType == 'Doctor') {
      firestore.CollectionReference doctorFirestore =
      firestore.FirebaseFirestore.instance.collection('Doctor');
      return doctorFirestore;
    } else if (userType == 'Hospital') {
      firestore.CollectionReference hospitalFirestore =
      firestore.FirebaseFirestore.instance.collection('Hospital');
      return hospitalFirestore;
    } else if (userType == 'Pharmacy') {
      firestore.CollectionReference pharmacyFirestore =
      firestore.FirebaseFirestore.instance.collection('Pharmacy');
      return pharmacyFirestore;
    }

    return null;
  }

  Future<void> getCollectionReferenceData() async {
    String? userType = await WalletSharedPreference.getUserType();
    var walletDetails = await WalletSharedPreference.getWalletDetails();
    users = await getFirestoreDocument(userType!);
    setState(() {
      users;
      walletAddress = walletDetails!['walletAddress'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[]),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: users
              ?.doc(walletAddress)
              .collection("PatientList")
              .limit(10)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                final documents = snapshot.data?.docs;
                print(documents?.length.toString());
                return SizedBox(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: documents?.length,
                        itemBuilder: (BuildContext context, int position) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              borderOnForeground: true,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color:
                                    Theme.of(context).colorScheme.primary,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    trailing: Image.asset(
                                        "assets/icons/forward-100.png",
                                        color: Theme.of(context).primaryColor,
                                        width: 25,
                                        height: 25),
                                    title: Text(
                                        '${documents![position]['address']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    subtitle: Text(
                                        '${documents[position]['patientName']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    onTap: () {
                                      // documents[position]['userType'] ==
                                      //     "Patient"
                                      //     ? Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         GrantRoleScreenPatient(),
                                      //   ),
                                      // )
                                      //     : Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         GrantRoleScreen(),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }
            }
            return const Center(
              child: Text('No Transactions Found As Of Yet'),
            );
          },
        ),
      ),
    );
  }
}



