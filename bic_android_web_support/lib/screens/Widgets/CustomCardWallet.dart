
import 'package:flutter/material.dart';

class CustomCardWallet extends StatelessWidget {

  final VoidCallback onPressed;
  final String cardText;
  final Widget imageAsset;

  const CustomCardWallet({
    required this.onPressed,
    required this.cardText,
    required this.imageAsset
  });



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
      child: SizedBox(
        width: 170,
        height: 155,
        child: GestureDetector(
          onTap: onPressed,
          child: Card(
            elevation: 4,
            borderOnForeground: true,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              // side: BorderSide(
              //     color: Theme.of(context).colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primaryVariant),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child:imageAsset,
                      ),
                    ),
                  ),

                 Expanded(
                   flex: 2,
                   child: Container(
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                       child: Text(this.cardText, textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13,color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold)),
                     ),
                   ),
                 ),


                  // ListTile(
                  //   trailing: Image.asset("assets/icons/forward-100.png",
                  //       color: Theme.of(context).primaryColor,
                  //       width: 25,
                  //       height: 25),
                  //   title:,
                  //   onTap: ,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}