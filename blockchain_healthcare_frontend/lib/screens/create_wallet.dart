import 'package:blockchain_healthcare_frontend/providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateWallet extends StatelessWidget {
  CreateWallet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child:  Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text('Top'),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child:   HStack(
                  [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                      onPressed: () {
                        Provider.of<WalletModel>(context, listen: false)
                            .createWallet();
                      },
                      icon: const Icon(Icons.add_circle_outline_outlined),
                      label: const Text('Create Wallet'),
                    ),

                  ],
                  alignment: MainAxisAlignment.spaceAround,
                  axisSize: MainAxisSize.max,
                ),
              ),
            ),
          ],
        ),
        ),
    );
  }
}
