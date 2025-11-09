import 'package:hive/hive.dart';
import 'package:otper_mobile/configs/app_config.dart';
import 'package:otper_mobile/data/db/action_db/action_model_adapter.dart';
import 'action_model.dart';

class ApiQueueService {
  static Box<ActionModel>? _box;

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(ActionModelAdapter().typeId)) {
      Hive.registerAdapter(ActionModelAdapter());
    }
    _box ??= await Hive.openBox<ActionModel>(AppConfig.hiveActionDb);
    _box?.clear();
  }

  static Future<void> enqueue(ActionModel action) async {
    await _box?.add(action);
  }

  static ActionModel? peek() {
    if (_box == null || _box!.isEmpty) return null;
    return _box!.getAt(0);
  }

  static Future<void> dequeue() async {
    if (_box != null && _box!.isNotEmpty) {
      await _box!.deleteAt(0);
    }
  }

  static Future<void> clear() async {
    await _box?.clear();
  }

  static bool isEmpty() {
    return _box?.isEmpty ?? true;
  }

  static int length() {
    return _box?.length ?? 0;
  }
}
