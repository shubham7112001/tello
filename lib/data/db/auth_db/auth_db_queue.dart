import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

typedef DbOperation<T> = Future<T> Function();

class DbTask<T> {
  final DbOperation<T> operation;
  final Completer<T> completer;
  DbTask(this.operation, this.completer);
}

class AuthDbQueue {
  static final Queue<DbTask> _queue = Queue<DbTask>();
  static bool _isProcessing = false;

  static Future<T> add<T>(DbOperation<T> operation) {
    debugPrint("DbQueue: add called for type $T");
    final completer = Completer<T>();
    _queue.add(DbTask<T>(operation, completer));
    _startProcessing();
    return completer.future;
  }

  static void _startProcessing() {
    if (_isProcessing) return;
    _isProcessing = true;
    _processLoop();
  }

  static Future<void> _processLoop() async {
    while (_queue.isNotEmpty) {
      final task = _queue.removeFirst();
      try {
        final result = await task.operation();
        task.completer.complete(result);
      } catch (e, st) {
        task.completer.completeError(e, st);
        debugPrint("DbQueue Error: $e\n$st");
      }
    }
    _isProcessing = false;
  }
}
