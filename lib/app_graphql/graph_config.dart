import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:otper_mobile/data/db/auth_db/auth_db.dart';
import 'package:otper_mobile/data/db/auth_db/auth_db_helper.dart';

class GraphConfig {
  static String domainName = "https://otper.com/graphql";
  static String? token;
  static final AuthLink authLink = AuthLink(
    getToken: () async {
      try {
        final LoginTableDriftData? data = await AuthDbHelper.instance.getLatestLogin();
        debugPrint("Login Data: $data");
        if (data?.token != null) {
          token =  'Bearer ${data!.token}';
          return token;
        }
      } catch (e) {
        debugPrint("Error fetching token: $e");
      }
      return null; // no token
    },
  );

  static final HttpLink httpLink = HttpLink(
    domainName,
    defaultHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final Link link = authLink.concat(httpLink);

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(),
      queryRequestTimeout: const Duration(seconds: 30), 
    );
  }
}