import 'package:bic_android_web_support/screens/screen_patient/patient_details.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_medical_record.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_medical_record_creation.dart';
import 'package:bic_android_web_support/screens/screen_patient/patient_medical_record_view.dart';
import 'package:bic_android_web_support/screens/screen_patient/prescription_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/keys.dart' as keys;
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/screen_pharmacy/pharmacy_store_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../Widgets/CustomButtonGen.dart';
import '../Widgets/CustomCard.dart';

class PatientMedicineScreen extends StatefulWidget {
  static const routeName = '/patient-record-screen';

  @override
  _PatientMedicineScreenState createState() {
    return _PatientMedicineScreenState();
  }
}

class _PatientMedicineScreenState extends State<PatientMedicineScreen> {
  String? role;
  late String patientName;
  late String patientIpfsHashData;
  late Map<String, dynamic> patientIpfsHash;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {


    super.initState();
  }




  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var textStyleForName = TextStyle(
        fontSize: 15, 
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary);

    var textStyleGoogleFont = GoogleFonts.montserrat(
      color: Colors.black.withOpacity(0.6),
      fontSize: 18,
    );        
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: const Text("Patient Record"),
      // ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // patientIpfsHash['patient_name'] == ''
              //       ?  Container(
              //     height: 800,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //           colors: [
              //             Theme.of(context).colorScheme.primary,
              //             Theme.of(context).colorScheme.primaryVariant,
              //           ],
              //         )),
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding:
              //           const EdgeInsets.symmetric(vertical: 80),
              //           child: SvgPicture.asset(
              //             "assets/images/undraw_secure.svg",
              //             height: 220,
              //           ),
              //         ),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Start By",
              //               style: GoogleFonts.montserrat(
              //                 color: Theme.of(context).colorScheme.secondary,
              //                 fontSize: 25,
              //               ),
              //             ),
              //             Text(
              //               "Registering Yourself",
              //               style: GoogleFonts.montserrat(
              //                 color: Theme.of(context).colorScheme.secondary,
              //                 fontSize: 25,
              //               ),
              //
              //             ),
              //             Text(
              //               "On the Blockchain",
              //               style: GoogleFonts.montserrat(
              //                 color: Theme.of(context).colorScheme.secondary,
              //                 fontSize: 25,
              //               ),
              //
              //             ),
              //           ],
              //         ),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.only(top: 30,right: 75),
              //               child: FloatingActionButton.extended(
              //                 heroTag: "registerOnBlockchain",
              //                 backgroundColor:
              //                 Theme.of(context).colorScheme.secondary,
              //                 foregroundColor:
              //                 Theme.of(context).colorScheme.primary,
              //                 onPressed: ()  {
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) => PatientStoreDetails(
              //                         patientName: patientIpfsHash['patient_name'],
              //                         patientHospitalAddress:
              //                         patientIpfsHash['patient_hospital_address'],
              //                         patientDoctorAddress:
              //                         patientIpfsHash['patient_doctor_address'],
              //                         patientAddress: patientIpfsHash['patient_address'],
              //                         patientAge: patientIpfsHash['patient_age'],
              //                         patientPhoneNo: patientIpfsHash['patient_phone_no'],
              //                       ),
              //                     ),
              //                   );
              //                 },
              //                 // icon: Image.asset(
              //                 //     "assets/icons/registration-100.png",
              //                 //     color: Theme.of(context).colorScheme.secondary,
              //                 //     width: 25,
              //                 //     fit: BoxFit.fill,
              //                 //     height: 25),
              //                 label: Text('Register Now',style: GoogleFonts.montserrat(
              //                   color: Theme.of(context).colorScheme.primary,
              //                   fontSize: 18,
              //                 ) ,),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ):
               Column(
                    children: [

                      CustomButtonGen(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientMedicalRecords(),
                            ),
                          )
                        },
                        imageAsset:
                        Image.asset("assets/icons/icons8-treatment-100.png",
                            color: Theme.of(context).primaryColor,
                            width: 20,
                            height: 20),
                        cardText: 'Store Medical Records',
                      ),
                      CustomButtonGen(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientMedicalRecordView(),
                            ),
                          )
                        },
                        imageAsset:
                        Image.asset("assets/icons/icons8-medical-history-100.png",
                            color: Theme.of(context).primaryColor,
                            width: 20,
                            height: 20) ,
                        cardText: 'View Medical Records',
                      ),
                      CustomButtonGen(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrescriptionScreen(),
                            ),
                          )
                        },
                        imageAsset:
                        Image.asset("assets/icons/icons8-file-prescription-100.png",
                            color: Theme.of(context).primaryColor,
                            width: 20,
                            height: 20) ,
                        cardText: 'View Prescriptions',
                      ),
                    ],
                  ),



              // SizedBox(
              //   width: double.infinity,
              //   height: 400,
              //   child: GridView.count(
              //     primary: false,
              //     padding: const EdgeInsets.all(20),
              //     crossAxisSpacing: 10,
              //     mainAxisSpacing: 10,
              //     crossAxisCount: 2,
              //     children: <Widget>[
              //       CustomCard(
              //         onPressed: () => {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => PatientStoreDetails(
              //                 patientName: patientIpfsHash['patient_name'],
              //                 patientHospitalAddress:
              //                 patientIpfsHash['patient_hospital_address'],
              //                 patientDoctorAddress:
              //                 patientIpfsHash['patient_doctor_address'],
              //                 patientAddress: patientIpfsHash['patient_address'],
              //                 patientAge: patientIpfsHash['patient_age'],
              //                 patientPhoneNo: patientIpfsHash['patient_phone_no'],
              //               ),
              //             ),
              //           )
              //         },
              //         imageAsset: Image.asset("assets/icons/icons8-user-shield-100.png",
              //             color: Theme.of(context).primaryColor,
              //             width: 20,
              //             height: 20) ,
              //         cardText: 'Store or Update Patient on Blockchain',
              //       ),
              //       CustomCard(
              //         onPressed: () => {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => PatientMedicalRecordView(),
              //             ),
              //           )
              //         },
              //         imageAsset:
              //         Image.asset("assets/icons/icons8-medical-history-100.png",
              //             color: Theme.of(context).primaryColor,
              //             width: 20,
              //             height: 20) ,
              //         cardText: 'View Medical Records',
              //       ),
              //       CustomCard(
              //         onPressed: () => {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => PatientMedicalRecords(),
              //             ),
              //           )
              //         },
              //         imageAsset:
              //         Image.asset("assets/icons/icons8-treatment-100.png",
              //             color: Theme.of(context).primaryColor,
              //             width: 20,
              //             height: 20),
              //         cardText: 'Store Medical Records',
              //       ),
              //     ].toList(),
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}