import 'package:blockchain_healthcare_frontend/screens/medical_records_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/prescription_screen.dart';
import 'package:blockchain_healthcare_frontend/screens/wallet.dart';
import 'package:blockchain_healthcare_frontend/theme.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {


  @override
  _TabsScreenState createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {

  List<Map<String, Object>> _pages;

  @override
  void initState() {
    _pages = [
      {'page':MedicalRecordScreen() , 'title': 'Record'},
      {'page':PrescriptionScreen() , 'title': 'Medicine'},
      {'page':WalletScreen(), 'title': 'Wallet'}
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectPageIndex]['title']),
      ),
      body: _pages[_selectPageIndex]['page'],
      bottomNavigationBar: BottomNavyBar(
        // unselectedItemColor: Colors.white,
        // selectedItemColor: Colors.redAccent,
        showElevation: true,
        itemCornerRadius: 24,
        selectedIndex: _selectPageIndex,
        onItemSelected: _selectPage,
        items: <BottomNavyBarItem> [
          BottomNavyBarItem(icon: Image.asset("assets/icons/medical_history.png",color: justBlue,width: 32,height: 32,), title: Text('Record',style: TextStyle(color: justBlue),)),
          BottomNavyBarItem(icon: Image.asset("assets/icons/medicine.png",color: justBlue,width: 32,height: 32), title: Text('Medicine',style: TextStyle(color: justBlue),)),
          BottomNavyBarItem(icon: Image.asset("assets/icons/wallet.png",color: justBlue,width: 32,height: 32), title: Text('Wallet',style: TextStyle(color: justBlue),))
        ],
      ),
    );
  }
}