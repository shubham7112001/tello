import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:otper_mobile/data/db/auth_db/auth_db_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'auth_db.g.dart';

@DriftDatabase(tables: [LoginTableDrift])
class AuthDatabase extends _$AuthDatabase {
  AuthDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'auth.db'));
    return NativeDatabase(file);
  });
}
