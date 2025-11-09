import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:otper_mobile/app_graphql/graph_config.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';

class GraphQLService {
  static GraphConfig graphConfig = GraphConfig();

  GraphQLClient client = graphConfig.clientToQuery();

  /// Returns the actual QueryResult or MutationResult
  static Future<QueryResult> callGraphQL({
    required String query,
    Map<String, dynamic>? variables,
    bool isMutation = false,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      final client = GraphConfig().clientToQuery();
      log("GraphQL Variables $variables");

      final options = isMutation
          ? MutationOptions(
              document: gql(query),
              variables: variables ?? {},
              fetchPolicy: FetchPolicy.noCache,
            )
          : QueryOptions(
              document: gql(query),
              variables: variables ?? {},
              fetchPolicy: FetchPolicy.noCache,
            );

      final QueryResult result = isMutation
          ? await client.mutate(options as MutationOptions)
          : await client.query(options as QueryOptions);

      // Debug logs
      debugPrint("GraphQL Result hasException: ${result.hasException}");
      debugPrint("GraphQL Result Data: ${result.data}");

      if (result.hasException) {
        final errors = result.exception?.graphqlErrors ?? [];

        final shouldForceLogin = errors.any((e) =>
          e.message.contains("Unauthenticated") ||
          e.message.contains("Validation failed")
        );

        if (shouldForceLogin) {
          AppNavigator.goToLogin();
        }

        debugPrint("GraphQL error: ${result.exception.toString()}");
        return result;
      }

      return result; // ✅ return the actual QueryResult
    } catch (e, stackTrace) {
      debugPrint("GraphQL Exception: $e");
      debugPrint("StackTrace: $stackTrace");
      rethrow;
    }
  }
}
