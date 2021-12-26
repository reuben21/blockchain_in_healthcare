import 'package:mongo_dart/mongo_dart.dart';
import 'package:path/path.dart';

class MongoDBProviderWallet {
  late Db db;
  late String databaseUrl = "mongodb+srv://group22:310TXL42RKB0WW7v@mongodb.syifj.mongodb.net/healthcare?retryWrites=true&w=majority";


  MongoDBProviderWallet() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {}

  // Future<Database> initDB() async {
  //   print("Created initDB DatabaseWallet");
  //   try {
  //     var databasesPath = await getDatabasesPath();
  //     await deleteDatabase(databasesPath);
  //     String path = join(databasesPath, 'WalletDatabase.db');
  //     return await openDatabase(path, version: 6,
  //         onCreate: (Database db, int version) async {
  //           await db.execute("""
  //         CREATE TABLE IF NOT EXISTS WalletTable (
  //         walletAddress TEXT PRIMARY KEY,
  //         walletPassword TEXT,
  //         walletPrivateKey TEXT,
  //         expiryDate TEXT
  //         );
  //         """);
  //         });
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  newWallet(String walletAddress, String walletCredentials) async {
    db = await Db.create(databaseUrl);
    List data = [];
    print("New WalletTable Session");

    try {
      await db.open();
      Map<String, dynamic> map1 = {
        'walletAddress': walletAddress,
        'walletEncryptedKey': walletCredentials,
        'transactions': BsonArray(data)
      };

      var res = await db.collection("wallet").insertOne(map1);
      await db.close();

      return res.document;
    } catch (error) {
      print(error);
    }
  }

  deleteWalletSession() async {
    print("New WalletTable Session");
    // try {
    //   final db = await database;
    //   var delete = await db.rawInsert('''DELETE FROM WalletTable''');
    //   print("Deleted WalletTable");
    // } catch (error) {
    //   print(error);
    // }
  }

  getWalletByWalletAddress(String walletAddress) async {



    try {
      await db.open();
      var coll = await db.collection("wallet").find({'walletAddress':walletAddress}).toList();
      await db.close();


      return coll;
    } catch (error) {
      print(error);
    }
    // if (res.length == 0) {
    //   return null;
    // } else {
    //   var resMap = res[0];
    //   return resMap.isNotEmpty ? resMap : null;
    // }
  }
  //
  // Future<List<Map<String, Object>>> get getWallet async {
  //   // final db = await database;
  //   // var res = await db.query("WalletTable");
  //   //
  //   // if (res.length == 0) {
  //   //   return null;
  //   // } else {
  //   //   var resMap = res[0];
  //   //   return resMap.isNotEmpty ? res : null;
  //   // }
  // }
}
