import 'package:algolia/algolia.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helpers/Algolia.dart';
import '../../helpers/keys.dart' as keys;
import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import '../../model_class/hospital.dart';


class HospitalReadScreen extends StatefulWidget {
  static const routeName = '/hospital-screen';

  @override
  _HospitalReadScreenState createState() {
    return _HospitalReadScreenState();
  }
}

class _HospitalReadScreenState extends State<HospitalReadScreen> {
  Algolia algolia = Application.algolia;
  String algoliaHospitalAddress = "";
  String algoliaDoctorAddress = "";
  TextEditingController _textFieldController = TextEditingController();



  final _formKey = GlobalKey<FormBuilderState>();

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

    super.initState();
  }

  Future<void> fetchHospitalData(EthereumAddress address) async {

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

  Widget formBuilderTextFieldWidget(TextInputType inputTextType,
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
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 8,
                    right: 8,
                    bottom: 8),
                child: Card(
                  elevation: 4,
                  borderOnForeground: true,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(
                    //     color:
                    //     Theme.of(context).colorScheme.primary,
                    //     width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(

                    children: <Widget>[
                      FormBuilder(
                          key: _formKey,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: DropdownSearch<HospitalHit>(
                                  searchFieldProps: TextFieldProps(
                                    controller: _textFieldController,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _textFieldController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                  isFilteredOnline: true,
                                  label: "Hospital Address",
                                  selectedItem:HospitalHit(walletAddress: algoliaHospitalAddress==""?"Select Address":algoliaHospitalAddress, userEmail: '', registerOnce: '', userName: ''),


                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  onFind: (String? filter) async {
                                    print(filter);
                                    AlgoliaQuery query = algolia.instance
                                        .index('Hospitals')
                                        .query(filter!);
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
                                            ?.toString() ??
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
                                      algoliaHospitalAddress =
                                          data!.walletAddress.toString();
                                    });
                                    print(data?.walletAddress.toString());
                                  },
                                ),
                              ),
                              // Padding(
                              //     padding: const EdgeInsets.all(15),
                              //     child: formBuilderTextFieldWidget(
                              //         TextInputType.text,
                              //         '',
                              //         'address',
                              //         'Hospital Address',
                              //         Image.asset(
                              //             "assets/icons/key-100.png",
                              //             color: Theme
                              //                 .of(context)
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

                            ],
                          )),
                      ListTile(
                        trailing: Image.asset(
                            "assets/icons/forward-100.png",
                            color: Theme
                                .of(context)
                                .primaryColor,
                            width: 25,
                            height: 25),
                        title: Text('View Medical Record',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1),
                        onTap: () async {
                          _formKey.currentState?.save();
                          if (_formKey.currentState?.validate() !=
                              false) {
                            // Credentials credentialsNew;
                            // EthereumAddress myAddress;
                            // var dbResponse =
                            // await WalletSharedPreference
                            //     .getWalletDetails();
                            // print(_formKey
                            //     .currentState?.value["address"]);
                            // Wallet newWallet = Wallet.fromJson(
                            //     dbResponse!['walletEncryptedKey']
                            //         .toString(),
                            //     _formKey.currentState
                            //         ?.value["password"]);
                            // credentialsNew = newWallet.privateKey;
                            // myAddress = await credentialsNew
                            //     .extractAddress();
                            // uploadImage(credentialsNew, myAddress);
                            // String address = _formKey
                            //     .currentState?.value["address"];
                            // setState(() {
                            //   patientAddress;
                            // });
                            fetchHospitalData(EthereumAddress.fromHex(algoliaHospitalAddress));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              hospitalIpfsHashData.toString() == ''
                  ?  Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primaryVariant,
                          Theme.of(context).colorScheme.primary,
                        ],
                      )),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 40),
                        child: SvgPicture.asset(
                          "assets/images/undraw_doctor.svg",
                          height: 200,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "View Hospital\'s Data",
                            style: GoogleFonts.montserrat(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            "By Entering",
                            style: GoogleFonts.montserrat(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Their Wallet Address",
                            style: GoogleFonts.montserrat(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                              // ListTile(
                              //   leading: Image.asset(
                              //       "assets/icons/checked-user-male-100.png",
                              //       color: Theme.of(context)
                              //           .colorScheme
                              //           .primary,
                              //       width: 35,
                              //       height: 35),
                              //   title: Text("Role",
                              //       style: textStyleForName),
                              //   subtitle: Text(
                              //     role!,
                              //     style: GoogleFonts.montserrat(
                              //       color: Colors.black
                              //           .withOpacity(0.6),
                              //       fontSize: 15,
                              //     ),
                              //   ),
                              // ),
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


            ],
          ),
        ),
      ),
    );
  }
}
