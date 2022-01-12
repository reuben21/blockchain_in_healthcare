import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import '../helpers/keys.dart' as keys;
import 'package:flutter/cupertino.dart';
import '../helpers/http_exception.dart' as exception;

class GasEstimationModel with ChangeNotifier {
  final String _rpcUrl = keys.rpcUrl;

  late Web3Client _client;

  GasEstimationModel() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client());
    getDeployedContract();
  }

  Future<DeployedContract> getDeployedContract() async {
    String abi;
    EthereumAddress contractAddress;
    String abiString =
        await rootBundle.loadString('assets/abis/MainContract.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "MainContract"), contractAddress);
    print("MainContract Contract Address:- " + contract.address.toString());

    return contract;
  }

  Future<Map<String, dynamic>> estimateGas(
      String senderAddress, String receiverAddress, String amount) async {
    try {
      var gasEstimate = await _client.estimateGas(
          sender: EthereumAddress.fromHex(senderAddress),
          to: EthereumAddress.fromHex(receiverAddress),
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount));

      var gasPrice = await _client.getGasPrice();

      var gasCostEstimation = gasEstimate * gasPrice.getInWei;

      var gasAmountInWei = EtherAmount.fromUnitAndValue(
          EtherUnit.wei, gasCostEstimation.toString());

      var actualAmountInWei =
          EtherAmount.fromUnitAndValue(EtherUnit.ether, amount);

      var totalAmount = (gasAmountInWei.getInWei + actualAmountInWei.getInWei) /
          BigInt.from(1000000000000000000);

      Map<String, dynamic> result = {
        "gasPrice": gasPrice.getInWei,
        "gasEstimate": gasEstimate,
        "gasCostEstimation": gasCostEstimation,
        "gasAmountInWei": gasAmountInWei.getInWei,
        "actualAmountInWei": actualAmountInWei.getInWei,
        "totalAmount": totalAmount.toString()
      };

      print(result);

      notifyListeners();
      return result;
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

  Future<Map<String, dynamic>> estimateGasForContractFunction(
      EthereumAddress senderAddress, String functionName,List<dynamic> params) async {
    // try {
      DeployedContract contract = await getDeployedContract();

      var gasEstimate = await _client.estimateGas(
          sender: senderAddress,
          to: contract.address,
          data: contract.function(functionName).encodeCall(params));

      var gasPrice = await _client.getGasPrice();

      var gasCostEstimation = gasEstimate * gasPrice.getInWei;

      var gasAmountInWei = EtherAmount.fromUnitAndValue(
          EtherUnit.wei, gasCostEstimation.toString());

      var actualAmountInWei =
          EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);

      var totalAmount = (gasAmountInWei.getInWei + actualAmountInWei.getInWei) /
          BigInt.from(1000000000000000000);

      Map<String, dynamic> result = {
        "gasPrice": gasPrice.getInWei,
        "gasEstimate": gasEstimate,
        "gasCostEstimation": gasCostEstimation,
        "gasAmountInWei": gasAmountInWei.getInWei,
        "actualAmountInWei": actualAmountInWei.getInWei,
        "contractAddress":contract.address.hex.toString(),
        "totalAmount": totalAmount.toString()
      };

      print(result);

      notifyListeners();
      return result;
    // } on SocketException {
    //   throw exception.HttpException("No Internet connection 😑");
    // } on HttpException {
    //   throw exception.HttpException("Couldn't find the post 😱");
    // } on FormatException {
    //   throw exception.HttpException("Bad response format 👎");
    // } catch (error) {
    //   throw exception.HttpException(error.toString());
    // }
  }
}
