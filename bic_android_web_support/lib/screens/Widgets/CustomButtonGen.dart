
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonGen extends StatelessWidget {

  final VoidCallback onPressed;
  final String cardText;
  final Widget imageAsset;

  const CustomButtonGen({
    required this.onPressed,
    required this.cardText,
    required this.imageAsset
  });



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          elevation: 4,
          borderOnForeground: true,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            // side: BorderSide(
            //     color: Theme.of(context).colorScheme.primary,
            //     width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryVariant,
                    Theme.of(context).colorScheme.primaryVariant,
                  ],
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryVariant),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: imageAsset,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          cardText,
                          style: GoogleFonts.montserrat(
                            color:
                            Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Image.asset(
                              "assets/icons/forward-100.png",
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              width: 30,
                              height: 30))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}