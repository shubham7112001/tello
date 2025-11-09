import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:otper_mobile/app_graphql/graph_document.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';

class CardRepository {
  
  static Future<QueryResult> getCardBySlug(String slug) async {
    return await GraphQLService.callGraphQL(
      query: GraphDocument.cardBySlugQuery,
      variables: {'slug': slug},
    );
  }
  
}