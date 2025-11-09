import 'dart:async';
import 'package:drift/drift.dart';
import 'package:otper_mobile/data/db/auth_db/auth_db_queue.dart';
import 'package:otper_mobile/data/db/auth_db/auth_db_table.dart';
import 'auth_db.dart';

class AuthDbHelper {
  static final AuthDbHelper instance = AuthDbHelper._privateConstructor();

  AuthDbHelper._privateConstructor();
  final AuthDatabase _db = AuthDatabase();

  Future<int> insertLogin({
    required String email,
    required String token,
  }) {
    return AuthDbQueue.add(() async {
      await (_db.delete(_db.loginTableDrift)
          ..where((tbl) => tbl.email.equals(email)))
        .go();
      return await _db.into(_db.loginTableDrift).insert(
        LoginTableDriftCompanion(
          email: Value(email),
          token: Value(token),
        ),
      );
    });
  }

  Future<bool> updateToken({
    required String email,
    required String newToken,
  }) {
    return AuthDbQueue.add(() async {
      return await (_db.update(_db.loginTableDrift)
            ..where((tbl) => tbl.email.equals(email)))
          .write(
        LoginTableDriftCompanion(
          token: Value(newToken),
          createdAt: Value(DateTime.now()),
        ),
      ) >
          0;
    });
  }

  Future<LoginTableDriftData?> getLoginByEmail(String email) {
    return AuthDbQueue.add(() async {
      return await (_db.select(_db.loginTableDrift)
            ..where((tbl) => tbl.email.equals(email)))
          .getSingleOrNull();
    });
  }

  Future<LoginTableDriftData?> getLatestLogin() {
    return AuthDbQueue.add(() async {
      final query = _db.select(_db.loginTableDrift)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(1);
      return await query.getSingleOrNull();
    });
  }

  Future<int> deleteLogin(String email) {
    return AuthDbQueue.add(() async {
      return await (_db.delete(_db.loginTableDrift)
            ..where((tbl) => tbl.email.equals(email)))
          .go();
    });
  }

  Future<int> deleteAllLogins() {
    return AuthDbQueue.add(() async {
      return await _db.delete(_db.loginTableDrift).go();
    });
  }

  Future<bool> isLoggedIn(String email) {
    return AuthDbQueue.add(() async {
      final login = await getLoginByEmail(email);
      return login != null && login.token.isNotEmpty;
    });
  }
}
