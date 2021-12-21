import 'dart:convert';
import 'dart:io' show Platform;
import 'package:blockchain_healthcare_frontend/databases/wallet_database.dart';
import 'package:blockchain_healthcare_frontend/providers/wallet.dart';
import 'package:blockchain_healthcare_frontend/screens/transfer_screen.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import 'package:blockchain_healthcare_frontend/helpers/http_exception.dart'
    as exception;

class WalletView extends StatefulWidget {
  static const routeName = '/view-wallet';

  @override
  _WalletViewState createState() {
    return _WalletViewState();
  }
}

class _WalletViewState extends State<WalletView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  CarouselController buttonCarouselController = CarouselController();

  Credentials credentials;
  EthereumAddress myAddress;
  String balanceOfAccount;

  List<String> options = <String>['Select Account'];
  String dropdownValue = 'Select Account';
  String dropDownCurrentValue;
  String scannedAddress;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller.resumeCamera();
  //   }
  // }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    getWalletFromDatabase();
    super.didChangeDependencies();
  }

  Future<void> getWalletFromDatabase() async {
    var dbResponse = await DBProviderWallet.db.getWallet;
    dbResponse.forEach((element) {
      options.add(element['walletAddress']);
      setState(() {
        options;
      });
    });
  }

  Future<void> getAccountBalance(String walletAddress) async {
    var dbResponse =
        await DBProviderWallet.db.getWalletByWalletAddress(walletAddress);
    // final wallet = Wallet.fromJson(dbResponse['walletDecryptedKey'].toString(), dbResponse['walletPassword']);
    // print(wallet.privateKey);
    // credentials = await wallet.privateKey;
    // myAddress = await credentials.extractAddress();
    // print(myAddress.hex);
    var balance = await Provider.of<WalletModel>(context, listen: false)
        .getAccountBalance(EthereumAddress.fromHex(walletAddress));
    setState(() {
      balanceOfAccount = balance.getInEther.toString();
    });
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

  void _submit(String password) async {
    try {
      // TODO: WALLET CREATION
      await Provider.of<WalletModel>(context, listen: false)
          .createWallet(password);

      _showErrorDialog("Wallet Has Been Created");
      Navigator.of(context).pushNamed(WalletView.routeName);
    } on exception.HttpException catch (error) {
      _showErrorDialog(error.toString());
    }
  }



  @override
  void dispose() {

    super.dispose();
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: <Widget>[]),
        body: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              ZStack([
                Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    // const Image(image: AssetImage('assets/ethereum.png')),
                    // (context.percentHeight * 10).heightBox,
                    // "\$ Ethers 1".text.xl4.white.bold.center.makeCentered().py16(),
                    // Image(
                    //     image: new AssetImage("assets/icons/ethereum.png"),
                    //     height: 100,
                    //     width: MediaQuery.of(context).size.width,
                    //     fit: BoxFit.cover,
                    //     // scale: 0.8
                    //
                    //     // fit: BoxFit.fitHeight,
                    //     ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CarouselSlider.builder(
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/icons/ethereum.png'),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                balanceOfAccount == null
                                    ? "0"
                                    : "$balanceOfAccount ETH",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                            aspectRatio: 2.0,
                            initialPage: 2,
                          ),
                        ),
                        DropdownButton<String>(
                            focusColor: Theme.of(context).colorScheme.secondary,
                            dropdownColor:
                                Theme.of(context).colorScheme.primary,
                            value: dropdownValue,
                            selectedItemBuilder: (BuildContext context) {
                              return options.map((String value) {
                                if (value == "Select Account") {
                                  return Text(
                                    "Select Account",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  );
                                } else {
                                  return Text(
                                    dropdownValue.toString().substring(0, 5) +
                                        "..." +
                                        dropdownValue.toString().lastChars(5),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  );
                                }
                              }).toList();
                            },
                            items: options
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: value == "Select Account"
                                    ? const Text("Select Account")
                                    : Text(value.toString().substring(0, 5) +
                                        "..." +
                                        value.toString().lastChars(5)),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              buttonCarouselController.animateToPage(
                                  options.indexOf(newValue),
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.linear);
                              setState(() {
                                dropdownValue = newValue;
                                dropDownCurrentValue = newValue;
                              });
                              getAccountBalance(newValue);
                              print(newValue);
                            },
                            style: Theme.of(context).textTheme.headline5,
                            hint: const Text("Select Account")),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    HStack(
                      [
                        FloatingActionButton.extended(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransferScreen(address: dropDownCurrentValue,),
                              ),
                            );
                          },
                          icon: const Icon(Icons.call_made_outlined),
                          label: const Text('Send'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            const snackBar = const SnackBar(
                                content: Text('Balance Refreshed'));
                            await getAccountBalance(dropDownCurrentValue);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: Icon(Icons.refresh,
                              color: Theme.of(context).colorScheme.primary),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(14),
                            primary: Theme.of(context).colorScheme.secondary,
                            onPrimary: Colors.black,
                          ),
                        ),
                        FloatingActionButton.extended(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                title: Text(
                                  "Show the QR Code",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                content: Container(
                                  width: 200,
                                  height: 240,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        QrImage(
                                          data: dropDownCurrentValue ==
                                                  "Select Account"
                                              ? ""
                                              : "ethereum:" +
                                                  dropDownCurrentValue,
                                          version: QrVersions.auto,
                                          size: 200.0,
                                        ),
                                        Text(dropDownCurrentValue)
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text("okay"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Receive'),
                        ),
                      ],
                      alignment: MainAxisAlignment.spaceAround,
                      axisSize: MainAxisSize.max,
                    )
                  ],
                ),
              ]),
              10.heightBox,
              Expanded(
                child: SizedBox(
                  height: 200.0,
                  child: ListView(
                    children: const [
                      Card(
                        elevation: 0.0,
                        child: ListTile(
                          leading: Icon(Icons.download_done),
                          title: Text(
                            'Received',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'From: 0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          trailing: Text('+ 0,0012 ETH'),
                        ),
                      ),
                      Card(
                        elevation: 0.0,
                        child: ListTile(
                          leading: Icon(Icons.download_done),
                          title: Text(
                            'Received',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          trailing: Text('+ 2 ETH'),
                        ),
                      ),
                      Card(
                        elevation: 0.0,
                        child: ListTile(
                          leading: Icon(Icons.download_done),
                          title: Text(
                            'Sent',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '0xE1ab66A6f9157b  02C32DE2682B0Fea298eA0b3eE',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          trailing: Text('- 0,003 ETH'),
                        ),
                      ),
                      Card(
                        elevation: 0.0,
                        child: ListTile(
                          leading: Icon(Icons.download_done),
                          title: Text(
                            'Recieved',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          trailing: Text('+ 0,0220 ETH'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
    return Scaffold(
        body: Builder(
            // builder is used only for the snackbar, if you don't want the snackbar you can remove
            // Builder from the tree
            builder: (BuildContext context) => HawkFabMenu(
                  icon: AnimatedIcons.menu_arrow,
                  fabColor: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.secondary,
                  items: [
                    HawkFabMenuItem(
                      ontap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            title: Text(
                              "Add Another Account",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            content: Container(
                              width: 200,
                              height: 150,
                              child: Column(
                                children: [
                                  Center(
                                    child: FormBuilder(
                                        key: _formKey,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        child: Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: FormBuilderTextField(
                                              maxLines: 1,
                                              name: 'password',
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                prefixIcon:
                                                    Icon(Icons.password),
                                                border: OutlineInputBorder(),
                                                labelStyle: TextStyle(
                                                  color: Color(0xFF6200EE),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFF6200EE)),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFF6200EE)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFF6200EE)),
                                                ),
                                              ),

                                              // valueTransformer: (text) => num.tryParse(text),
                                              validator: FormBuilderValidators
                                                  .compose([
                                                FormBuilderValidators.required(
                                                    context),
                                                FormBuilderValidators.maxLength(
                                                    context, 15)
                                              ]),
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState.save();
                                  if (_formKey.currentState.validate()) {
                                    _submit(_formKey
                                        .currentState.value["password"]);
                                  }
                                  Navigator.of(ctx).pop();
                                },
                                child: Text("Add"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_outlined),
                      color: Theme.of(context).colorScheme.primary,
                      label: 'Add Account',
                    ),
                  ],
                  body: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      children: [
                        ZStack([
                          Column(
                            children: [
                              const SizedBox(
                                height: 80,
                              ),
                              // const Image(image: AssetImage('assets/ethereum.png')),
                              // (context.percentHeight * 10).heightBox,
                              // "\$ Ethers 1".text.xl4.white.bold.center.makeCentered().py16(),
                              // Image(
                              //     image: new AssetImage("assets/icons/ethereum.png"),
                              //     height: 100,
                              //     width: MediaQuery.of(context).size.width,
                              //     fit: BoxFit.cover,
                              //     // scale: 0.8
                              //
                              //     // fit: BoxFit.fitHeight,
                              //     ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CarouselSlider.builder(
                                    itemCount: options.length,
                                    itemBuilder: (BuildContext context,
                                            int itemIndex, int pageViewIndex) =>
                                        Column(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/icons/ethereum.png'),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          balanceOfAccount == null
                                              ? "0"
                                              : "$balanceOfAccount ETH",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    carouselController:
                                        buttonCarouselController,
                                    options: CarouselOptions(
                                      autoPlay: false,
                                      enlargeCenterPage: true,
                                      viewportFraction: 0.9,
                                      aspectRatio: 2.0,
                                      initialPage: 2,
                                    ),
                                  ),
                                  DropdownButton<String>(
                                      focusColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      dropdownColor:
                                          Theme.of(context).colorScheme.primary,
                                      value: dropdownValue,
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return options.map((String value) {
                                          if (value == "Select Account") {
                                            return Text(
                                              "Select Account",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            );
                                          } else {
                                            return Text(
                                              dropdownValue
                                                      .toString()
                                                      .substring(0, 5) +
                                                  "..." +
                                                  dropdownValue
                                                      .toString()
                                                      .lastChars(5),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            );
                                          }
                                        }).toList();
                                      },
                                      items: options
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: value == "Select Account"
                                              ? const Text("Select Account")
                                              : Text(value
                                                      .toString()
                                                      .substring(0, 5) +
                                                  "..." +
                                                  value
                                                      .toString()
                                                      .lastChars(5)),
                                        );
                                      }).toList(),
                                      onChanged: (String newValue) {
                                        buttonCarouselController.animateToPage(
                                            options.indexOf(newValue),
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                        setState(() {
                                          dropdownValue = newValue;
                                          dropDownCurrentValue = newValue;
                                        });
                                        getAccountBalance(newValue);
                                        print(newValue);
                                      },
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      hint: const Text("Select Account")),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              HStack(
                                [
                                  FloatingActionButton.extended(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () {
                                      // Respond to button press
                                    },
                                    icon: const Icon(Icons.call_made_outlined),
                                    label: const Text('Send'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      const snackBar = const SnackBar(
                                          content: Text('Balance Refreshed'));
                                      await getAccountBalance(
                                          dropDownCurrentValue);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: Icon(Icons.refresh,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(14),
                                      primary: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onPrimary: Colors.black,
                                    ),
                                  ),
                                  FloatingActionButton.extended(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          title: Text(
                                            "Show the QR Code",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          content: Container(
                                            width: 200,
                                            height: 200,
                                            child: Center(
                                              child: QrImage(
                                                data: dropDownCurrentValue ==
                                                        "Select Account"
                                                    ? ""
                                                    : dropDownCurrentValue,
                                                version: QrVersions.auto,
                                                size: 200.0,
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Text("okay"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.call_received),
                                    label: const Text('Receive'),
                                  ),
                                ],
                                alignment: MainAxisAlignment.spaceAround,
                                axisSize: MainAxisSize.max,
                              )
                            ],
                          ),
                        ]),
                        10.heightBox,
                        Expanded(
                          child: SizedBox(
                            height: 200.0,
                            child: ListView(
                              children: const [
                                Card(
                                  elevation: 0.0,
                                  child: ListTile(
                                    leading: Icon(Icons.download_done),
                                    title: Text(
                                      'Received',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'From: 0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                    trailing: Text('+ 0,0012 ETH'),
                                  ),
                                ),
                                Card(
                                  elevation: 0.0,
                                  child: ListTile(
                                    leading: Icon(Icons.download_done),
                                    title: Text(
                                      'Received',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                    trailing: Text('+ 2 ETH'),
                                  ),
                                ),
                                Card(
                                  elevation: 0.0,
                                  child: ListTile(
                                    leading: Icon(Icons.download_done),
                                    title: Text(
                                      'Sent',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '0xE1ab66A6f9157b  02C32DE2682B0Fea298eA0b3eE',
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                    trailing: Text('- 0,003 ETH'),
                                  ),
                                ),
                                Card(
                                  elevation: 0.0,
                                  child: ListTile(
                                    leading: Icon(Icons.download_done),
                                    title: Text(
                                      'Recieved',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '0xE1ab66A6f9157b02C32DE2682B0Fea298eA0b3eE',
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                    trailing: Text('+ 0,0220 ETH'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )));
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
