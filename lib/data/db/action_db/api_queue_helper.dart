import 'package:flutter/material.dart';
import 'package:otper_mobile/data/db/action_db/action_model.dart';
import 'package:otper_mobile/data/db/action_db/api_queue_manager.dart';
import 'package:otper_mobile/data/db/action_db/api_queue_service.dart';

class ApiQueueHelper {

  Future<void> moveTo({
    required int cardId,
    required int toListId,
    int? overCardId,
  }) async {
    await GraphQLMutationQueue.enqueueMutation(
      operationName: "MoveTo",
      mutation: r'''
        mutation MoveTo($cardId: ID!, $toListId: ID!, $overCardId: ID) {
          MoveTo(input: { cardId: $cardId, toListId: $toListId, overCardId: $overCardId }) {
            success
          }
        }
      ''',
      variables: {
        "cardId": cardId,
        "toListId": toListId,
        "overCardId": overCardId,
      },
    );

    ApiQueueManager.instance.processQueue();
  }

  Future<void> reorderLists({
    required int activeListId,
    required int toListId,
  }) async {
    await GraphQLMutationQueue.enqueueMutation(
      operationName: "ReorderLists",
      mutation: r'''
        mutation ReorderLists($activeListId: ID!, $toListId: ID!) {
          reorderLists(input: { activelistId: $activeListId, toListId: $toListId }) {
            success
          }
        }
      ''',
      variables: {
        "activeListId": activeListId,
        "toListId": toListId,
      },
    );

    ApiQueueManager.instance.processQueue();
  }

}

class GraphQLMutationQueue {
  static Future<void> enqueueMutation({
    required String operationName,
    required String mutation,
    required Map<String, dynamic> variables,
  }) async {
    final action = ActionModel(
      operationType: "mutation",
      operationName: operationName,
      gqlDocument: mutation,
      variables: variables,
      headers: {"Content-Type": "application/json"},
    );

    await ApiQueueService.enqueue(action);
    int dbLength = ApiQueueService.length();
    debugPrint("Api DB length becomes : $dbLength");
  }
}
