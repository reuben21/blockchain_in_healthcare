// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class WalletTableData extends DataClass implements Insertable<WalletTableData> {
  final String walletAddress;
  final String? walletEncryptedKey;
  final DateTime? dueDate;
  WalletTableData(
      {required this.walletAddress, this.walletEncryptedKey, this.dueDate});
  factory WalletTableData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WalletTableData(
      walletAddress: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}wallet_address'])!,
      walletEncryptedKey: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}wallet_encrypted_key']),
      dueDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}due_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['wallet_address'] = Variable<String>(walletAddress);
    if (!nullToAbsent || walletEncryptedKey != null) {
      map['wallet_encrypted_key'] = Variable<String?>(walletEncryptedKey);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime?>(dueDate);
    }
    return map;
  }

  WalletTableCompanion toCompanion(bool nullToAbsent) {
    return WalletTableCompanion(
      walletAddress: Value(walletAddress),
      walletEncryptedKey: walletEncryptedKey == null && nullToAbsent
          ? const Value.absent()
          : Value(walletEncryptedKey),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
    );
  }

  factory WalletTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletTableData(
      walletAddress: serializer.fromJson<String>(json['walletAddress']),
      walletEncryptedKey:
          serializer.fromJson<String?>(json['walletEncryptedKey']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'walletAddress': serializer.toJson<String>(walletAddress),
      'walletEncryptedKey': serializer.toJson<String?>(walletEncryptedKey),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
    };
  }

  WalletTableData copyWith(
          {String? walletAddress,
          String? walletEncryptedKey,
          DateTime? dueDate}) =>
      WalletTableData(
        walletAddress: walletAddress ?? this.walletAddress,
        walletEncryptedKey: walletEncryptedKey ?? this.walletEncryptedKey,
        dueDate: dueDate ?? this.dueDate,
      );
  @override
  String toString() {
    return (StringBuffer('WalletTableData(')
          ..write('walletAddress: $walletAddress, ')
          ..write('walletEncryptedKey: $walletEncryptedKey, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(walletAddress, walletEncryptedKey, dueDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletTableData &&
          other.walletAddress == this.walletAddress &&
          other.walletEncryptedKey == this.walletEncryptedKey &&
          other.dueDate == this.dueDate);
}

class WalletTableCompanion extends UpdateCompanion<WalletTableData> {
  final Value<String> walletAddress;
  final Value<String?> walletEncryptedKey;
  final Value<DateTime?> dueDate;
  const WalletTableCompanion({
    this.walletAddress = const Value.absent(),
    this.walletEncryptedKey = const Value.absent(),
    this.dueDate = const Value.absent(),
  });
  WalletTableCompanion.insert({
    required String walletAddress,
    this.walletEncryptedKey = const Value.absent(),
    this.dueDate = const Value.absent(),
  }) : walletAddress = Value(walletAddress);
  static Insertable<WalletTableData> custom({
    Expression<String>? walletAddress,
    Expression<String?>? walletEncryptedKey,
    Expression<DateTime?>? dueDate,
  }) {
    return RawValuesInsertable({
      if (walletAddress != null) 'wallet_address': walletAddress,
      if (walletEncryptedKey != null)
        'wallet_encrypted_key': walletEncryptedKey,
      if (dueDate != null) 'due_date': dueDate,
    });
  }

  WalletTableCompanion copyWith(
      {Value<String>? walletAddress,
      Value<String?>? walletEncryptedKey,
      Value<DateTime?>? dueDate}) {
    return WalletTableCompanion(
      walletAddress: walletAddress ?? this.walletAddress,
      walletEncryptedKey: walletEncryptedKey ?? this.walletEncryptedKey,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (walletAddress.present) {
      map['wallet_address'] = Variable<String>(walletAddress.value);
    }
    if (walletEncryptedKey.present) {
      map['wallet_encrypted_key'] = Variable<String?>(walletEncryptedKey.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime?>(dueDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletTableCompanion(')
          ..write('walletAddress: $walletAddress, ')
          ..write('walletEncryptedKey: $walletEncryptedKey, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }
}

class $WalletTableTable extends WalletTable
    with TableInfo<$WalletTableTable, WalletTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WalletTableTable(this._db, [this._alias]);
  final VerificationMeta _walletAddressMeta =
      const VerificationMeta('walletAddress');
  @override
  late final GeneratedColumn<String?> walletAddress = GeneratedColumn<String?>(
      'wallet_address', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _walletEncryptedKeyMeta =
      const VerificationMeta('walletEncryptedKey');
  @override
  late final GeneratedColumn<String?> walletEncryptedKey =
      GeneratedColumn<String?>('wallet_encrypted_key', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dueDateMeta = const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime?> dueDate = GeneratedColumn<DateTime?>(
      'due_date', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [walletAddress, walletEncryptedKey, dueDate];
  @override
  String get aliasedName => _alias ?? 'wallet_table';
  @override
  String get actualTableName => 'wallet_table';
  @override
  VerificationContext validateIntegrity(Insertable<WalletTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('wallet_address')) {
      context.handle(
          _walletAddressMeta,
          walletAddress.isAcceptableOrUnknown(
              data['wallet_address']!, _walletAddressMeta));
    } else if (isInserting) {
      context.missing(_walletAddressMeta);
    }
    if (data.containsKey('wallet_encrypted_key')) {
      context.handle(
          _walletEncryptedKeyMeta,
          walletEncryptedKey.isAcceptableOrUnknown(
              data['wallet_encrypted_key']!, _walletEncryptedKeyMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  WalletTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return WalletTableData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WalletTableTable createAlias(String alias) {
    return $WalletTableTable(_db, alias);
  }
}

class TransactionTableData extends DataClass
    implements Insertable<TransactionTableData> {
  final String transactionHash;
  final String blockNumber;
  final String value;
  final String fromAddress;
  final String toAddress;
  final String dateOfTransaction;
  final DateTime? dueDate;
  TransactionTableData(
      {required this.transactionHash,
      required this.blockNumber,
      required this.value,
      required this.fromAddress,
      required this.toAddress,
      required this.dateOfTransaction,
      this.dueDate});
  factory TransactionTableData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TransactionTableData(
      transactionHash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}transaction_hash'])!,
      blockNumber: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}block_number'])!,
      value: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}value'])!,
      fromAddress: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}from_address'])!,
      toAddress: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}to_address'])!,
      dateOfTransaction: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}date_of_transaction'])!,
      dueDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}due_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transaction_hash'] = Variable<String>(transactionHash);
    map['block_number'] = Variable<String>(blockNumber);
    map['value'] = Variable<String>(value);
    map['from_address'] = Variable<String>(fromAddress);
    map['to_address'] = Variable<String>(toAddress);
    map['date_of_transaction'] = Variable<String>(dateOfTransaction);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime?>(dueDate);
    }
    return map;
  }

  TransactionTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionTableCompanion(
      transactionHash: Value(transactionHash),
      blockNumber: Value(blockNumber),
      value: Value(value),
      fromAddress: Value(fromAddress),
      toAddress: Value(toAddress),
      dateOfTransaction: Value(dateOfTransaction),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
    );
  }

  factory TransactionTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTableData(
      transactionHash: serializer.fromJson<String>(json['transactionHash']),
      blockNumber: serializer.fromJson<String>(json['blockNumber']),
      value: serializer.fromJson<String>(json['value']),
      fromAddress: serializer.fromJson<String>(json['fromAddress']),
      toAddress: serializer.fromJson<String>(json['toAddress']),
      dateOfTransaction: serializer.fromJson<String>(json['dateOfTransaction']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transactionHash': serializer.toJson<String>(transactionHash),
      'blockNumber': serializer.toJson<String>(blockNumber),
      'value': serializer.toJson<String>(value),
      'fromAddress': serializer.toJson<String>(fromAddress),
      'toAddress': serializer.toJson<String>(toAddress),
      'dateOfTransaction': serializer.toJson<String>(dateOfTransaction),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
    };
  }

  TransactionTableData copyWith(
          {String? transactionHash,
          String? blockNumber,
          String? value,
          String? fromAddress,
          String? toAddress,
          String? dateOfTransaction,
          DateTime? dueDate}) =>
      TransactionTableData(
        transactionHash: transactionHash ?? this.transactionHash,
        blockNumber: blockNumber ?? this.blockNumber,
        value: value ?? this.value,
        fromAddress: fromAddress ?? this.fromAddress,
        toAddress: toAddress ?? this.toAddress,
        dateOfTransaction: dateOfTransaction ?? this.dateOfTransaction,
        dueDate: dueDate ?? this.dueDate,
      );
  @override
  String toString() {
    return (StringBuffer('TransactionTableData(')
          ..write('transactionHash: $transactionHash, ')
          ..write('blockNumber: $blockNumber, ')
          ..write('value: $value, ')
          ..write('fromAddress: $fromAddress, ')
          ..write('toAddress: $toAddress, ')
          ..write('dateOfTransaction: $dateOfTransaction, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(transactionHash, blockNumber, value,
      fromAddress, toAddress, dateOfTransaction, dueDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTableData &&
          other.transactionHash == this.transactionHash &&
          other.blockNumber == this.blockNumber &&
          other.value == this.value &&
          other.fromAddress == this.fromAddress &&
          other.toAddress == this.toAddress &&
          other.dateOfTransaction == this.dateOfTransaction &&
          other.dueDate == this.dueDate);
}

class TransactionTableCompanion extends UpdateCompanion<TransactionTableData> {
  final Value<String> transactionHash;
  final Value<String> blockNumber;
  final Value<String> value;
  final Value<String> fromAddress;
  final Value<String> toAddress;
  final Value<String> dateOfTransaction;
  final Value<DateTime?> dueDate;
  const TransactionTableCompanion({
    this.transactionHash = const Value.absent(),
    this.blockNumber = const Value.absent(),
    this.value = const Value.absent(),
    this.fromAddress = const Value.absent(),
    this.toAddress = const Value.absent(),
    this.dateOfTransaction = const Value.absent(),
    this.dueDate = const Value.absent(),
  });
  TransactionTableCompanion.insert({
    required String transactionHash,
    required String blockNumber,
    required String value,
    required String fromAddress,
    required String toAddress,
    required String dateOfTransaction,
    this.dueDate = const Value.absent(),
  })  : transactionHash = Value(transactionHash),
        blockNumber = Value(blockNumber),
        value = Value(value),
        fromAddress = Value(fromAddress),
        toAddress = Value(toAddress),
        dateOfTransaction = Value(dateOfTransaction);
  static Insertable<TransactionTableData> custom({
    Expression<String>? transactionHash,
    Expression<String>? blockNumber,
    Expression<String>? value,
    Expression<String>? fromAddress,
    Expression<String>? toAddress,
    Expression<String>? dateOfTransaction,
    Expression<DateTime?>? dueDate,
  }) {
    return RawValuesInsertable({
      if (transactionHash != null) 'transaction_hash': transactionHash,
      if (blockNumber != null) 'block_number': blockNumber,
      if (value != null) 'value': value,
      if (fromAddress != null) 'from_address': fromAddress,
      if (toAddress != null) 'to_address': toAddress,
      if (dateOfTransaction != null) 'date_of_transaction': dateOfTransaction,
      if (dueDate != null) 'due_date': dueDate,
    });
  }

  TransactionTableCompanion copyWith(
      {Value<String>? transactionHash,
      Value<String>? blockNumber,
      Value<String>? value,
      Value<String>? fromAddress,
      Value<String>? toAddress,
      Value<String>? dateOfTransaction,
      Value<DateTime?>? dueDate}) {
    return TransactionTableCompanion(
      transactionHash: transactionHash ?? this.transactionHash,
      blockNumber: blockNumber ?? this.blockNumber,
      value: value ?? this.value,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      dateOfTransaction: dateOfTransaction ?? this.dateOfTransaction,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transactionHash.present) {
      map['transaction_hash'] = Variable<String>(transactionHash.value);
    }
    if (blockNumber.present) {
      map['block_number'] = Variable<String>(blockNumber.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (fromAddress.present) {
      map['from_address'] = Variable<String>(fromAddress.value);
    }
    if (toAddress.present) {
      map['to_address'] = Variable<String>(toAddress.value);
    }
    if (dateOfTransaction.present) {
      map['date_of_transaction'] = Variable<String>(dateOfTransaction.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime?>(dueDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableCompanion(')
          ..write('transactionHash: $transactionHash, ')
          ..write('blockNumber: $blockNumber, ')
          ..write('value: $value, ')
          ..write('fromAddress: $fromAddress, ')
          ..write('toAddress: $toAddress, ')
          ..write('dateOfTransaction: $dateOfTransaction, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }
}

class $TransactionTableTable extends TransactionTable
    with TableInfo<$TransactionTableTable, TransactionTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TransactionTableTable(this._db, [this._alias]);
  final VerificationMeta _transactionHashMeta =
      const VerificationMeta('transactionHash');
  @override
  late final GeneratedColumn<String?> transactionHash =
      GeneratedColumn<String?>('transaction_hash', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _blockNumberMeta =
      const VerificationMeta('blockNumber');
  @override
  late final GeneratedColumn<String?> blockNumber = GeneratedColumn<String?>(
      'block_number', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String?> value = GeneratedColumn<String?>(
      'value', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _fromAddressMeta =
      const VerificationMeta('fromAddress');
  @override
  late final GeneratedColumn<String?> fromAddress = GeneratedColumn<String?>(
      'from_address', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _toAddressMeta = const VerificationMeta('toAddress');
  @override
  late final GeneratedColumn<String?> toAddress = GeneratedColumn<String?>(
      'to_address', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dateOfTransactionMeta =
      const VerificationMeta('dateOfTransaction');
  @override
  late final GeneratedColumn<String?> dateOfTransaction =
      GeneratedColumn<String?>('date_of_transaction', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dueDateMeta = const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime?> dueDate = GeneratedColumn<DateTime?>(
      'due_date', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        transactionHash,
        blockNumber,
        value,
        fromAddress,
        toAddress,
        dateOfTransaction,
        dueDate
      ];
  @override
  String get aliasedName => _alias ?? 'transaction_table';
  @override
  String get actualTableName => 'transaction_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_hash')) {
      context.handle(
          _transactionHashMeta,
          transactionHash.isAcceptableOrUnknown(
              data['transaction_hash']!, _transactionHashMeta));
    } else if (isInserting) {
      context.missing(_transactionHashMeta);
    }
    if (data.containsKey('block_number')) {
      context.handle(
          _blockNumberMeta,
          blockNumber.isAcceptableOrUnknown(
              data['block_number']!, _blockNumberMeta));
    } else if (isInserting) {
      context.missing(_blockNumberMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('from_address')) {
      context.handle(
          _fromAddressMeta,
          fromAddress.isAcceptableOrUnknown(
              data['from_address']!, _fromAddressMeta));
    } else if (isInserting) {
      context.missing(_fromAddressMeta);
    }
    if (data.containsKey('to_address')) {
      context.handle(_toAddressMeta,
          toAddress.isAcceptableOrUnknown(data['to_address']!, _toAddressMeta));
    } else if (isInserting) {
      context.missing(_toAddressMeta);
    }
    if (data.containsKey('date_of_transaction')) {
      context.handle(
          _dateOfTransactionMeta,
          dateOfTransaction.isAcceptableOrUnknown(
              data['date_of_transaction']!, _dateOfTransactionMeta));
    } else if (isInserting) {
      context.missing(_dateOfTransactionMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  TransactionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TransactionTableData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TransactionTableTable createAlias(String alias) {
    return $TransactionTableTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $WalletTableTable walletTable = $WalletTableTable(this);
  late final $TransactionTableTable transactionTable =
      $TransactionTableTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [walletTable, transactionTable];
}
