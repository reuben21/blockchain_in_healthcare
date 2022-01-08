import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../helpers/http_exception.dart' as exception;

class CryptoApiModel with ChangeNotifier {

  String cryptoUrl = "https://rest.coinapi.io/v1/exchangerate";



  Future<double> getCryptoDataForEthInr() async {
    try {

      http.Response response = await http.get(Uri.parse(cryptoUrl+"/ETH/INR"),
          headers: {"X-CoinAPI-Key": "5C33017A-65B2-4CC0-A73C-41FCD23BFE19"});;
      final responseBody = json.decode(response.body);
      final statusCode = response.statusCode;

      print(responseBody['rate']);

      notifyListeners();
      return responseBody['rate'];
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error.toString());
    }
  }

}
