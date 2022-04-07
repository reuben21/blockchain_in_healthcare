import 'package:flutter/material.dart';
import '../Widgets/CustomButtonGen.dart';
import '../screen_doctor/doctor_patient_medical_view.dart';
import '../screen_doctor/doctor_prescription_form.dart';
import '../screen_patient/patient_prescription_view.dart';

class PharmacyPrescriptionScreen extends StatefulWidget {
  static const routeName = '/pharmacy-prescription-screen';

  @override
  _PharmacyPrescriptionScreenState createState() {
    return _PharmacyPrescriptionScreenState();
  }
}

class _PharmacyPrescriptionScreenState
    extends State<PharmacyPrescriptionScreen> {
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

    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   title: const Text("Pharmacy Prescription"),
        // ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                CustomButtonGen(cardText:"View Medical Record For Patient",onPressed:()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DoctorPatientMedicalRecordView(),
                    ),
                  )
                },imageAsset:Image.asset(
                  "assets/icons/icons8-medical-history-100.png",
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),),
                CustomButtonGen(cardText:'View Prescriptions',onPressed:()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientPrescriptionViewGen(),
                    ),
                  )
                },imageAsset:Image.asset(
                  "assets/icons/icons8-file-prescription-100.png",
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),),
                CustomButtonGen(cardText:'Medicine Without Doctor\'s Prescription ',onPressed:()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorPrescriptionForm(),
                    ),
                  )
                },imageAsset:Image.asset(
                  "assets/icons/icons8-hand-with-a-pill-100.png",
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),),
              ],
            ),
          ),
          ),
        );
  }
}
