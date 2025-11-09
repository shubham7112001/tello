// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_db.dart';

// ignore_for_file: type=lint
class $LoginTableDriftTable extends LoginTableDrift
    with TableInfo<$LoginTableDriftTable, LoginTableDriftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoginTableDriftTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, email, token, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'login_table_drift';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoginTableDriftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoginTableDriftData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoginTableDriftData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LoginTableDriftTable createAlias(String alias) {
    return $LoginTableDriftTable(attachedDatabase, alias);
  }
}

class LoginTableDriftData extends DataClass
    implements Insertable<LoginTableDriftData> {
  final int id;
  final String email;
  final String token;
  final DateTime createdAt;
  const LoginTableDriftData({
    required this.id,
    required this.email,
    required this.token,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['token'] = Variable<String>(token);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LoginTableDriftCompanion toCompanion(bool nullToAbsent) {
    return LoginTableDriftCompanion(
      id: Value(id),
      email: Value(email),
      token: Value(token),
      createdAt: Value(createdAt),
    );
  }

  factory LoginTableDriftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoginTableDriftData(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      token: serializer.fromJson<String>(json['token']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'token': serializer.toJson<String>(token),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LoginTableDriftData copyWith({
    int? id,
    String? email,
    String? token,
    DateTime? createdAt,
  }) => LoginTableDriftData(
    id: id ?? this.id,
    email: email ?? this.email,
    token: token ?? this.token,
    createdAt: createdAt ?? this.createdAt,
  );
  LoginTableDriftData copyWithCompanion(LoginTableDriftCompanion data) {
    return LoginTableDriftData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      token: data.token.present ? data.token.value : this.token,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoginTableDriftData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, token, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoginTableDriftData &&
          other.id == this.id &&
          other.email == this.email &&
          other.token == this.token &&
          other.createdAt == this.createdAt);
}

class LoginTableDriftCompanion extends UpdateCompanion<LoginTableDriftData> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> token;
  final Value<DateTime> createdAt;
  const LoginTableDriftCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.token = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LoginTableDriftCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String token,
    this.createdAt = const Value.absent(),
  }) : email = Value(email),
       token = Value(token);
  static Insertable<LoginTableDriftData> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? token,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (token != null) 'token': token,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LoginTableDriftCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String>? token,
    Value<DateTime>? createdAt,
  }) {
    return LoginTableDriftCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoginTableDriftCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AuthDatabase extends GeneratedDatabase {
  _$AuthDatabase(QueryExecutor e) : super(e);
  $AuthDatabaseManager get managers => $AuthDatabaseManager(this);
  late final $LoginTableDriftTable loginTableDrift = $LoginTableDriftTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [loginTableDrift];
}

typedef $$LoginTableDriftTableCreateCompanionBuilder =
    LoginTableDriftCompanion Function({
      Value<int> id,
      required String email,
      required String token,
      Value<DateTime> createdAt,
    });
typedef $$LoginTableDriftTableUpdateCompanionBuilder =
    LoginTableDriftCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String> token,
      Value<DateTime> createdAt,
    });

class $$LoginTableDriftTableFilterComposer
    extends Composer<_$AuthDatabase, $LoginTableDriftTable> {
  $$LoginTableDriftTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoginTableDriftTableOrderingComposer
    extends Composer<_$AuthDatabase, $LoginTableDriftTable> {
  $$LoginTableDriftTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoginTableDriftTableAnnotationComposer
    extends Composer<_$AuthDatabase, $LoginTableDriftTable> {
  $$LoginTableDriftTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LoginTableDriftTableTableManager
    extends
        RootTableManager<
          _$AuthDatabase,
          $LoginTableDriftTable,
          LoginTableDriftData,
          $$LoginTableDriftTableFilterComposer,
          $$LoginTableDriftTableOrderingComposer,
          $$LoginTableDriftTableAnnotationComposer,
          $$LoginTableDriftTableCreateCompanionBuilder,
          $$LoginTableDriftTableUpdateCompanionBuilder,
          (
            LoginTableDriftData,
            BaseReferences<
              _$AuthDatabase,
              $LoginTableDriftTable,
              LoginTableDriftData
            >,
          ),
          LoginTableDriftData,
          PrefetchHooks Function()
        > {
  $$LoginTableDriftTableTableManager(
    _$AuthDatabase db,
    $LoginTableDriftTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoginTableDriftTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoginTableDriftTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoginTableDriftTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LoginTableDriftCompanion(
                id: id,
                email: email,
                token: token,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                required String token,
                Value<DateTime> createdAt = const Value.absent(),
              }) => LoginTableDriftCompanion.insert(
                id: id,
                email: email,
                token: token,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoginTableDriftTableProcessedTableManager =
    ProcessedTableManager<
      _$AuthDatabase,
      $LoginTableDriftTable,
      LoginTableDriftData,
      $$LoginTableDriftTableFilterComposer,
      $$LoginTableDriftTableOrderingComposer,
      $$LoginTableDriftTableAnnotationComposer,
      $$LoginTableDriftTableCreateCompanionBuilder,
      $$LoginTableDriftTableUpdateCompanionBuilder,
      (
        LoginTableDriftData,
        BaseReferences<
          _$AuthDatabase,
          $LoginTableDriftTable,
          LoginTableDriftData
        >,
      ),
      LoginTableDriftData,
      PrefetchHooks Function()
    >;

class $AuthDatabaseManager {
  final _$AuthDatabase _db;
  $AuthDatabaseManager(this._db);
  $$LoginTableDriftTableTableManager get loginTableDrift =>
      $$LoginTableDriftTableTableManager(_db, _db.loginTableDrift);
}
