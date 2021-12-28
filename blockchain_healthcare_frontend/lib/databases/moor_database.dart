// These imports are only needed to open the database
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'dart:io';


// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for drift to know about the generated code
part 'moor_database.g.dart';

// The name of the database table is "tasks"
// By default, the name of the generated data class will be "Task" (without "s")
class WalletTable extends Table {
  // autoIncrement automatically sets this to be the primary key
  TextColumn get walletAddress => text()();
  // If the length constraint is not fulfilled, the Task will not
  // be inserted into the database and an exception will be thrown.
  TextColumn get walletEncryptedKey => text().nullable()();
  // DateTime is not natively supported by SQLite
  // Moor converts it to & from UNIX seconds
  DateTimeColumn get dueDate => dateTime().nullable()();
  // Booleans are not supported as well, Moor converts them to integers
  // Simple default values are specified as Constants
}

class TransactionTable extends Table {
  // autoIncrement automatically sets this to be the primary key
  TextColumn get transactionHash => text()();
  // If the length constraint is not fulfilled, the Task will not
  // be inserted into the database and an exception will be thrown.
  TextColumn get blockNumber => text()();
  TextColumn get value => text()();
  TextColumn get fromAddress => text()();
  TextColumn get toAddress => text()();
  TextColumn get dateOfTransaction => text()();

  // DateTime is not natively supported by SQLite
  // Moor converts it to & from UNIX seconds
  DateTimeColumn get dueDate => dateTime().nullable()();
// Booleans are not supported as well, Moor converts them to integers
// Simple default values are specified as Constants
}


LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [WalletTable, TransactionTable])
class MyDatabase extends _$MyDatabase {

  MyDatabase() : super(_openConnection());

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;

  Future<List<WalletTableData>> getAllWallets() => select(walletTable).get();
  Future<List<WalletTableData>> getWalletByWalletAddress(WalletTableData wallet) => (select(walletTable)..where((w) => w.walletAddress.equals(wallet.walletAddress))).get();
  Future insertWallet(WalletTableData wallet) => into(walletTable).insert(wallet);
  DeleteStatement<$WalletTableTable, WalletTableData> deleteWallet() => delete(walletTable);
  // Stream<List<TransactionTableData>> watchTransactions() => select(transactionTable).watch();


}