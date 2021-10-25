
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'database.dart';


class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;



  bool get isAuth {

    print(token != null);
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }



  Future<void> _authenticate(
      String username, String password, String walletAddress) async {
    try {



      _token = password;
      _userId = walletAddress;
      _expiryDate = DateTime.now()
          .add(Duration(seconds: 604800));
      _autoLogout();

      var dbResponse = await DBProvider.db.newUserSession(_userId, _token, _expiryDate.toIso8601String());


      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({'token':_token,'userId':_userId,'expiryDate':_expiryDate.toIso8601String()});
      // prefs.setString('userData',userData);
      // print(userData.toString());
      notifyListeners();

    } catch (error) {
      throw error;
    }
  }


  Future<void> signin(String email, String password,  String _walletAddress) async {

    return _authenticate(email, password,_walletAddress);
  }

  Future<bool> tryAutoLogin() async {
    var userSession = await DBProvider.db.getUserSession;
    print("USER SESSION");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if(prefs.containsKey('userData')) {
    //   return false;
    // }
    // print("Entered Extraction");

    final expiryDate = DateTime.parse(userSession['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userSession['token'];
    _userId = userSession['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    await DBProvider.db.deleteUserSession();
    notifyListeners();
    if(_authTimer!=null) {
      _authTimer.cancel();
      _authTimer = null;
    }
  }

  void _autoLogout() {
    if(_authTimer!=null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry),logout);

  }
}