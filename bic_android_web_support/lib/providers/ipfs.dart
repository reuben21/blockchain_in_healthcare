import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../helpers/http_exception.dart' as exception;
import '../helpers/keys.dart' as keys;

class IPFSModel with ChangeNotifier {

  // TO SEND JSON FILE INTO THIS FUNCTION, ANY JSON IN ANY FORMAT
  // Map<String, Object> objText = {
  //   "firstName": "Rhea",
  //   "lastName": "Coutinho",
  //   "lastName2": "Coutinho",
  //   "lastName3": "Coutinho",
  //   "lastName4": ["Coutinho",  "Coutinho", "Coutinho"],
  //   "age": 30
  // };
  Future<String> sendData(Map<String, dynamic> objText) async {
    print(objText.toString());
    try {
      // var hash = await ipfs.add(http.MultipartFile.fromString(objText.toString(), objText.toString()));

      // print(hash);

      var request = http.MultipartRequest(
          "POST", Uri.parse('${keys.getIpfsUrl}/api/v0/add'));
      var encodedData = json.encode(objText);

      print(encodedData);

      request.fields['Data'] = encodedData;
      http.Response response =
          await http.Response.fromStream(await request.send());
      final extractedData = json.decode(response.body);


      return extractedData['Hash'];
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

  Future<Map<String, dynamic>?> receiveData(String hash) async {
    if(hash.isNotEmpty) {
      try {
        final url = Uri.parse(
            "${keys.getIpfsUrlForReceivingData}${hash}");

        final response = await http.get(url);
        // print(response.body);


        final extractedData = json.decode(response.body);

        if (extractedData == null) {
          Map<String, Object> obj = {
            "STATUS": "Null"
          };
          return obj;
        }

        return extractedData as Map<String,dynamic>;

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

    notifyListeners();
  }
}
