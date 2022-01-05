import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../helpers/http_exception.dart' as exception;

class IPFSModel with ChangeNotifier {




  Future<void> sendData() async {
    Map<String, Object> objText = {
      "firstName": "Reuben",
      "lastName": "Coutinho","lastName2": "Coutinho","lastName3": "Coutinho","lastName4": "Coutinho",
      "age": 30
    };

    print(objText.toString());

    try {
     // var hash = await ipfs.add(http.MultipartFile.fromString(objText.toString(), objText.toString()));

     // print(hash);


      var request = http.MultipartRequest("POST",Uri.parse('http://10.0.2.2:5001/api/v0/add'));
      var encodedData = json.encode(objText);

      print(encodedData);

      request.fields['Data'] = encodedData;
      http.Response response = await http.Response.fromStream(await
      request.send());

      print('Uploaded! ${response.body} ++ ${response.statusCode}');
      print(response);

    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error.toString());
    }
    notifyListeners();
  }

  Future<void> receiveData() async {
    try {
      final url = Uri.parse(
          "http://10.0.2.2:5001/api/v0/object/get?arg=QmWmSGtAKMk6y5SeHtfgTfgg8xphY7WmkNBwuvj2JEnLzr");

      final response = await http.post(url);
      // final List<OrderItem> loadedOrders = [];

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      final data = extractedData["Data"].toString().substring(
          4, extractedData["Data"]
          .toString()
          .length - 2);
      print(data);
      final decodedData = json.decode(data.toString()) as Map<String, dynamic>;
      print(decodedData["firstName"]);
    } on SocketException {
      throw exception.HttpException("No Internet connection 😑");
    } on HttpException {
      throw exception.HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw exception.HttpException("Bad response format 👎");
    } catch (error) {
      throw exception.HttpException(error.toString());
    }
    notifyListeners();
  }

}