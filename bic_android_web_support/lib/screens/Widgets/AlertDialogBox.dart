import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';

void showDialogBox(BuildContext context,EthereumAddress walletAddress,Map gasEstimation,Future executeTransaction) {

  showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
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
                      onPressed:()=>
                        executeTransaction
                       ,
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
        );
      }
  );
}