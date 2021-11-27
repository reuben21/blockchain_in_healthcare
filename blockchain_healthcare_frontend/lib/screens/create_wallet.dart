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
        child: ZStack([

          VStack([
            (context.percentHeight * 10).heightBox,
            "\$ Ethers 1".text.xl4.white.bold.center.makeCentered().py16(),
            (context.percentHeight * 3).heightBox,
            VxBox(
                child: VStack([
                  "Balance".text.black.xl2.semiBold.makeCentered(),
                  10.heightBox,
                  (" Ethers")
                      .text
                      .black
                      .xl2
                      .semiBold
                      .makeCentered(),
                ]))
                .p16
                .white
                .size(context.screenWidth, context.percentHeight * 18)
                .rounded
                .shadowXl
                .make()
                .p16(),
            400.heightBox,
            HStack(
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
            )
          ])
        ]),
      ),
    );
  }
}
