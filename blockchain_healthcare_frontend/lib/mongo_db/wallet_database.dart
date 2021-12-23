import 'package:mongo_dart/mongo_dart.dart';
import 'package:path/path.dart';

class MongoDBProviderWallet {
  Db db;

  MongoDBProviderWallet() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    db = await Db.create(
        "mongodb+srv://reuben:reuben@mongodb.syifj.mongodb.net/healthcare?retryWrites=true&w=majority");

  }

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

  newWallet(String walletAddress, String walletPassword,
      String walletPrivateKey, String expiryDate) async {
    print("New WalletTable Session");
    await db.open();
    try {
      Map<String, dynamic> map1 = {
        'walletAddress': walletAddress,
        'walletPassword': walletPassword,
        'walletPrivateKey': walletPrivateKey,
        'expiryDate': expiryDate,

      };
     var res = await db.collection("wallet").insert(map1);
     await db.close();
     print(res);

     return res;
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
    var coll = db.collection(walletAddress);


    // if (res.length == 0) {
    //   return null;
    // } else {
    //   var resMap = res[0];
    //   return resMap.isNotEmpty ? resMap : null;
    // }
  }

  Future<List<Map<String, Object>>> get getWallet async {
    // final db = await database;
    // var res = await db.query("WalletTable");
    //
    // if (res.length == 0) {
    //   return null;
    // } else {
    //   var resMap = res[0];
    //   return resMap.isNotEmpty ? res : null;
    // }
  }
}
