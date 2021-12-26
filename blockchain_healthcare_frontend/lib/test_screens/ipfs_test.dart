import 'package:blockchain_healthcare_frontend/providers/ipfs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Ipfs_screen extends StatelessWidget {
  // Ipfs_screen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          await Provider.of<IPFSModel>(context, listen: false)
                              .sendData();

                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Send Data'),
                      ),
                      FloatingActionButton.extended(
                        backgroundColor:
                        Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          // Respond to button press
                          await Provider.of<IPFSModel>(context, listen: false)
                              .receiveData();
                        },
                        icon: const Icon(Icons.call_made_outlined),
                        label: const Text('Receive Data'),
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
    );;
  }
}
