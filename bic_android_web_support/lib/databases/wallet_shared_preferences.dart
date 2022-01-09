import 'package:shared_preferences/shared_preferences.dart';

class WalletSharedPreference {
  static late SharedPreferences _preferences;

  static const _userName = 'userName';
  static const _userEmail = 'userEmail';
  static const _walletAddress = 'walletAddress';
  static const _walletEncryptedKey = 'walletEncryptedKey';
  static const _userType = 'userType';


  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<void> setWalletDetails(
    String userName,
    String userEmail,
    String walletAddress,
    String walletEncryptedKey,
    String userType,
  ) async {
    await _preferences.setString(_userName, userName);
    await _preferences.setString(_userEmail,userEmail);
    await _preferences.setString(_walletAddress, walletAddress);
    await _preferences.setString(_walletEncryptedKey,walletEncryptedKey);
    await _preferences.setString(_userType, userType);
  }

  static Future<Map<String,String>?> getWalletDetails() async {

    String? userName = _preferences.getString(_userName);
    String? userEmail = _preferences.getString(_userEmail);
    String? walletAddress =  _preferences.getString(_walletAddress);
    String? walletEncryptedKey =  _preferences.getString(_walletEncryptedKey);
    String? userType =  _preferences.getString(_userType);

    Map<String,String> walletDetails = {
      "userName":userName.toString(),
      "userEmail":userEmail.toString(),
      "walletAddress":walletAddress.toString(),
      "walletEncryptedKey":walletEncryptedKey.toString(),
      "userType":userType.toString()
    };
    return walletDetails;
  }

  static Future<String?> getUserType() async {
    String? userType =  _preferences.getString(_userType);
    return userType;
  }

  static Future<void> deleteWalletData() async {

     _preferences.remove(_userName);
    _preferences.remove(_userEmail);
     _preferences.remove(_walletAddress);
     _preferences.remove(_walletEncryptedKey);
     _preferences.remove(_userType);


  }


}
