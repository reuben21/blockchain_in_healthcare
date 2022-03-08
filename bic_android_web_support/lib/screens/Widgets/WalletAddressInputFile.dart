import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class WalletAddressInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  
  WalletAddressInputField({
   required this.controller,
   this.hintText = 'Wallet Address'
  });



  @override
  State<StatefulWidget> createState() {
    return WalletAddressInputFieldState();
  }
}

class WalletAddressInputFieldState extends State<WalletAddressInputField> {
  bool _showClearButton = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _showClearButton = widget.controller.text.length > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,

      decoration: InputDecoration(
     hintText: widget.hintText,
        suffixIcon: _getClearButton(),
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
    );
  }

  Future<String> scanBarcode() async {
    String scanResult;

    scanResult = await FlutterBarcodeScanner.scanBarcode("#ff6666","Cancel" , false, ScanMode.QR);

    setState(() {
      widget.controller.text=scanResult;
    });

    return scanResult;
  }

  Widget? _getClearButton() {
    if (!_showClearButton) {
      return null;
    }

    return IconButton(
      onPressed: () => scanBarcode(),
      icon: Icon(Icons.qr_code_scanner,color: Theme.of(context).colorScheme.primary,),
    );
  }
}