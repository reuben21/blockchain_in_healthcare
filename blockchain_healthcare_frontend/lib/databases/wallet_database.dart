import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProviderWallet {
  DBProviderWallet._();

  static final DBProviderWallet db = DBProviderWallet._();
  static Database _databaseWallet;

  Future<Database> get database async {
    if (_databaseWallet != null) {
      return _databaseWallet;
    }

    _databaseWallet = await initDB();
    return _databaseWallet;
  }

  Future<Database> initDB() async {
    print("Created initDB DatabaseWallet");
    try {
      var databasesPath = await getDatabasesPath();
      await deleteDatabase(databasesPath);
      String path = join(databasesPath, 'WalletDatabase.db');
      return await openDatabase(path, version: 3,
          onCreate: (Database db, int version) async {
            await db.execute("""
          CREATE TABLE IF NOT EXISTS WalletTable ( 
          walletAddress TEXT PRIMARY KEY,
          walletPassword TEXT,
          walletEncryptedKey TEXT,
          expiryDate TEXT
          );
          """);
          });
    } catch (error) {
      print(error);
    }
  }

  newWallet(String walletAddress, String walletPassword, String walletEncryptedKey, String expiryDate) async {
    print("New WalletTable Session");
    try {
      final db = await database;

      var res = await db.rawInsert(''' 
    INSERT INTO WalletTable (
    walletAddress,walletPassword,walletEncryptedKey,expiryDate
    ) VALUES (?,?,?,?)
    ''', [walletAddress, walletPassword, walletEncryptedKey,expiryDate ]);
      return res;
    } catch (error) {
      print(error);
    }
  }

  deleteWalletSession() async {
    print("New WalletTable Session");
    try {
      final db = await database;
      var delete = await db.rawInsert( '''DELETE FROM WalletTable''');
      print("Deleted WalletTable");
    } catch (error) {
      print(error);
    }
  }

  getWalletByWalletAddress(String walletAddress) async {
    final db = await database;
    var res = await db.rawQuery(""" Select * from WalletTable where walletAddress = ? """,[walletAddress]);

    if (res.length == 0) {
      return null;
    } else {
      var resMap = res[0];
      return resMap.isNotEmpty ? resMap : null;
    }
  }

  Future<List<Map<String, Object>>> get getWallet async {
    final db = await database;
    var res = await db.query("WalletTable");

    if (res.length == 0) {
      return null;
    } else {
      print(res);
      var resMap = res[0];
      return resMap.isNotEmpty ? res : null;
    }
  }
}