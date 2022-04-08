import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart';
import '../../helpers/keys.dart' as keys;
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:bic_android_web_support/screens/screen_hospital/hospital_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import '../Tabs/access_tab.dart';
import '../Widgets/CustomButtonGen.dart';
import '../Widgets/CustomButtonGenBadge.dart';


class HospitalScreen extends StatefulWidget {
  static const routeName = '/hospital-screen';

  @override
  _HospitalScreenState createState() {
    return _HospitalScreenState();
  }
}

class _HospitalScreenState extends State<HospitalScreen> {
  String? role;
  late String hospitalName;
  late String patientCount;
  late String doctorCount;
  late String hospitalIpfsHashData;
  late Map<String, dynamic> hospitalIpfsHash;

  @override
  void initState() {
    role = '';
    hospitalName = '';
    patientCount = '';
    doctorCount = '';
    hospitalIpfsHashData = '';
    hospitalIpfsHash = {
      "hospital_name": "",
      "hospital_age": "",
      "hospital_address": "",
      "hospital_gender": "",
      "hospital_phone_no": "",
    };
    fetchHospitalData();
    super.initState();
  }

  Future<void> fetchHospitalData() async {
    Credentials credentialsNew;
    EthereumAddress address;

    credentialsNew =
        Provider.of<WalletModel>(context, listen: false).walletCredentials;
    address = await credentialsNew.extractAddress();
    print(address);
    var dataRole = await Provider.of<WalletModel>(context, listen: false)
        .readContract("getRoleForUser", [address]);
    print("Role Status -" + dataRole.toString());

    var data = await Provider.of<WalletModel>(context, listen: false)
        .readContract("getHospitalData", [address]);
    print(data);
    // print(data[0]);
    if (data[0].toString() != '') {
      var hospitalData = await Provider.of<IPFSModel>(context, listen: false)
          .receiveData(data[1]);
      print(hospitalData);
      setState(() {
        hospitalName = data[0].toString();
        hospitalIpfsHashData = data[1].toString();
        hospitalIpfsHash = hospitalData!;
        role = dataRole[0].toString();
        patientCount = data[4].toString();
        doctorCount = data[3].toString();
      });
    } else {
      setState(() {
        hospitalName = data[0];
      });
    }
  }

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    var textStyleForName = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary);

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: Center(child: const Text("Hospital Record")),
      // ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              hospitalIpfsHashData.toString() == ''
                  ?  Container(
                            height: 800,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primaryVariant,
                              ],
                            )),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 80),
                                  child: SvgPicture.asset(
                                    "assets/images/undraw_secure.svg",
                                    height: 220,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Start By",
                                      style: GoogleFonts.montserrat(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      "Registering Yourself",
                                      style: GoogleFonts.montserrat(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 25,
                                      ),

                                    ),
                                    Text(
                                      "On the Blockchain",
                                      style: GoogleFonts.montserrat(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 25,
                                      ),

                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30,right: 75),
                                      child: FloatingActionButton.extended(
                                        heroTag: "registerOnBlockchain",
                                        backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                        foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                        onPressed: ()  {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HospitalDetailScreen(
                                                // hospitalName: hospitalIpfsHash['hospital_name'],
                                                // hospitalAge: hospitalIpfsHash['hospital_age'],
                                                // hospitalAddress:
                                                // hospitalIpfsHash['hospital_address'],
                                                // hospitalGender: hospitalIpfsHash['hospital_gender'],
                                                // hospitalPhoneNo:
                                                // hospitalIpfsHash['hospital_phone_no'],
                                              ),
                                            ),
                                          );
                                        },
                                        // icon: Image.asset(
                                        //     "assets/icons/registration-100.png",
                                        //     color: Theme.of(context).colorScheme.secondary,
                                        //     width: 25,
                                        //     fit: BoxFit.fill,
                                        //     height: 25),
                                        label: Text('Register Now',style: GoogleFonts.montserrat(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 18,
                                        ) ,),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )

                  : Container(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 125,
                                width: 185,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    // side: BorderSide(
                                    //     color: Theme.of(context)
                                    //         .colorScheme
                                    //         .primary,
                                    //     width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          patientCount,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Image.asset(
                                          "assets/icons/patient-count-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 50,
                                          height: 50),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Patient's in Hospital",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 125,
                                width: 185,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    // side: BorderSide(
                                    //     color: Theme.of(context)
                                    //         .colorScheme
                                    //         .primary,
                                    //     width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          doctorCount,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Image.asset(
                                          "assets/icons/doctor-count-100.png",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 50,
                                          height: 50),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Doctor's in Hospital",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Divider(
                          //   height: 20,
                          //   thickness: 2,
                          //   indent: 15,
                          //   endIndent: 15,
                          //   color: Theme.of(context).colorScheme.primary,
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: double.infinity,
                              height: 380,
                              child: hospitalIpfsHash['hospitalName'] == ''
                                  ? Card(
                                      borderOnForeground: true,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        // side: BorderSide(
                                        //     color: Theme.of(context)
                                        //         .colorScheme
                                        //         .primary,
                                        //     width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const ListTile(
                                        leading:
                                            Icon(Icons.arrow_drop_down_circle),
                                        title: Text(
                                          "Not Registered on Blockchain",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    )
                                  : Card(
                                      borderOnForeground: true,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        // side: BorderSide(
                                        //     color: Theme.of(context)
                                        //         .colorScheme
                                        //         .primary,
                                        //     width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Image.asset(
                                                "assets/icons/checked-user-male-100.png",
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 35,
                                                height: 35),
                                            title: Text("Role",
                                                style: textStyleForName),
                                            subtitle: Text(
                                              role!,
                                              style: GoogleFonts.montserrat(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            leading: Image.asset(
                                                "assets/icons/hospital-count-100.png",
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 35,
                                                height: 35),
                                            title: Text('Hospital Name',
                                                style: textStyleForName),
                                            subtitle: Text(
                                              hospitalName,
                                              style: GoogleFonts.montserrat(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            leading: Image.asset(
                                                "assets/icons/address-100.png",
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 35,
                                                height: 35),
                                            title: Text('Address',
                                                style: textStyleForName),
                                            subtitle: Text(
                                              hospitalIpfsHash['address'],
                                              style: GoogleFonts.montserrat(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: ListTile(
                                                  leading: Image.asset(
                                                      "assets/icons/year-view-100.png",
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      width: 35,
                                                      height: 35),
                                                  title: Text(
                                                    'Origin',
                                                    style: textStyleForName,
                                                  ),
                                                  subtitle: Text(
                                                    hospitalIpfsHash['origin']
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: ListTile(
                                                  leading: Image.asset(
                                                      "assets/icons/phone-100.png",
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      width: 35,
                                                      height: 35),
                                                  title: Text('Phone No',
                                                      style: textStyleForName),
                                                  subtitle: Text(
                                                    hospitalIpfsHash[
                                                            'hospitalPhoneNo']
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ListTile(
                                            leading: Image.asset(
                                                "assets/icons/storage-100.png",
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 35,
                                                height: 35),
                                            title: Text('IPFS Hash',
                                                style: textStyleForName),
                                            subtitle: Text(
                                              hospitalIpfsHashData,
                                              style: GoogleFonts.montserrat(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 15,
                                              ),
                                            ),
                                            onTap: () {
                                              String _url =
                                                  "${keys.getIpfsUrlForReceivingData}$hospitalIpfsHashData";
                                              _launchURL(_url);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
              // Divider(
              //   height: 20,
              //   thickness: 2,
              //   indent: 15,
              //   endIndent: 15,
              //   color: Theme.of(context).colorScheme.primary,
              // ),
              SizedBox(
                height: 10,
              ),

              hospitalIpfsHashData.toString() == ''
                  ? Container()
                  :
              Column(
                children: [
                  CustomButtonGen(cardText:'Store or Update Hospital on Blockchain',onPressed:()=>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HospitalDetailScreen(
                          // hospitalName: hospitalIpfsHash['hospital_name'],
                          // hospitalAge: hospitalIpfsHash['hospital_age'],
                          // hospitalAddress:
                          // hospitalIpfsHash['hospital_address'],
                          // hospitalGender: hospitalIpfsHash['hospital_gender'],
                          // hospitalPhoneNo:
                          // hospitalIpfsHash['hospital_phone_no'],
                        ),
                      ),
                    )
                  },imageAsset:Image.asset(
                    "assets/icons/icons8-hospital-3-100.png",
                    color: Theme.of(context).primaryColor,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),),
                ],
              ),
          CustomButtonGen(cardText:'Users To Approve',onPressed:()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccessTabs()),
                  )
                },imageAsset:Image.asset(
                  "assets/icons/icons8-tasklist-100.png",
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),),
              ]),

          ),
        ),
      );

  }
}
