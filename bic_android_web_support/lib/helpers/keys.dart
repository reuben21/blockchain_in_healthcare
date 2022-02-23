

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

// String get rpcUrl {
//   if(kIsWeb) {
//     return "http://127.0.0.1:7545";
//   }
//   else if(Platform.isWindows) {
//   return "http://127.0.0.1:7545";
//   } else if (Platform.isAndroid) {
//     return  "http://10.0.2.2:7545";
//   }
//
//   return "http://127.0.0.1:7545";
// }

String get rpcUrl {
  if(kIsWeb) {
    return "http://192.168.0.100:7545";
  }
  else if(Platform.isWindows) {
    return "http://192.168.0.100:7545";
  } else if (Platform.isAndroid) {
    return  "http://192.168.0.100:7545";
  }

  return "http://192.168.0.100:7545";
}

// String get rpcUrl {
//   if(kIsWeb) {
//     return "https://speedy-nodes-nyc.moralis.io/ed3a6ddb4a2ff94731b9c5fd/polygon/mumbai";
//   }
//   else if(Platform.isWindows) {
//     return "https://speedy-nodes-nyc.moralis.io/ed3a6ddb4a2ff94731b9c5fd/polygon/mumbai";
//   } else if (Platform.isAndroid) {
//     return  "https://speedy-nodes-nyc.moralis.io/ed3a6ddb4a2ff94731b9c5fd/polygon/mumbai";
//   }
//
//   return "https://speedy-nodes-nyc.moralis.io/ed3a6ddb4a2ff94731b9c5fd/polygon/mumbai";
// }

String get rpcUrlWebSocket {
  if(kIsWeb) {
    return "ws://127.0.0.1:7545";
  }
  else if(Platform.isWindows) {
    return "ws://127.0.0.1:7545";
  } else if (Platform.isAndroid) {
    return  "ws://10.0.2.2:7545";
  }

  return "http://127.0.0.1:7545";
}


String get getIpfsUrl {
  if(kIsWeb) {
    return "https://ipfs.infura.io:5001";
  }
  else if(Platform.isWindows) {
    return "https://ipfs.infura.io:5001";
  } else if (Platform.isAndroid) {
    return  "https://ipfs.infura.io:5001";
  }

  return "https://ipfs.infura.io:5001";
}

String get getIpfsUrlForReceivingData {
  if(kIsWeb) {
    return "https://ipfs.infura.io:5001/api/v0/cat?arg=";
  }
  else if(Platform.isWindows) {
    return "https://ipfs.infura.io:5001/api/v0/cat?arg=";
  } else if (Platform.isAndroid) {
    return "https://ipfs.infura.io:5001/api/v0/cat?arg=";
  }

  return "https://ipfs.infura.io:5001/api/v0/cat?arg=";
}


String databaseUrl = "mongodb+srv://group22:310TXL42RKB0WW7v@mongodb.syifj.mongodb.net/healthcare?retryWrites=true&w=majority";
const String privateKey = "0e75aade5bd385616574bd6252b0d810f3f03f013dc43cbe15dc2e21e6ff4f14";
const String publicKey = "0xC30aC339bd3479eb62eD6fE71C1A0A59FA177F7B";

