import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProviderTransactions {
  DBProviderTransactions._();

  static final DBProviderTransactions db = DBProviderTransactions._();
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
      String path = join(databasesPath, 'TransactionsDatabase.db');
      return await openDatabase(path, version: 2,
          onCreate: (Database db, int version) async {
            await db.execute("""
          CREATE TABLE IF NOT EXISTS TransactionTable ( 
          transactionHash TEXT PRIMARY KEY,
          blockNumber TEXT,
          value TEXT,
          fromAddress TEXT,
          toAddress TEXT,
          dateOfTransaction TEXT
          );
          """);
          });
    } catch (error) {
      print(error);
    }
  }

  newTransaction(String transactionHash, String blockNumber, String value,
      String from, String to, String dateOfTransaction) async {
    print("New TransactionTable Session");
    try {
      final db = await database;

      var res = await db.rawInsert(''' 
    INSERT INTO TransactionTable (
    transactionHash, blockNumber , value , fromAddress , toAddress , dateOfTransaction
    ) VALUES (?,?,?,?,?)
    ''', [transactionHash, blockNumber, value, from,to ,dateOfTransaction ]);
      return res;
    } catch (error) {
      print(error);
    }
  }

  deleteTransaction() async {
    print("New TransactionTable Session");
    try {
      final db = await database;
      var delete = await db.rawInsert( '''DELETE FROM TransactionTable''');
      print("Deleted TransactionTable");
    } catch (error) {
      print(error);
    }
  }

  getTransactionByTransactionAddress(String walletAddress) async {
    final db = await database;
    var res = await db.rawQuery(""" Select * from TransactionTable where transactionHash = ? """,[walletAddress]);

    if (res.length == 0) {
      return null;
    } else {
      var resMap = res[0];
      return resMap.isNotEmpty ? resMap : null;
    }
  }

  Future<List<Map<String, Object>>> get getTransaction async {
    final db = await database;
    var res = await db.query("TransactionTable");

    if (res.length == 0) {
      return null;
    } else {

      var resMap = res[0];
      return resMap.isNotEmpty ? res : null;
    }
  }
}