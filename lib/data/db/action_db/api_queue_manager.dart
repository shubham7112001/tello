import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:otper_mobile/data/db/action_db/action_model.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'api_queue_service.dart';

class ApiQueueManager {
  static final ApiQueueManager instance = ApiQueueManager._internal();
  factory ApiQueueManager() => instance;

  ApiQueueManager._internal();

  bool _isProcessing = false;

  Future<void> initialize() async {
    processQueue();
  }

  Future<void> enqueueAction(ActionModel action) async {
    await ApiQueueService.enqueue(action);
    debugPrint("Action enqueued: ${action.operationName}");
    processQueue();
  }

  Future<void> processQueue() async {
    if (_isProcessing || ApiQueueService.isEmpty()) return;
    _isProcessing = true;

    debugPrint("Processing queued actions...");

    while (!ApiQueueService.isEmpty()) {
      final action = ApiQueueService.peek();
      if (action == null) break;

      try {
        debugPrint("Variables: ${action.variables}");
        final result = await GraphQLService.callGraphQL(
          query: action.gqlDocument,
          variables: action.variables,
          isMutation: action.operationType.toLowerCase() == 'mutation',
        );

        if (!result.hasException) {
          await ApiQueueService.dequeue();
          debugPrint("Processed action successfully: ${action.operationName}");
        } else {
          debugPrint("GraphQL exception for ${action.operationName}: ${result.exception}");
          break; // stop here, keep item in queue
        }
      } catch (e) {
        debugPrint("Failed to process action ${action.operationName}: $e");
        break; // stop here, retry later
      }
    }

    _isProcessing = false;
  }

  Future<void> dispose() async {
    await ApiQueueService.clear();
  }
}
