import 'package:hive_flutter/hive_flutter.dart';
import 'package:otper_mobile/data/db/action_db/api_queue_manager.dart';
import 'package:otper_mobile/data/db/action_db/api_queue_service.dart';
import 'package:otper_mobile/configs/router_configs.dart/route_config.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';

class MainInitializer {
  static Future<void> initialize()async{
    AppNavigator.init(routeConfig); 
    await Hive.initFlutter();
    await ApiQueueService.init();

    final apiQueue = ApiQueueManager();
    await apiQueue.initialize();
  }
}